`ifndef I3C_WRITE_MASTER_SEQ_INCLUDED_
`define I3C_WRITE_MASTER_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class i3c_write_master_seq extends i3c_master_base_seq;

  
  //register with factory so can use create uvm_method 
  //and override in future if necessary 
  `uvm_object_utils(i3c_write_master_seq)

  // master_tx req;

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------

  extern function new (string name="i3c_write_master_seq");
  extern virtual task body();

endclass:i3c_write_master_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------

function i3c_write_master_seq::new(string name="i3c_write_master_seq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task i3c_write_master_seq::body();
  req = i3c_master_tx::type_id::create("req");

  start_item(req);

//  if(!req.randomize() with {req.data.size() == 1;
//                            req.reg_address.size() == 1;
//                           }) begin
//    `uvm_fatal(get_type_name(),"Randomization failed")
//  end
 //if(!req.randomize() with {req.reg_address.size() == 1;
  req.print();
  finish_item(req);

endtask:body

`endif
