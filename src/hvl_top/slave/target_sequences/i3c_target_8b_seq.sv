`ifndef I3C_TARGET_8B_SEQ_INCLUDED_
`define I3C_TARGET_8B_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_target_8b_seq
//--------------------------------------------------------------------------------------------
class i3c_target_8b_seq extends i3c_target_base_seq;
  `uvm_object_utils(i3c_target_8b_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_target_8b_seq");

  extern virtual task body();
  
endclass : i3c_target_8b_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_target_8b_seq
//--------------------------------------------------------------------------------------------
function i3c_target_8b_seq::new(string name = "i3c_target_8b_seq");
  super.new(name);
endfunction : new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task i3c_target_8b_seq::body(); 
  req=i3c_target_tx::type_id::create("req");
  repeat(5) begin
    start_item(req);
    if(!req.randomize()) begin 
      `uvm_fatal(get_type_name(),"Randomization FAILED")
    end
      req.print();
      finish_item(req);
    end

endtask : body

`endif


