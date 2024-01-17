`ifndef I3C_TARGET_MONITOR_BFM_INCLUDED_
`define I3C_TARGET_MONITOR_BFM_INCLUDED_

import i3c_globals_pkg::*; 

interface i3c_target_monitor_bfm(input pclk, 
                                input areset, 
                                input scl_i,
                                input scl_o,
                                input scl_oen,
                                input sda_i,
                                input sda_o,
                                input sda_oen);

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import i3c_target_pkg::*;
  import i3c_target_pkg::i3c_target_monitor_proxy;
  
  i3c_target_monitor_proxy i3c_target_mon_proxy_h; 
  i3c_fsm_state_e state;

  string name = "I3C_TARGET_MONITOR_BFM";
  initial begin
    $display("target Monitor BFM");
  end
 
  task wait_for_reset();
    @(negedge areset);
    @(posedge areset);
  endtask: wait_for_reset

  task sample_idle_state();
    @(posedge pclk);
  endtask: sample_idle_state
  
  task wait_for_idle_state();
    @(posedge pclk);
    while(scl_i!=1 && sda_i!=1) begin
     @(posedge pclk);
    end
    state = IDLE;
  endtask: wait_for_idle_state
  
  task sample_data(inout i3c_transfer_bits_s struct_packet,inout i3c_transfer_cfg_s struct_cfg);

    detect_start();
    sample_target_address(struct_packet);
    sample_operation(struct_packet.operation);
    sampleAddressAck(struct_packet.targetAddressStatus);
    if(struct_packet.targetAddressStatus == ACK) begin
      if(struct_packet.operation == WRITE) begin
        sampleWriteDataAndACK(struct_packet, struct_cfg);
      end else begin
        sampleReadDataAndACK(struct_packet, struct_cfg);
        end
      end else begin
      detect_stop();
    end
  endtask: sample_data
  

  task sampleWriteDataAndACK(inout i3c_transfer_bits_s structPacket,
                             input i3c_transfer_cfg_s structConfig);
    fork
      begin
        for(int i=0;i<MAXIMUM_BYTES;i++) begin
          sample_write_data(structPacket,
                            i,
                            structConfig.dataTransferDirection);
          sampleWdataAck(structPacket.writeDataStatus[i]);
          if(structPacket.writeDataStatus[i] == NACK)
            break;
        end
      end
    join_none

    wrDetect_stop();
    disable fork;
  endtask: sampleWriteDataAndACK 


  task sampleReadDataAndACK(inout i3c_transfer_bits_s structPacket,
                             input i3c_transfer_cfg_s structConfig);
    fork
      begin
        for(int i=0;i<MAXIMUM_BYTES;i++) begin
          sample_read_data(structPacket,i,
                           structConfig.dataTransferDirection);
          sample_ack(structPacket.readDataStatus[i]);
          if(structPacket.readDataStatus[i] == NACK)
            break;
        end
      end
    join_none

    wrDetect_stop();
    disable fork;
  endtask: sampleReadDataAndACK 
  

  task detect_start();
    bit [1:0] scl_local;
    bit [1:0] sda_local;
    state = START;
  
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == NEGEDGE && scl_local == 2'b11) );
  endtask: detect_start
  

  task sample_target_address(inout i3c_transfer_bits_s pkt);
    bit [TARGET_ADDRESS_WIDTH-1:0] address;
    state = ADDRESS;
    for(int k=TARGET_ADDRESS_WIDTH-1;k>=0; k--) begin
      detectEdge_scl(POSEDGE);
      address[k] = sda_i;
    end
    pkt.targetAddress = address;
  endtask: sample_target_address
  

  task sample_operation(output operationType_e wr_rd);
    bit operation;
    state = WR_BIT;
    detectEdge_scl(POSEDGE);
    operation = sda_i;
   if(operation == 0)
     wr_rd = WRITE;
   else
     wr_rd = READ;
  endtask: sample_operation
  

  task sampleAddressAck(output bit ack);
    state = ACK_NACK;
    detectEdge_scl(POSEDGE);
    ack = sda_i;
  endtask: sampleAddressAck
  

  task sample_write_data(inout i3c_transfer_bits_s pkt, input int i, input dataTransferDirection_e dir);
    bit[DATA_WIDTH-1:0] wdata;
    state = WRITE_DATA;

    `uvm_info("DEBUG_TARGET_MONITOR_BFM", $sformatf("dir %s ",dir.name()), UVM_HIGH);
    for(int k=0, bit_no = 0; k<DATA_WIDTH; k++) begin
      // Logic for MSB first or LSB first 
      bit_no = (dir == MSB_FIRST) ? 
                ((DATA_WIDTH - 1) - k) : k;

      detectEdge_scl(POSEDGE);
      wdata[bit_no] = sda_i;
      `uvm_info("DEBUG_MSHA_MONITOR_BFM", $sformatf(" bit_no = %0d, sda_i = %0d wdata[bit_no] = %0d \n wdata = %0b",bit_no,sda_i,wdata[bit_no], wdata), UVM_HIGH);
      pkt.no_of_i3c_bits_transfer++;
    end
    pkt.writeData[i] = wdata;
    `uvm_info("DEBUG_TARGET_MONITOR_BFM", $sformatf(" i = %0d, wdata %0x",i, wdata), UVM_HIGH);
  endtask: sample_write_data
  

  task sampleWdataAck(output bit ack);
    state = ACK_NACK;
    detectEdge_scl(POSEDGE);
    ack = sda_i;
  endtask: sampleWdataAck
  

  task sample_read_data(inout i3c_transfer_bits_s pkt,input int i, input dataTransferDirection_e dir);
    bit [DATA_WIDTH-1:0] rdata;
    state = READ_DATA;
    for(int k=0, bit_no = 0; k<DATA_WIDTH; k++) begin
      // Logic for MSB first or LSB first 
      bit_no = (dir == MSB_FIRST) ? 
                ((DATA_WIDTH - 1) - k) : k;

      detectEdge_scl(POSEDGE);
      rdata[bit_no] = sda_i;
      pkt.no_of_i3c_bits_transfer++;
    end
    pkt.readData[i] = rdata;
  endtask :sample_read_data
  

  task sample_ack(output bit ack);
    state    = ACK_NACK;
    detectEdge_scl(POSEDGE);
    ack = sda_i;
  endtask :sample_ack
  

  task wrDetect_stop();
    // 2bit shift register to check the edge on sda and stability on scl
    bit [1:0] scl_local;
    bit [1:0] sda_local;

    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == POSEDGE && scl_local == 2'b11) );
    state = STOP;
    `uvm_info(name, $sformatf("Stop condition is detected"), UVM_HIGH);
  endtask: wrDetect_stop
  

  task detect_stop();
    bit [1:0] scl_local;
    bit [1:0] sda_local;
    state = STOP;
  
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == POSEDGE && scl_local == 2'b11) );
  endtask: detect_stop
  

  task detectEdge_scl(input edge_detect_e edgeSCL);
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;
    // default value of scl_local is logic 1
    scl_local = 2'b11;

    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == edgeSCL));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("TARGET_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  endtask: detectEdge_scl
  
endinterface : i3c_target_monitor_bfm

`endif
