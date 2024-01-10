`ifndef I3C_CONTROLLER_DRIVER_BFM_INCLUDED_
`define I3C_CONTROLLER_DRIVER_BFM_INCLUDED_

import i3c_globals_pkg::*;

interface i3c_controller_driver_bfm(input pclk, 
                                input areset,
                                input scl_i,
                                output reg scl_o,
                                output reg scl_oen,
                                input sda_i,
                                output reg sda_o,
                                output reg sda_oen
                              );
  i3c_fsm_state_e state;

  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  import i3c_controller_pkg::i3c_controller_driver_proxy;

  i3c_controller_driver_proxy i3c_controller_drv_proxy_h;
  
  string name = "I3C_CONTROLLER_DRIVER_BFM";
  initial begin
    $display(name);
  end

  task wait_for_reset();
    state = RESET_DEACTIVATED;
    @(negedge areset);
    state = RESET_ACTIVATED;
    @(posedge areset);
    state = RESET_DEACTIVATED;
  endtask: wait_for_reset

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
    `uvm_info(name, $sformatf("I3C bus is free state detected"), UVM_HIGH);
  endtask: wait_for_idle_state

  task sda_tristate_buf_on();
    @(posedge pclk);
     drive_sda(0);
  endtask

  task scl_tristate_buf_on();
    @(posedge pclk);
     drive_scl(0);
  endtask

  task scl_tristate_buf_off();
    @(posedge pclk);
     drive_scl(1);
  endtask


  task drive_data(inout i3c_transfer_bits_s dataPacketStruct, 
                  input i3c_transfer_cfg_s configPacketStruct); 
    `uvm_info(name, $sformatf("Starting the drive data method"), UVM_HIGH);
  
    drive_start();
    drive_address(dataPacketStruct.targetAddress);
    `uvm_info("DEBUG", $sformatf("Address is sent, address = %0h",dataPacketStruct.targetAddress), UVM_NONE)
    drive_operation(dataPacketStruct.operation);
    `uvm_info("DEBUG", $sformatf("operation Bit is sent, operation = %0b",dataPacketStruct.operation), UVM_NONE)
    sample_ack(dataPacketStruct.targetAddressStatus);
        `uvm_info("BFM", $sformatf("UT dataPacket.targetAddressStatus = %0d", dataPacketStruct.targetAddressStatus), UVM_NONE)
    if(dataPacketStruct.targetAddressStatus == NACK)begin
      `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 1 and stop condition is triggered"), UVM_HIGH);
    end else begin
      `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 0"), UVM_HIGH);
       if(dataPacketStruct.operation == WRITE) begin
          for(int i=0; i<dataPacketStruct.no_of_i3c_bits_transfer/DATA_WIDTH;i++) begin
            drive_writeDataByte(dataPacketStruct.writeData[i]);
            sample_ack(dataPacketStruct.writeDataStatus[i]);
            if(dataPacketStruct.writeDataStatus[i] == NACK)
              break;
          end
        end else begin
          for(int i=0; i<dataPacketStruct.no_of_i3c_bits_transfer/DATA_WIDTH;i++) begin
            sample_read_data(dataPacketStruct.readData[i]);
            drive_readDataStatus(dataPacketStruct.readDataStatus[i]);
            if(dataPacketStruct.readDataStatus[i] == NACK)
              break;
          end
        end
    end
      stop();
  endtask: drive_data


  task drive_start();
    @(posedge pclk);
    drive_scl(1);
    drive_sda(1);
    state = START;
  
    @(posedge pclk);
    drive_scl(1);
    drive_sda(0);
    `uvm_info(name, $sformatf("Driving start condition"), UVM_MEDIUM);
  endtask :drive_start
  
  
  task drive_address(input bit[6:0] addr);
    `uvm_info("DEBUG", $sformatf("Driving Address = %0b",addr), UVM_NONE)
    for(int k=0;k < TARGET_ADDRESS_WIDTH; k++) begin
      scl_tristate_buf_on();
      state <= ADDRESS;
      sda_oen <= TRISTATE_BUF_ON;
      sda_o   <= addr[k];
      scl_tristate_buf_off();
    end
  endtask :drive_address
  
  
  task drive_operation(input bit wrBit);
    `uvm_info("DEBUG", $sformatf("Driving operation Bit = %0b",wrBit), UVM_NONE)
    @(posedge pclk);
    drive_scl(0);
    state <= WR_BIT;
    sda_oen <= TRISTATE_BUF_ON;
    sda_o   <= wrBit;
    scl_tristate_buf_off();
  endtask :drive_operation
  
  
  task sample_ack(output bit p_ack);
    @(posedge pclk);
    drive_scl(0);
    drive_sda(1);
  
    state <= ACK_NACK;
    @(posedge pclk);
    drive_scl(1);
  
    p_ack = sda_i;
    `uvm_info(name, $sformatf("Sampled ACK value %0b",p_ack), UVM_MEDIUM);
  endtask :sample_ack
  
   
  task stop();
    @(posedge pclk);
    scl_oen <= TRISTATE_BUF_ON;
    scl_o   <= 0;
    state <= STOP;

    @(posedge pclk);
    drive_scl(1);
    drive_sda(0);
   
    @(posedge pclk);
    drive_scl(1);
    drive_sda(1);
    @(posedge pclk);
  endtask
  
  
  task drive_writeDataByte(input bit[7:0] wdata);
    `uvm_info("DEBUG", $sformatf("Driving writeData = %0b",wdata), UVM_NONE)
    for(int k=DATA_WIDTH-1; k>=0; k--) begin
      scl_tristate_buf_on();
      state <= WRITE_DATA;
      sda_oen <= TRISTATE_BUF_ON;
      sda_o   <= wdata[k];
      scl_tristate_buf_off();
    end
  endtask :drive_writeDataByte


  task sample_read_data(output bit [7:0]rdata);
    for(int k=DATA_WIDTH-1; k>=0; k--) begin
      scl_tristate_buf_on();
      state <= READ_DATA;
      drive_sda(1);
      scl_tristate_buf_off();
      rdata[k] <= sda_i;
    end
    `uvm_info("DEBUG", $sformatf("Moving readData = %0b",rdata), UVM_NONE)
  endtask: sample_read_data


  task drive_readDataStatus(input bit ack);
    @(posedge pclk);
    drive_scl(0);

    sda_oen <= TRISTATE_BUF_ON;
    sda_o   <= ack;
    state <= ACK_NACK;
    
    @(posedge pclk);
    drive_scl(1);
  endtask: drive_readDataStatus 
  
  
  task drive_sda(input bit value);
    sda_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    sda_o   <= value;
  endtask: drive_sda
  
  task drive_scl(input bit value);
    scl_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    scl_o   <= value;
  endtask: drive_scl
  
endinterface : i3c_controller_driver_bfm
`endif
