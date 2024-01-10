`ifndef I3C_TARGET_WRITEOPERATIONWITHMAXIMUMBITSDATA_SEQ_INCLUDED_
`define I3C_TARGET_WRITEOPERATIONWITHMAXIMUMBITSDATA_SEQ_INCLUDED_

class i3c_target_writeOperationWithMaximumbitsData_seq extends i3c_target_base_seq;
  `uvm_object_utils(i3c_target_writeOperationWithMaximumbitsData_seq)

  extern function new(string name = "i3c_target_writeOperationWithMaximumbitsData_seq");
  extern task body();
endclass : i3c_target_writeOperationWithMaximumbitsData_seq

function i3c_target_writeOperationWithMaximumbitsData_seq::new(string name = "i3c_target_writeOperationWithMaximumbitsData_seq");
  super.new(name);
endfunction : new

task i3c_target_writeOperationWithMaximumbitsData_seq::body();

//  super.body();

// GopalS:   req.i3c_target_agent_cfg_h = p_sequencer.i3c_target_agent_cfg_h;

// GopalS:   `uvm_info("DEBUG", $sformatf("address = %0x",
// GopalS:   p_sequencer.i3c_target_agent_cfg_h.slave_address_array[0]), UVM_NONE)

  req = i3c_target_tx::type_id::create("req"); 

  start_item(req);

    if(!req.randomize())begin
      `uvm_error(get_type_name(), "Randomization failed")
    end
  
    req.print();
  finish_item(req);

endtask:body
  
`endif


