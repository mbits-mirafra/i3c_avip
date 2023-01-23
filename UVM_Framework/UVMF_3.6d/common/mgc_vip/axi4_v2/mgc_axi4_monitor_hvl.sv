module mgc_axi4_monitor_hvl #(
   int ADDR_WIDTH,
   int RDATA_WIDTH,
   int WDATA_WIDTH,
   int ID_WIDTH,
   int USER_WIDTH,
   int REGION_MAP_SIZE,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   string VIP_IF_HDL_PATH
)();

`ifdef XRTL

   `include "mgc_axi4_hvl.svh"

   //
   // Bind the VTL API interface to the corresponding VTL XRTL BFM using given HDL path
   //
   initial begin
      // ??? There is no monitor (init function) vip_if.m_init({VIP_IF_HDL_PATH, ".vip_module"});
   end

`endif

endmodule: mgc_axi4_monitor_hvl
