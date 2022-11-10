`ifndef I3C_8B_SLAVE_SEQ_INCLUDED_
`define I3C_8B_SLAVE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_8b_slave_seq
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_8b_slave_seq extends i3c_slave_base_seq;
  `uvm_object_utils(i3c_8b_slave_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_8b_slave_seq");

  extern virtual task body();
  
endclass : i3c_8b_slave_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_8b_slave_seq
//--------------------------------------------------------------------------------------------
function i3c_8b_slave_seq::new(string name = "i3c_8b_slave_seq");
  super.new(name);
endfunction : new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task i3c_8b_slave_seq::body(); 
  req=i3c_slave_tx::type_id::create("req");
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


