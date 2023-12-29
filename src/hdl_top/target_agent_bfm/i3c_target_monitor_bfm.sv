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
  endtask: wait_for_idle_state
  
  task sample_data(inout i3c_transfer_bits_s struct_packet,inout i3c_transfer_cfg_s struct_cfg);
    detect_start();
    
    sample_target_address(struct_packet.targetAddress,struct_packet.targetAddressStatus);
    sample_operation(struct_packet.operation);
    sampleAddressAck(struct_packet.targetAddressStatus);
    if(struct_packet.targetAddressStatus == ACK) begin
      if(struct_packet.operation == WRITE) begin
        sample_write_data(struct_packet.writeData[0]);
        sampleWdataAck();
      end else begin
          sample_read_data(struct_packet.readData[0]);
          sample_ack();
        end
      end else begin
      detect_stop();
    end
       detect_stop();
  endtask: sample_data
  
  task detect_start();
    bit [1:0] scl_local;
    bit [1:0] sda_local;
  
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == NEGEDGE && scl_local == 2'b11) );
  endtask: detect_start
  
  task sample_target_address(output bit [6:0] address, output bit ack);
  
    @(posedge pclk);
    for(int k=0;k < 7; k++) begin
      detect_posedge_scl();
      address[k] = sda_i;
    end
  
    if(address[6:0] != 7'b1010101) begin
      ack = NACK;
    end
    else begin
      ack = ACK;
    end
  endtask: sample_target_address
  
  task sample_operation(output operationType_e wr_rd);
    bit operation;
    @(posedge pclk); 
    detect_posedge_scl();
    operation = sda_i;
   if(operation == 0)
     wr_rd = WRITE;
   else
     wr_rd = READ;
  endtask: sample_operation
  
  task sampleAddressAck(output bit ack);
    @(posedge pclk); 
    detect_negedge_scl();
    ack = sda_i;
    repeat(2)
      @(posedge pclk); 
  endtask: sampleAddressAck
  
  task sample_write_data(output bit [7:0] wdata);
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_posedge_scl();
      wdata[k] = sda_i;
    end
  endtask: sample_write_data
  
  task sampleWdataAck();
    @(posedge pclk); 
    detect_negedge_scl();
    repeat(2)
     @(posedge pclk); 
  endtask: sampleWdataAck
  
  
  task sample_read_data(output bit[7:0] rdata);
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_negedge_scl();
      rdata[k] = sda_i;
      detect_posedge_scl();
    end
  endtask :sample_read_data
  
  task sample_ack();
    detect_negedge_scl();
    detect_posedge_scl();
  endtask :sample_ack
  
  task detect_stop();
    bit [1:0] scl_local;
    bit [1:0] sda_local;
  
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == POSEDGE && scl_local == 2'b11) );
  endtask: detect_stop
  
  
  task detect_posedge_scl();
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;
  
    scl_local = 2'b11;
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == POSEDGE));
  
    scl_edge_value = edge_detect_e'(scl_local);
  endtask: detect_posedge_scl
    
  task detect_negedge_scl();
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;
  
    scl_local = 2'b11;
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == NEGEDGE));
  
    scl_edge_value = edge_detect_e'(scl_local);
  
  endtask: detect_negedge_scl

endinterface : i3c_target_monitor_bfm

`endif
