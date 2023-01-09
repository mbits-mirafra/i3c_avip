`ifndef I3C_MASTER_8B_WRITE_SEQ_INCLUDED_
`define I3C_MASTER_8B_WRITE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_8b_master_sequence
// <Description_here>
//--------------------------------------------------------------------------------------------
class i3c_master_8b_write_seq extends i3c_master_base_seq;
  `uvm_object_utils(i3c_master_8b_write_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_master_8b_write_seq");
  extern task body();
endclass : i3c_master_8b_write_seq

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_master_8b_write_seq
//--------------------------------------------------------------------------------------------
function i3c_master_8b_write_seq::new(string name = "i3c_master_8b_write_seq");
  super.new(name);
endfunction : new

//-------------------------------------------------------
//task : body
//based on the request from the driver task will drive the transaction
//-------------------------------------------------------

task i3c_master_8b_write_seq::body();
  int m_i_i; // local variable for iteration

  super.body();

  req = i3c_master_tx::type_id::create("req"); 
  req.i3c_master_agent_cfg_h = p_sequencer.i3c_master_agent_cfg_h;

  `uvm_info("DEBUG", $sformatf("address = %0x",
  p_sequencer.i3c_master_agent_cfg_h.slave_address_array[0]), UVM_NONE)

  start_item(req);

  //if(!req.randomize() with {read_write == WRITE;}) begin

  //  `uvm_fatal(get_type_name(), "Randomization failed")

  //end
  req.slave_address = 7'b110_1000;
  req.read_write = WRITE;
  req.size = 1;
  req.wr_data = new[req.size];
  for(m_i_i = 0;m_i_i < req.size;m_i_i++) begin
    req.wr_data[m_i_i] = $random;
  end
  req.print();
  finish_item(req);


endtask:body
  

`endif


