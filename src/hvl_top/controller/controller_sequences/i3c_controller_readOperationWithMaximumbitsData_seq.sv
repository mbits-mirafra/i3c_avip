`ifndef I3C_CONTROLLER_READOPERATIONWITHMAXIMUMBITSDATA_SEQ_INCLUDED_
`define I3C_CONTROLLER_READOPERATIONWITHMAXIMUMBITSDATA_SEQ_INCLUDED_

class i3c_controller_readOperationWithMaximumbitsData_seq extends i3c_controller_base_seq;
  `uvm_object_utils(i3c_controller_readOperationWithMaximumbitsData_seq)

  extern function new(string name = "i3c_controller_readOperationWithMaximumbitsData_seq");
  extern task body();
endclass : i3c_controller_readOperationWithMaximumbitsData_seq

function i3c_controller_readOperationWithMaximumbitsData_seq::new(string name = "i3c_controller_readOperationWithMaximumbitsData_seq");
  super.new(name);
endfunction : new


task i3c_controller_readOperationWithMaximumbitsData_seq::body();
  super.body();

  req = i3c_controller_tx::type_id::create("req"); 

  start_item(req);
    if(!req.randomize() with {operation == READ;
                              readDataStatus.size()== MAXIMUM_BYTES; 
                              targetAddress inside {p_sequencer.i3c_controller_agent_cfg_h.targetAddress};
                              }) begin
      `uvm_error(get_type_name(), "Randomization failed")
    end
  
    req.print();
  finish_item(req);

endtask:body
  
`endif


