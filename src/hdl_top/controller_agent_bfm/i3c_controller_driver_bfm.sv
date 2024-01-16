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

    drive_operation(dataPacketStruct.operation);

    sample_ack(dataPacketStruct.targetAddressStatus);

    if(dataPacketStruct.targetAddressStatus == NACK)begin
    end else begin
       if(dataPacketStruct.operation == WRITE) begin
         driveWriteDataAndSampleACK(dataPacketStruct,configPacketStruct);
       end else begin
         sampleReadDataAndDriveACK(dataPacketStruct,configPacketStruct);
       end
    end
      stop();
  endtask: drive_data


  task driveWriteDataAndSampleACK(inout i3c_transfer_bits_s dataPacketStruct,
                                  input i3c_transfer_cfg_s configPacketStruct);
    for(int i=0; i<dataPacketStruct.no_of_i3c_bits_transfer/DATA_WIDTH;i++) begin
      drive_writeDataByte(dataPacketStruct.writeData[i], 
                          configPacketStruct.dataTransferDirection);
      sample_ack(dataPacketStruct.writeDataStatus[i]);
      if(dataPacketStruct.writeDataStatus[i] == NACK)
        break;
    end
  endtask: driveWriteDataAndSampleACK


  task sampleReadDataAndDriveACK(inout i3c_transfer_bits_s dataPacketStruct,
                                 input i3c_transfer_cfg_s configPacketStruct);
    for(int i=0; i<dataPacketStruct.no_of_i3c_bits_transfer/DATA_WIDTH;i++) begin
      sample_read_data(dataPacketStruct.readData[i],
                       configPacketStruct.dataTransferDirection);
      drive_readDataStatus(dataPacketStruct.readDataStatus[i]);
      if(dataPacketStruct.readDataStatus[i] == NACK)
        break;
    end
  endtask: sampleReadDataAndDriveACK


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
   // Target address should always be driven with MSB as direction of transfer
   for(int k=TARGET_ADDRESS_WIDTH-1;k>=0 ;k--)begin
      scl_tristate_buf_on();
      state <= ADDRESS;
      drive_sda(addr[k]);
      scl_tristate_buf_off();
    end
  endtask :drive_address
  
  
  task drive_operation(input bit wrBit);
    `uvm_info("DEBUG", $sformatf("Driving operation Bit = %0b",wrBit), UVM_NONE)
    @(posedge pclk);
    drive_scl(0);
    state <= WR_BIT;
    drive_sda(wrBit);
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
  
  
  task drive_writeDataByte(input bit[7:0] wdata, input dataTransferDirection_e dir);
    `uvm_info("DEBUG", $sformatf("Driving writeData = %0b",wdata), UVM_NONE)

    `uvm_info("Controller_Driver_BFM", $sformatf("Direction %s", dir.name()), UVM_HIGH);
    for(int k=0, bit_no = 0; k<DATA_WIDTH; k++) begin
      // Logic for MSB first or LSB first 
      bit_no = (dir == MSB_FIRST) ? 
                ((DATA_WIDTH - 1) - k) : k;

      scl_tristate_buf_on();
      state <= WRITE_DATA;
      drive_sda(wdata[bit_no]);
      scl_tristate_buf_off();
    end
  endtask :drive_writeDataByte


  task sample_read_data(output bit [7:0]rdata, input dataTransferDirection_e dir);
    for(int k=0, bit_no=0; k<DATA_WIDTH; k++) begin
      // Logic for MSB first or LSB first 
      bit_no = (dir == MSB_FIRST) ? 
                ((DATA_WIDTH - 1) - k) : k;

      scl_tristate_buf_on();
      state <= READ_DATA;
      drive_sda(1);
      scl_tristate_buf_off();
      rdata[bit_no] <= sda_i;
    end
    `uvm_info("DEBUG", $sformatf("Moving readData = %0b",rdata), UVM_NONE)
  endtask: sample_read_data


  task drive_readDataStatus(input bit ack);
    @(posedge pclk);
    drive_scl(0);
    drive_sda(ack);
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
