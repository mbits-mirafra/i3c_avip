`ifndef APB_MASTER_DRIVER_BFM_INCLUDED_
`define APB_MASTER_DRIVER_BFM_INCLUDED_

//-------------------------------------------------------
// Importing apb global package
//-------------------------------------------------------
import apb_global_pkg::*;

//--------------------------------------------------------------------------------------------
// Interface : apb_master_driver_bfm
//  Used as the HDL driver for apb
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
interface apb_master_driver_bfm (input  bit   pclk,
                                 input  bit   preset_n,
                                 input  bit   pready,
                                 input  bit   pslverr,
                                 input  logic [DATA_WIDTH-1:0]prdata,
                                 output logic [2:0]pprot,
                                 output logic penable,
                                 output logic pwrite,
                                 output logic [ADDRESS_WIDTH-1:0]paddr,
                                 output logic [NO_OF_SLAVES-1:0]pselx,
                                 output logic [DATA_WIDTH-1:0]pwdata,
                                 output logic [(DATA_WIDTH/8)-1:0]pstrb
                                );

  //-------------------------------------------------------
  // Importing uvm package file
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Importing the master package file
  //-------------------------------------------------------
  import apb_master_pkg::*;
  
  //Variable: name
  //Used to store the name of the interface
  string name = "APB_MASTER_DRIVER_BFM"; 
  
  //Variable: apb_master_drv_proxy_h
  //Creating the handle for the proxy_driver
  apb_master_driver_proxy apb_master_drv_proxy_h;
   
  //Variable: state
  //Creating handle for fsm states
  apb_fsm_state_e state;

  //-------------------------------------------------------
  // Used to display the name of the interface
  //-------------------------------------------------------
  initial begin
    `uvm_info(name, $sformatf(name),UVM_LOW)
  end
 
  //-------------------------------------------------------
  // Task: wait_for_preset_n
  //  Waiting for the system reset to be active low
  //-------------------------------------------------------
  task wait_for_preset_n();
    @(negedge preset_n);
    `uvm_info(name ,$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
 
    @(posedge preset_n);
    `uvm_info(name ,$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask: wait_for_preset_n
  
  //--------------------------------------------------------------------------------------------
  // Task: drive_to_bfm
  //  This task will drive the data from bfm to proxy using converters
  //
  // Parameters:
  // data_packet - handle for apb_transfer_char_s
  // cfg_pkt     - handle for apb_transfer_cfg_s
  //--------------------------------------------------------------------------------------------
  task drive_to_bfm(inout apb_transfer_char_s data_packet, input apb_transfer_cfg_s cfg_packet);
    `uvm_info(name,$sformatf("data_packet=\n%p",data_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("DRIVE TO BFM TASK"),UVM_HIGH);

    //Driving Setup state
    drive_setup_state(data_packet);

    //Driving Access state
    waiting_in_access_state(data_packet);

  endtask: drive_to_bfm

  //--------------------------------------------------------------------------------------------
  // Task: drive_idle_state
  //  This task drives the apb interface to idle state
  //--------------------------------------------------------------------------------------------
  task drive_idle_state();
    @(posedge pclk);
    pselx   <= '0;
    penable <= 1'b0;
    state = IDLE;
    `uvm_info(name,$sformatf("DROVE THE IDLE STATE"),UVM_HIGH)

    `uvm_info("DEBUG_MSHA", $sformatf("drive_apb_idle state = %0s and state = %0d",
                                    state.name(), state), UVM_NONE);
    
  endtask : drive_idle_state

  //--------------------------------------------------------------------------------------------
  // Task: drive_setup_state
  //  It drives the required signals to the slave 
  //
  // Parameters:
  //  data_packet - apb_transfer_char_s
  //--------------------------------------------------------------------------------------------
  task drive_setup_state(inout apb_transfer_char_s data_packet);
    @(posedge pclk);
    `uvm_info(name,$sformatf("DRIVING THE SETUP STATE"),UVM_HIGH)
    
    pselx   <= data_packet.pselx;
    penable <= 1'b0;
    paddr   <= data_packet.paddr;
    pwrite  <= data_packet.pwrite;
    
    if(data_packet.pwrite == WRITE) begin
      pwdata <= data_packet.pwdata;
      pstrb  <= data_packet.pstrb;
    end
    
    else begin
      pstrb <= '0;
    end
    
    pprot <= data_packet.pprot;
    state=SETUP;
    `uvm_info("DEBUG_MSHA", $sformatf("drive_apb_setup state = %0s and state = %0d", state.name(), state), UVM_NONE);
    
  endtask : drive_setup_state
 
  //-------------------------------------------------------
  // Task: drive_access_state
  //  This task defines the accessing of data signals from 
  //  master to slave or viceverse
  //
  // Parameters:
  //  data_packet - handle for apb_transfer_char_s
  //-------------------------------------------------------
  task waiting_in_access_state(inout apb_transfer_char_s data_packet);
    @(posedge pclk);
    `uvm_info(name,$sformatf("INSIDE ACCESS STATE"),UVM_HIGH);

    state = ACCESS;  
    penable <= 1'b1;
    
    `uvm_info("DEBUG_NADEEM",$sformatf("pready=%0d",pready), UVM_HIGH);
      detect_wait_state(data_packet);
    // MSHA: if(pready == 0) begin
    // MSHA:   detect_wait_state(data_packet);
    // MSHA: end
    // MSHA: `uvm_info("DEBUG_MSHA",$sformatf("wait_apb_access_state=%0d and state=%0d",state.name(),state), UVM_NONE);
  
  endtask : waiting_in_access_state

  //--------------------------------------------------------------------------------------------
  // Task: detect_wait_state
  // In this task, signals are waiting for pready to set to high to transfer the data_packet
  //
  // Parameters:
  // data_packet - handle for apb_transfer_char_s
  //--------------------------------------------------------------------------------------------
  task detect_wait_state(inout apb_transfer_char_s data_packet);
    @(posedge pclk);
    `uvm_info(name,$sformatf("DETECT_WAIT_STATE"),UVM_HIGH);

    while(pready==0) begin
      `uvm_info(name,"WAIT_STATE_DETECTED",UVM_HIGH);
      @(posedge pclk);
      state = WAIT_STATE;
      data_packet.no_of_wait_states++;
    end
    `uvm_info(name,$sformatf("DATA READY TO TRANSFER"),UVM_HIGH);

    if(data_packet.pwrite == READ) begin
      data_packet.prdata = prdata;
    end

    data_packet.pslverr = pslverr;

    // TODO(mshariff): Add logic for making it work for ACCESS to SETUP phase
    state = IDLE;
    penable <= 1'b0;
    pselx <= 'b0;
    //`uvm_info("DEBUG_MSHA", $sformatf("drive_apb_access state = %0s and state = %0d",
    //state.name(), state), UVM_NONE);
  endtask : detect_wait_state

endinterface : apb_master_driver_bfm

`endif

