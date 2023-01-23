#pragma once
#include "axi4_segment.h"

#include "mc_fifo.h"


enum dma_mode_t {COPY=0, SCATTER=1, GATHER=2};

/**
 *  * \brief dma address map as seen by the CPU
*/
struct dma_address_map
{
  uint32_t  ar_addr;        // source address (byte address as per AXI)
  uint32_t  aw_addr;        // target address (byte address as per AXI)
  uint32_t  total_len;      // total length to be copied in bytes
  uint32_t  scatter_stride; // stride between each scatter group, in bytes
  uint32_t  scatter_len;    // length of each scatter group, in bytes
  uint32_t  scatter_groups; // number of scatter groups
  uint32_t  dma_mode;       // COPY, SCATTER, GATHER
  uint32_t  start;          // DMA command is complete, cause it to be queued to start
};

/**
 *  * \brief dma command sent to the DMA engine
*/
struct dma_cmd
{
  NVUINTW(32) ar_addr {0};
  NVUINTW(32) aw_addr {0};
  NVUINTW(32) total_len {0};
  NVUINTW(32) scatter_stride {0};
  NVUINTW(16) scatter_len {0};
  NVUINTW(16) scatter_groups {0};
  NVUINTW(16) dma_mode {0};

  static const unsigned int width = (4 * 32) + (3 * 16);
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { 
    m &ar_addr;
    m &aw_addr;
    m &total_len;
    m &scatter_stride;
    m &scatter_len;
    m &scatter_groups;
    m &dma_mode;
  }
  inline friend void sc_trace(sc_trace_file *tf, const dma_cmd& v, const std::string& NAME ) {
      sc_trace(tf,v.ar_addr,        NAME + ".ar_addr");
      sc_trace(tf,v.aw_addr,        NAME + ".aw_addr");
      sc_trace(tf,v.total_len,      NAME + ".total_len");
      sc_trace(tf,v.scatter_stride, NAME + ".scatter_stride");
      sc_trace(tf,v.scatter_len,    NAME + ".scatter_len");
      sc_trace(tf,v.scatter_groups, NAME + ".scatter_groups");
      sc_trace(tf,v.dma_mode,       NAME + ".dma_mode");
  }

  inline friend std::ostream& operator<<(ostream& os, const dma_cmd& rhs)
  {
    os << rhs.ar_addr << " " 
       << rhs.aw_addr << " " 
       << rhs.total_len << " "
       << rhs.scatter_stride << " "
       << rhs.scatter_len << ""
       << rhs.scatter_groups << " "
       << rhs.dma_mode;
    return os;
  }
};

typedef axi::axi4_segment<axi::cfg::standard> local_axi;

/**
 *  * \brief dma module
*/
#pragma hls_design top
class scatter_gather_dma : public sc_module, public local_axi {
public:
  typedef typename axi::axi4<axi::cfg::lite_nowstrb> local_axi4_lite;

  sc_in<bool> CCS_INIT_S1(clk);
  sc_in<bool> CCS_INIT_S1(rst_bar);

  r_master<> CCS_INIT_S1(r_master0);
  w_master<> CCS_INIT_S1(w_master0);

  typename local_axi4_lite::read::template slave<> CCS_INIT_S1(r_slave0);
  typename local_axi4_lite::write::template slave<> CCS_INIT_S1(w_slave0);

  Connections::Out<bool> CCS_INIT_S1(dma_done);

  SC_CTOR(scatter_gather_dma)
  {
    SC_THREAD(slave_process);
    sensitive << clk.pos();
    async_reset_signal_is(rst_bar, false);

    SC_THREAD(master_process);
    sensitive << clk.pos();
    async_reset_signal_is(rst_bar, false);

    AXI4_W_SEGMENT_BIND(w_segment0, clk, rst_bar, w_master0);
    AXI4_R_SEGMENT_BIND(r_segment0, clk, rst_bar, r_master0);
  }

private:

  Connections::Combinational<dma_cmd> CCS_INIT_S1(dma_cmd_chan);
  
  // write and read segmenters segment long bursts to conform to AXI4 protocol (which allows 256 beats maximum).
  AXI4_W_SEGMENT(w_segment0)
  AXI4_R_SEGMENT(r_segment0)

