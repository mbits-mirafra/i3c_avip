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
                                //Illegal inout port connection
                                //inout scl,
                                //inout sda);
                              );
  i3c_fsm_state_e state;
  i3c_transfer_bits_s dataPacketStruct;
  i3c_transfer_cfg_s configPacketStruct;
  bit ack;

  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  
  import i3c_controller_pkg::i3c_controller_driver_proxy;

  //Variable : controller_driver_proxy_h
  //Creating the handle for proxy driver
  i3c_controller_driver_proxy i3c_controller_drv_proxy_h;
  
  // Variable: name
  // Stores the name for this module
  string name = "I3C_controller_DRIVER_BFM";

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

  // TODO(mshariff): Put more comments for logic pf SCL and SDA

  task drive_idle_state();
    @(posedge pclk);

    scl_oen <= TRISTATE_BUF_OFF;
    scl_o   <= 1;

    sda_oen <= TRISTATE_BUF_OFF;
    sda_o   <= 1;

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

  // task for driving the sda_oen as high and sda as low
   task sda_tristate_buf_on();
    @(posedge pclk);
    sda_oen <= TRISTATE_BUF_ON;
    sda_o   <= 0;
   endtask

  // task for driving the scl_oen as high and scl as low
  task scl_tristate_buf_on();
    @(posedge pclk);
    scl_oen <= TRISTATE_BUF_ON;
    scl_o   <= 0;
  endtask

  // task for driving the scl_oen as high and scl as low
  task scl_tristate_buf_off();
    @(posedge pclk);
    scl_oen <= TRISTATE_BUF_OFF;
    scl_o   <= 1;
  endtask

 //-------------------------------------------------------
 // Task: drive_data
 //-------------------------------------------------------
 task drive_data(inout i3c_transfer_bits_s p_data_packet, 
                 input i3c_transfer_cfg_s p_cfg_pkt); 

  bit operationBit;
  bit [TARGET_ADDRESS_WIDTH-1:0] address7Bits;
  bit [DATA_WIDTH-1:0] writeData8Bits;

  `uvm_info(name, $sformatf("Starting the drive data method"), UVM_HIGH);
  dataPacketStruct = p_data_packet;
  configPacketStruct = p_cfg_pkt;

  drive_start();

  drive_address(dataPacketStruct.targetAddress);
  `uvm_info("DEBUG", $sformatf("Address is sent, address = %0h",dataPacketStruct.targetAddress), UVM_NONE)

  drive_operation(dataPacketStruct.operation);
  `uvm_info("DEBUG", $sformatf("operation Bit is sent, operation = %0b",dataPacketStruct.operation), UVM_NONE)

  // GopalS: {operationBit,address7Bits} = {dataPacketStruct.operation,dataPacketStruct.targetAddress};
  // GopalS: drive_byte({address7Bits, operationBit});
  // GopalS: `uvm_info("DEBUG", $sformatf("Address is sent, address = %0h, operation = %0b",address7Bits, operationBit), UVM_NONE)

  sample_ack(dataPacketStruct.targetAddressStatus);
      `uvm_info("BFM", $sformatf("UT dataPacket.targetAddressStatus = %0d", dataPacketStruct.targetAddressStatus), UVM_NONE)
  if(dataPacketStruct.targetAddressStatus == 1'b1)begin
    stop();
    `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 1 and stop condition is triggered"), UVM_HIGH);
  end else begin
    `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 0"), UVM_HIGH);
     if(dataPacketStruct.operation == 0) begin
        for(int i=0; i<dataPacketStruct.no_of_i3c_bits_transfer/DATA_WIDTH;i++) begin
          writeData8Bits = dataPacketStruct.writeData[i];
          drive_writeDataByte(writeData8Bits);
          `uvm_info("DEBUG", $sformatf("Driving Write data %0h",writeData8Bits), UVM_NONE)

          sample_ack(dataPacketStruct.writeDataStatus[i]);
          if(dataPacketStruct.writeDataStatus[i] == 1) begin
            stop();
            break;
          end
        end
        if(ack == 0)
        stop();
      end else begin
        for(int i=0; i<dataPacketStruct.no_of_i3c_bits_transfer/DATA_WIDTH;i++) begin
          sample_read_data(dataPacketStruct.readData[i],dataPacketStruct.readDataStatus[i]);
        end
        stop();
      end
  end
endtask: drive_data


// GopalS:  task drive_data(inout i3c_transfer_bits_s p_data_packet, 

