`ifndef I3C_TARGET_DRIVER_BFM_INCLUDED_
`define I3C_TARGET_DRIVER_BFM_INCLUDED_

import i3c_globals_pkg::*;
interface i3c_target_driver_bfm #(parameter string NAME = "I3C_target_DRIVER_BFM")
                               (input pclk, 
                               input areset,
                               input scl_i,
                               output reg scl_o,
                               output reg scl_oen,
                               input sda_i,
                               output reg sda_o,
                               output reg sda_oen);
  
  i3c_fsm_state_e state;
  i3c_transfer_bits_s dataPacketStruck;
  i3c_transfer_cfg_s configPacketStruck;
  bit [7:0] rdata;

  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  import i3c_target_pkg::i3c_target_driver_proxy;
  
  i3c_target_driver_proxy i3c_target_drv_proxy_h;
  
  initial begin
    $display(NAME);
  end
  
  task wait_for_system_reset();
    state = RESET_DEACTIVATED;
    @(negedge areset);
    state = RESET_ACTIVATED;
    @(posedge areset);
    state = RESET_DEACTIVATED;
  endtask: wait_for_system_reset


  task drive_idle_state();
    @(posedge pclk);
    drive_scl(1);
    drive_sda(1);
    state <= IDLE;
  endtask: drive_idle_state


  task wait_for_idle_state();
    @(posedge pclk);
    while(scl_i!=1 && sda_i!=1) begin
      @(posedge pclk);
    end
    state = IDLE;
    `uvm_info(NAME, $sformatf("I3C bus is free state detected"), UVM_HIGH);
  endtask: wait_for_idle_state


  task drive_data(inout i3c_transfer_bits_s dataPacketStruck, 
                  inout i3c_transfer_cfg_s configPacketStruck);
  
    detect_start();
    sample_target_address(configPacketStruck,dataPacketStruck);
    sample_operation(dataPacketStruck.operation);
    driveAddressAck(dataPacketStruck.targetAddressStatus);

    if(dataPacketStruck.targetAddressStatus == ACK) begin
      if(dataPacketStruck.operation == WRITE) begin
        fork
          begin
            for(int i=0;i<MAXIMUM_BYTES;i++) begin
              sample_write_data(configPacketStruck,dataPacketStruck,i);
              driveWdataAck(dataPacketStruck.writeDataStatus[i]);
              if(dataPacketStruck.writeDataStatus[i] == NACK)
                break;
            end
          end
        join_none

        wrDetect_stop();
        disable fork;
      end else begin
        fork
          begin
            for(int i=0;i<MAXIMUM_BYTES;i++) begin
              if(configPacketStruck.targetFIFOMemory.size()==0) begin
                rdata = configPacketStruck.defaultReadData;
              end else begin
                rdata = configPacketStruck.targetFIFOMemory.pop_front();
              end
              drive_read_data(rdata,dataPacketStruck,i);
              sample_ack(dataPacketStruck.readDataStatus[i]);
              if(dataPacketStruck.readDataStatus[i] == NACK)
                break;
            end
          end
       join_none

        wrDetect_stop();
        disable fork;
      end
    end else begin
      detect_stop();
    end
  endtask: drive_data
  

  task detect_start();
    // 2bit shift register to check the edge on sda and stability on scl
    bit [1:0] scl_local;
    bit [1:0] sda_local;

    state = START;
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == NEGEDGE && scl_local == 2'b11) );
    `uvm_info(NAME, $sformatf("Start condition is detected"), UVM_HIGH);
  endtask: detect_start


  task sample_target_address(inout i3c_transfer_cfg_s cfg_pkt, inout i3c_transfer_bits_s pkt);
    bit [TARGET_ADDRESS_WIDTH-1:0] local_addr;

    state = ADDRESS;
    for(int k=0;k < 7; k++) begin
      detect_posedge_scl();
      local_addr[k] = sda_i;
      drive_sda(1);
    end

    `uvm_info(NAME, $sformatf("DEBUG :: Value of local_addr = %0x", local_addr[6:0]), UVM_NONE); 
    pkt.targetAddress = local_addr;

    `uvm_info(NAME, $sformatf("DEBUG :: Value of target_address = %0x", cfg_pkt.targetAddress), UVM_NONE); 
   
    if(local_addr != cfg_pkt.targetAddress) begin
      pkt.targetAddressStatus = NACK;
    end
    else begin
      pkt.targetAddressStatus = ACK;
    end
  endtask: sample_target_address


  task sample_operation(output operationType_e wr_rd);
    bit operation;

    state = WR_BIT;
    detect_posedge_scl();
    operation = sda_i;
    drive_sda(1);

    if(operation == 1'b0) begin
      wr_rd = WRITE;
    end else begin
      wr_rd = READ;
    end
  endtask: sample_operation


  task driveAddressAck(input bit ack);
    state = ACK_NACK;
    detect_negedge_scl();
    drive_sda(ack); 
    //TODO write detect_edge
    detect_edge_scl();
    drive_sda(1);
  endtask: driveAddressAck

  task driveWdataAck(input bit ack);
    state = ACK_NACK;
    detect_negedge_scl();
    drive_sda(ack); 
    //TODO
    detect_edge_scl();
    drive_sda(1);
  endtask: driveWdataAck

  task detect_posedge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;
    // default value of scl_local is logic 1
    scl_local = 2'b11;

    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == POSEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("TARGET_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  endtask: detect_posedge_scl
  
  task detect_negedge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;
    // default value of scl_local is logic 1
    scl_local = 2'b11;

    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == NEGEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("target_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  endtask: detect_negedge_scl

  task detect_edge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;
    // default value of scl_local is logic 1
    scl_local = 2'b10;

    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == POSEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("TARGET_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  endtask: detect_edge_scl

  task drive_sda(input bit value);
    sda_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    sda_o   <= value;
  endtask: drive_sda

  
  task drive_scl(input bit value);
    scl_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    scl_o   <= value;
  endtask: drive_scl


  task sample_write_data(inout i3c_transfer_cfg_s cfg_pkt, inout i3c_transfer_bits_s pkt, input int i);
    bit [DATA_WIDTH-1:0] wdata;
    state = WRITE_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_posedge_scl();
      wdata[k] = sda_i;
      pkt.no_of_i3c_bits_transfer++;
    end

    `uvm_info(NAME, $sformatf("DEBUG :: Value of sampled write data = %0x", wdata[7:0]), UVM_NONE); 
    cfg_pkt.targetFIFOMemory.push_back(wdata);
   
    pkt.writeData[i] = wdata;
    pkt.writeDataStatus[i] = ACK;
  endtask: sample_write_data


  task drive_read_data(input bit[7:0] rdata,inout i3c_transfer_bits_s pkt,input int i);

    `uvm_info("DEBUG", $sformatf("Driving byte = %0b",rdata), UVM_NONE)
    state = READ_DATA;
    for(int k=0;k < DATA_WIDTH; k++) begin
      detect_negedge_scl();
      sda_oen <= TRISTATE_BUF_ON;
      sda_o   <= rdata[k];
      pkt.no_of_i3c_bits_transfer++;
    end
    pkt.readData[i] = rdata;
    // TODO detect_edge
    detect_edge_scl();
    drive_sda(1); 
  endtask :drive_read_data


  task sample_ack(output bit ack);
    state    = ACK_NACK;
    detect_posedge_scl();
    ack     = sda_i;
    //TODO
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
    `uvm_info(NAME, $sformatf("Stop condition is detected"), UVM_HIGH);
  endtask: wrDetect_stop


  task detect_stop();
    // 2bit shift register to check the edge on sda and stability on scl
    bit [1:0] scl_local;
    bit [1:0] sda_local;

    state = STOP;
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
      sda_local = {sda_local[0], sda_i};
    end while(!(sda_local == POSEDGE && scl_local == 2'b11) );
    `uvm_info(NAME, $sformatf("Stop condition is detected"), UVM_HIGH);
  endtask: detect_stop

endinterface : i3c_target_driver_bfm

`endif
