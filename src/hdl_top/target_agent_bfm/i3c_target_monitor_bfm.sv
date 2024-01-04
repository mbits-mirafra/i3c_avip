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
  
  string name = "I3C_TARGET_MONITOR_BFM";
  i3c_target_monitor_proxy i3c_target_mon_proxy_h; 
 
  i3c_fsm_state_e state;
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
    
    sample_target_address(struct_packet.targetAddress,struct_packet.targetAddressStatus);
    sample_operation(struct_packet.operation);
    sampleAddressAck(struct_packet.targetAddressStatus);
    if(struct_packet.targetAddressStatus == ACK) begin
      if(struct_packet.operation == WRITE) begin
       // GopalS:  sample_write_data(struct_packet.writeData[0],struct_packet.no_of_i3c_bits_transfer);
       // GopalS:  sampleWdataAck(struct_packet.writeDataStatus[0]);

      fork
        begin
          for(int i=0;i<MAXIMUM_BYTES;i++) begin
            sample_write_data(struct_packet,i);
            sampleWdataAck(struct_packet.writeDataStatus[i]);
          end
        end

        begin
          wrDetect_stop();
        end
      join_any
      disable fork;

      end else begin
          sample_read_data(struct_packet.readData[0],struct_packet.no_of_i3c_bits_transfer);
          sample_ack(struct_packet.readDataStatus[0]);

     // GopalS:    fork
     // GopalS:      begin
     // GopalS:        for(int i=0;i<MAXIMUM_BYTES;i++) begin
     // GopalS:          sample_read_data(struct_packet,i);
     // GopalS:          sample_ack(struct_packet.readDataStatus[i]);
     // GopalS:        end
     // GopalS:      end

     // GopalS:      begin
     // GopalS:        wrDetect_stop();
     // GopalS:      end
     // GopalS:    join_any
     // GopalS:    disable fork;

        end
      end else begin
      detect_stop();
    end
     // GopalS:   detect_stop();
  endtask: sample_data
  
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
  
  task sample_target_address(output bit [6:0] address, output bit ack);
  
    @(posedge pclk);
    state = ADDRESS;
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
    state = WR_BIT;
    detect_posedge_scl();
    operation = sda_i;
   if(operation == 0)
     wr_rd = WRITE;
   else
     wr_rd = READ;
  endtask: sample_operation
  
  task sampleAddressAck(output bit ack);
    @(posedge pclk); 
    state = ACK_NACK;
    detect_negedge_scl();
    @(posedge pclk); 
    ack = sda_i;
    @(posedge pclk); 
  endtask: sampleAddressAck
  
/*
  task sample_write_data(output bit [7:0] wdata, output int bitsTransfer);
    state = WRITE_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_posedge_scl();
      wdata[k] = sda_i;
      bitsTransfer++;
    end
  endtask: sample_write_data
  */

  task sample_write_data(output i3c_transfer_bits_s pkt, input int i);
    bit[DATA_WIDTH-1:0] wdata;
    state = WRITE_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_posedge_scl();
      wdata[k] = sda_i;
      pkt.no_of_i3c_bits_transfer++;
    end
    pkt.writeData[i] = wdata;
  endtask: sample_write_data
  

  task sampleWdataAck(output bit ack);
    state = ACK_NACK;
    detect_negedge_scl();
    ack = sda_i;
    repeat(2)
     @(posedge pclk); 
  endtask: sampleWdataAck
  
  
  task sample_read_data(output bit[7:0] rdata, output int bitsTransfer);
    state = READ_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_negedge_scl();
      rdata[k] = sda_i;
      bitsTransfer++;
    end
  endtask :sample_read_data
  
/*
  task sample_read_data(inout i3c_transfer_bits_s pkt,input int i);
    bit [DATA_WIDTH-1:0] rdata;
    state = READ_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_negedge_scl();
      rdata[k] = sda_i;
      pkt.no_of_i3c_bits_transfer++;
    end
    pkt.readData[i] = rdata;
  endtask :sample_read_data
  */

  task sample_ack(output bit ack);
    detect_negedge_scl();
    state    = ACK_NACK;
    ack = sda_i;
    detect_negedge_scl();
  endtask :sample_ack
  

  task wrDetect_stop();
    // 2bit shift register to check the edge on sda and stability on scl
    bit [1:0] scl_local;
    bit [1:0] sda_local;

    // GopalS: state = STOP;
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
