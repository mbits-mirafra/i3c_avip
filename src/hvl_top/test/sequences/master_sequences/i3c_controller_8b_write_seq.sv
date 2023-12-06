`ifndef I3C_CONTROLLER_8B_WRITE_SEQ_INCLUDED_
`define I3C_CONTROLLER_8B_WRITE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_8b_controller_sequence
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_controller_8b_write_seq extends i3c_controller_base_seq;
  `uvm_object_utils(i3c_controller_8b_write_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_8b_write_seq");
  extern task body();
endclass : i3c_controller_8b_write_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_controller_8b_write_seq
//--------------------------------------------------------------------------------------------
function i3c_controller_8b_write_seq::new(string name = "i3c_controller_8b_write_seq");
  super.new(name);
endfunction : new

//-------------------------------------------------------
//task : body
//based on the request from the driver task will drive the transaction
//-------------------------------------------------------

task i3c_controller_8b_write_seq::body();
  int m_i_i; // local variable for iteration

  super.body();

  req = i3c_controller_tx::type_id::create("req"); 
// GopalS:   req.i3c_controller_agent_cfg_h = p_sequencer.i3c_controller_agent_cfg_h;

// GopalS:   `uvm_info("DEBUG", $sformatf("address = %0x",
// GopalS:   p_sequencer.i3c_controller_agent_cfg_h.slave_address_array[0]), UVM_NONE)

  start_item(req);

  //if(!req.randomize() with {read_write == WRITE;}) begin

  //  `uvm_fatal(get_type_name(), "Randomization failed")

  //end
  /*req.targetAddress = 7'b110_1000;
  req.operation = WRITE;
  req.size = 1;
  req.writeData = new[req.size];
  for(m_i_i = 0;m_i_i < req.size;m_i_i++) begin
    req.wr_data[m_i_i] = $random;
  end*/
  req.print();
  finish_item(req);


endtask:body
  

`endif


