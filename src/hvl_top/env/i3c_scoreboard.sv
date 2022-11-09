`ifndef I3C_SCOREBOARD_INCLUDED_
`define I3C_SCOREBOARD_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_scoreboard
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_scoreboard extends uvm_component;
  `uvm_component_utils(i3c_scoreboard)

  i3c_master_tx i3c_master_tx_h;

  i3c_slave_tx i3c_slave_tx_h;
  
  i3c_env_config i3c_env_cfg_h;



  uvm_tlm_analysis_fifo#(i3c_master_tx)master_analysis_fifo;

  uvm_tlm_analysis_fifo#(i3c_slave_tx)slave_analysis_fifo;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_scoreboard", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  //extern virtual task run_phase(uvm_phase phase);

endclass : i3c_scoreboard

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_scoreboard
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_scoreboard::new(string name = "i3c_scoreboard",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  master_analysis_fifo=new("master_analysis_fifo",this);
  slave_analysis_fifo=new("slave_analysis_fifo",this);

endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void i3c_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase


`endif