  // master_process recieves dma_cmd transactions from the slave_process. 
  // the master_process performs the dma operations via the master0 axi port,
  // and then sends a done signal to the requester via the dma_done transaction.
  void master_process() {
    AXI4_W_SEGMENT_RESET(w_segment0, w_master0);
    AXI4_R_SEGMENT_RESET(r_segment0, r_master0);

    dma_cmd_chan.ResetRead();
    dma_done.Reset();

    wait();

    while(1) {
     dma_cmd cmd = dma_cmd_chan.Pop();

     switch (cmd.dma_mode) {
     case dma_mode_t::COPY: {
      ex_ar_payload ar;
      ex_aw_payload aw;
      ar.ex_len = (cmd.total_len / bytesPerBeat) - 1;
      aw.ex_len = (cmd.total_len / bytesPerBeat) - 1;
      ar.addr = cmd.ar_addr;
      aw.addr = cmd.aw_addr;
      r_segment0_ex_ar_chan.Push(ar);
      w_segment0_ex_aw_chan.Push(aw);

      #pragma hls_pipeline_init_interval 1
      #pragma pipeline_stall_mode flush
      while (1) {
       r_payload r = r_master0.r.Pop();
       w_payload w;
       w.data = r.data;
       w_segment0_w_chan.Push(w);

       if (ar.ex_len-- == 0)
        break;
      }

      b_payload b = w_segment0_b_chan.Pop();
      dma_done.Push(b.resp == Enc::XRESP::OKAY);
      break; 
      }

     case dma_mode_t::SCATTER: {
      ex_ar_payload ar;
      ex_aw_payload aw;
      ar.ex_len = (cmd.total_len / bytesPerBeat) - 1;
      aw.ex_len = (cmd.scatter_len / bytesPerBeat) - 1;
      ar.addr = cmd.ar_addr;
      aw.addr = cmd.aw_addr;
      r_segment0_ex_ar_chan.Push(ar);

      b_payload b;

      while (1) {
        w_segment0_ex_aw_chan.Push(aw);

        #pragma hls_pipeline_init_interval 1
        #pragma pipeline_stall_mode flush
        while (1) {
         r_payload r = r_master0.r.Pop();
         w_payload w;
         w.data = r.data;
         w_segment0_w_chan.Push(w);

         if (aw.ex_len-- == 0)
          break;
        }

        b = w_segment0_b_chan.Pop();
        aw.addr += cmd.scatter_stride;
        aw.ex_len = (cmd.scatter_len / bytesPerBeat) - 1;

        cmd.total_len -= cmd.scatter_len;
        if (cmd.total_len == 0)
          break;
      }

      dma_done.Push(b.resp == Enc::XRESP::OKAY);
      break;
      }

     case dma_mode_t::GATHER: {

      // will ask AEs to write below here:

      ex_ar_payload ar;
      ex_aw_payload aw;
      ar.ex_len = (cmd.scatter_len / bytesPerBeat) - 1;
      aw.ex_len = (cmd.total_len / bytesPerBeat) - 1;
      ar.addr = cmd.ar_addr;
      aw.addr = cmd.aw_addr;
      w_segment0_ex_aw_chan.Push(aw);

      while (1) {
        r_segment0_ex_ar_chan.Push(ar);

        #pragma hls_pipeline_init_interval 1
        #pragma pipeline_stall_mode flush
        while (1) {
         r_payload r = r_master0.r.Pop();
         w_payload w;
         w.data = r.data;
         w_segment0_w_chan.Push(w);

         if (ar.ex_len-- == 0)
          break;
        }

        ar.addr += cmd.scatter_stride;
        ar.ex_len = (cmd.scatter_len / bytesPerBeat) - 1;

        cmd.total_len -= cmd.scatter_len;
        if (cmd.total_len == 0)
          break;
      }

      b_payload b = w_segment0_b_chan.Pop();
      dma_done.Push(b.resp == Enc::XRESP::OKAY);
      break;

      // will ask AEs to write code above here
      }

     default:
      break;
     }
    }
  }

  // slave_process accepts incoming axi4 requests from slave0 and programs the dma registers.
  // when the start register is written to, a dma_cmd transaction is sent to the dma master_process
  void slave_process() {
    r_slave0.reset();
    w_slave0.reset();
    dma_cmd_chan.ResetWrite();

    wait();

    dma_cmd cmd1;

    while(1) {
      local_axi4_lite::AddrPayload aw;
      local_axi4_lite::WritePayload w;
      local_axi4_lite::WRespPayload b;
      // for future support of axi4 READS of dma_cmd registers...
      // local_axi4_lite::AddrPayload ar_lite_payload;
      // local_axi4_lite::ReadPayload r_lite_payload;

      w_slave0.wread(aw, w);
      {
        b.resp = Enc::XRESP::SLVERR;
        switch (aw.addr)
        {
        case offsetof(dma_address_map, ar_addr):
          cmd1.ar_addr = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, aw_addr):
          cmd1.aw_addr = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, dma_mode):
          cmd1.dma_mode = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, total_len):
          cmd1.total_len = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, scatter_len):
          cmd1.scatter_len = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, scatter_groups):
          cmd1.scatter_groups = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, scatter_stride):
          cmd1.scatter_stride = w.data;
          b.resp = Enc::XRESP::OKAY;
        break;

        case offsetof(dma_address_map, start):
          if ((cmd1.ar_addr & (bytesPerBeat-1)) ||
              (cmd1.aw_addr & (bytesPerBeat-1)) ||
              (cmd1.total_len & (bytesPerBeat-1)))
          {
	         CCS_LOG("discarding invalid DMA command");
    	      break;
          }
          if (cmd1.dma_mode != dma_mode_t::COPY)
            if ((cmd1.scatter_len & (bytesPerBeat-1)) ||
               (cmd1.scatter_stride & (bytesPerBeat-1)) ||
               (cmd1.scatter_len * cmd1.scatter_groups != cmd1.total_len))
            {
	           CCS_LOG("discarding invalid DMA command");
    	        break;
            }
          dma_cmd_chan.Push(cmd1);
          b.resp = Enc::XRESP::OKAY;
        break;

	     default:
	     break;

        }
        w_slave0.b.Push(b);
      }
    }
  }
};
