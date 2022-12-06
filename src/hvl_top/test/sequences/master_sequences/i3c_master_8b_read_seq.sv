`ifndef I3C_8B_MASTER_READ_SEQ_INCLUDED_
`define I3C_8B_MASTER_READ_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_8b_master_read_sequence
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_master_8b_read_seq extends i3c_master_base_seq;
  `uvm_object_utils(i3c_master_8b_read_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_master_8b_read_seq");
  extern task body();
endclass : i3c_master_8b_read_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_master_8b_read_seq
//--------------------------------------------------------------------------------------------
function i3c_master_8b_read_seq::new(string name = "i3c_master_8b_read_seq");
  super.new(name);
endfunction : new

//-------------------------------------------------------
//task : body
//based on the request from the driver task will drive the transaction
//-------------------------------------------------------

task i3c_master_8b_read_seq::body();
  int m_i_i; // local variable for iteration

  super.body();

  req = i3c_master_tx::type_id::create("req"); 
  req.i3c_master_agent_cfg_h = p_sequencer.i3c_master_agent_cfg_h;

  `uvm_info("DEBUG", $sformatf("address = %0x",
  p_sequencer.i3c_master_agent_cfg_h.slave_address_array[0]), UVM_NONE)

  start_item(req);

  //if(!req.randomize() with {read_write == READ;}) begin

  //  `uvm_fatal(get_type_name(), "Randomization failed")

  //end
  req.slave_address = 7'b110_1000;
  req.read_write = READ;
  req.size = 1;
  req.print();
  finish_item(req);


endtask:body
  

`endif


