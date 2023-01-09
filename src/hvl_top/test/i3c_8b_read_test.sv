`ifndef I3C_8B_READ_TEST_INCLUDED_
`define I3C_8B_READ_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_8b_read_test
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_8b_read_test extends i3c_base_test;
  `uvm_component_utils(i3c_8b_read_test)

  i3c_virtual_8b_read_seq i3c_virtual_8b_read_seq_h;


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_8b_read_test", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : i3c_8b_read_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_8b_read_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_8b_read_test::new(string name = "i3c_8b_read_test",
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
function void i3c_8b_read_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
//function void i3c_8b_read_test::connect_phase(uvm_phase phase);
//  super.connect_phase(phase);
//endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task i3c_8b_read_test::run_phase(uvm_phase phase);


  i3c_virtual_8b_read_seq_h = i3c_virtual_8b_read_seq::type_id::create("i3c_virtual_8b_read_seq_h");


  phase.raise_objection(this);

  i3c_virtual_8b_read_seq_h.start(i3c_env_h.i3c_virtual_seqr_h); 
  #20;

  phase.drop_objection(this);

endtask : run_phase

`endif