// GopalS: 
// GopalS:   int idle_time_i; // local variable for idle time
// GopalS:   int tbuf_i;      // Idle time from configure
// GopalS:   bit [7:0] writeData_8b;
// GopalS:   

// GopalS:   if(ack == 1'b1)begin
// GopalS:     stop();
// GopalS:     `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 1 and stop condition is triggered"), UVM_HIGH);
// GopalS:   end else begin
// GopalS:     `uvm_info("SLAVE_ADDR_ACK", $sformatf("Received ACK as 0"), UVM_HIGH);
// GopalS:     if(rw_b == 0) begin
// GopalS:       state = WRITE_DATA;
// GopalS:       for(int i=0; i<data_t.size;i++) begin
// GopalS:         writeData_8b = data_t.writeData[i];
// GopalS:         drive_byte(writeData_8b);
// GopalS:         `uvm_info("DEBUG", $sformatf("Driving Write data %0h",writeData_8b), UVM_NONE)
// GopalS:       end
// GopalS:       sample_ack(ack);
// GopalS:     end else begin
// GopalS:       state = READ_DATA;
// GopalS:       `uvm_info("READ_DATA", $sformatf("Moving to READ_DATA state"), UVM_HIGH);
// GopalS:       sample_read_data(cfg_pkt, ack);
// GopalS:     end
// GopalS:       if(ack == 1'b0) begin
// GopalS:         state = STOP;
// GopalS:         stop();
// GopalS:         `uvm_info(name, $sformatf("Received ACK, moving to STOP state"), UVM_MEDIUM);
// GopalS:       end else begin
// GopalS:         stop();
// GopalS:         `uvm_info(name, $sformatf("Received NACK, moving to STOP state"), UVM_MEDIUM);
// GopalS:       end
// GopalS: 
// GopalS:   end

// GopalS:  endtask: drive_data


  // task for driving the sda_oen as high and sda as low
   task drive_start();
     @(posedge pclk);
     drive_scl(1);
     drive_sda(1);
     state = START;

     // MSHA: scl_oen <= TRISTATE_BUF_OFF;
     // MSHA: scl_o   <= 1;
     // MSHA: sda_oen <= TRISTATE_BUF_OFF;
     // MSHA: sda_o   <= 1;

     @(posedge pclk);
     drive_scl(1);
     drive_sda(0);
     // MSHA: sda_oen <= TRISTATE_BUF_ON;
     // MSHA: sda_o   <= 0;

    // @(posedge pclk);
    // drive_scl(0);
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
      scl_oen <= TRISTATE_BUF_ON;
      scl_o   <= 0;
   // GopalS:     scl_tristate_buf_on();
       state <= WR_BIT;
       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= wrBit;
       scl_tristate_buf_off();
      
   endtask :drive_operation


  // task for sampling the Acknowledge
   task sample_ack(output bit p_ack);
    // GopalS:  scl_tristate_buf_on();
      @(posedge pclk);
      scl_oen <= TRISTATE_BUF_ON;
      scl_o   <= 0;

     sda_oen <= TRISTATE_BUF_OFF;
     sda_o   <= 1;
     
     state <= ACK_NACK;
   // GopalS:   @(posedge pclk);
   // GopalS:   scl_oen <= TRISTATE_BUF_ON;
   // GopalS:   scl_o   <= 0;
      @(posedge pclk);
      scl_oen <= TRISTATE_BUF_OFF;
      scl_o   <= 1;

     p_ack <= sda_i;
    // GopalS:  scl_tristate_buf_off();

  // GopalS:    @(posedge pclk);
  // GopalS:    sda_oen <= TRISTATE_BUF_OFF;
  // GopalS:    sda_o   <= 1;

   // GopalS:   @(posedge pclk);
   // GopalS:   scl_oen <= TRISTATE_BUF_OFF;
   // GopalS:   scl_o   <= 1;

     `uvm_info(name, $sformatf("Sampled ACK value %0b",p_ack), UVM_MEDIUM);
   endtask :sample_ack

 
  task stop();
   // Complete the SCL clock
      @(posedge pclk);
      scl_oen <= TRISTATE_BUF_ON;
      scl_o   <= 0;
   state <= STOP;
   @(posedge pclk);
   // MSHA: scl_oen <= TRISTATE_BUF_OFF;
   // MSHA: scl_o   <= 1;
   drive_scl(1);
   drive_sda(0);
   // MSHA: sda_oen <= TRISTATE_BUF_ON;
   // MSHA: sda_o   <= 0;

   @(posedge pclk);
   drive_scl(1);
   drive_sda(1);
   // MSHA: sda_oen <= TRISTATE_BUF_OFF;
   // MSHA: sda_o   <= 1;

    @(posedge pclk);
   // GopalS:  drive_sda(1);

     
   // Checking for IDLE state
// GopalS:    @(posedge pclk);
// GopalS:    if(scl_i && sda_i) begin
// GopalS:      state = IDLE;
// GopalS:    end
  endtask


   task drive_writeDataByte(input bit[7:0] wdata);

     `uvm_info("DEBUG", $sformatf("Driving writeData = %0b",wdata), UVM_NONE)
     for(int k=0;k < DATA_WIDTH; k++) begin
       scl_tristate_buf_on();
       state <= WRITE_DATA;
       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= wdata[k];
       scl_tristate_buf_off();
     end
      
   endtask :drive_writeDataByte


   task sample_read_data(output bit [7:0]rdata, input bit ack);

     for(int k=0;k < DATA_WIDTH; k++) begin
       scl_tristate_buf_on();
       state <= READ_DATA;
       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= 1;
       rdata[k] <= sda_i;
       scl_tristate_buf_off();
     end

       @(posedge pclk);
       scl_oen <= TRISTATE_BUF_ON;
       scl_o   <= 0;

       sda_oen <= TRISTATE_BUF_ON;
       sda_o   <= ack;
       state <= ACK_NACK;
       
       @(posedge pclk);
       scl_oen <= TRISTATE_BUF_OFF;
       scl_o   <= 1;

     `uvm_info("DEBUG", $sformatf("Moving readData = %0b",rdata), UVM_NONE)
   endtask: sample_read_data


// GopalS:   task sample_read_data(input i3c_transfer_cfg_s cfg_pkt, output bit ack);
// GopalS:     bit [7:0] rdata;
// GopalS: 
// GopalS:     for(int k=0;k < DATA_WIDTH; k++) begin
// GopalS:       detect_posedge_scl();
// GopalS:       rdata[k] <= sda_i;
// GopalS:       sda_oen <= TRISTATE_BUF_OFF;
// GopalS:       sda_o   <= 1;
// GopalS:     end
// GopalS: 
// GopalS:     `uvm_info(name, $sformatf("DEBUG :: Value of sampled read data = %0x", rdata[7:0]), UVM_NONE); 
// GopalS:    
// GopalS:     ack = 1'b0;
// GopalS: 
// GopalS:     // Driving the ACK for slave address
// GopalS:     detect_negedge_scl();
// GopalS:     drive_sda(ack); 
// GopalS:     state = ACK_NACK;
// GopalS:     detect_posedge_scl();
// GopalS: 
// GopalS:   endtask: sample_read_data


  //--------------------------------------------------------------------------------------------
  // Task: drive_sda 
  // Drive the logic sda value as '0' or '1' over the I3C inteerface using the tristate buffers
  //--------------------------------------------------------------------------------------------
  task drive_sda(input bit value);
    sda_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    sda_o   <= value;
  endtask: drive_sda

  task drive_scl(input bit value);
    scl_oen <= value ? TRISTATE_BUF_OFF : TRISTATE_BUF_ON;
    scl_o   <= value;
  endtask: drive_scl

  
  //-------------------------------------------------------
  // Task: detect_posedge_scl
  // Detects the edge on scl with regards to pclk
  //-------------------------------------------------------
  task detect_posedge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;

    // default value of scl_local is logic 1
    scl_local = 2'b11;

    // Detect the edge on scl
    do begin
      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};
    end while(!(scl_local == POSEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("controller_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  
  endtask: detect_posedge_scl
  
  
  //-------------------------------------------------------
  // Task: detect_negedge_scl
  // Detects the negative edge on scl with regards to pclk
  //-------------------------------------------------------
  task detect_negedge_scl();
    // 2bit shift register to check the edge on scl
    bit [1:0] scl_local;
    edge_detect_e scl_edge_value;

    // default value of scl_local is logic 1
    scl_local = 2'b11;

    // Detect the edge on scl
    do begin

      @(negedge pclk);
      scl_local = {scl_local[0], scl_i};

    end while(!(scl_local == NEGEDGE));

    scl_edge_value = edge_detect_e'(scl_local);
    `uvm_info("controller_DRIVER_BFM", $sformatf("scl %s detected", scl_edge_value.name()), UVM_HIGH);
  
  endtask: detect_negedge_scl
  
endinterface : i3c_controller_driver_bfm
`endif
