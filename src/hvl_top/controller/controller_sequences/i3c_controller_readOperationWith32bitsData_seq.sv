`ifndef I3C_CONTROLLER_READOPERATIONWITH32BITSDATA_SEQ_INCLUDED_ 
`define I3C_CONTROLLER_READOPERATIONWITH32BITSDATA_SEQ_INCLUDED_

class i3c_controller_readOperationWith32bitsData_seq extends i3c_controller_base_seq;
  `uvm_object_utils(i3c_controller_readOperationWith32bitsData_seq)

  extern function new(string name = "i3c_controller_readOperationWith32bitsData_seq");
  extern task body();
endclass : i3c_controller_readOperationWith32bitsData_seq

function i3c_controller_readOperationWith32bitsData_seq::new(string name = "i3c_controller_readOperationWith32bitsData_seq");
  super.new(name);
endfunction : new


task i3c_controller_readOperationWith32bitsData_seq::body();
  super.body();

// Mahadeva:  req.i3c_controller_agent_cfg_h = p_sequencer.i3c_controller_agent_cfg_h;

//  `uvm_info("DEBUG", $sformatf("address = %0x",
//  p_sequencer.i3c_controller_agent_cfg_h.slave_address_array[0]), UVM_NONE)

  req = i3c_controller_tx::type_id::create("req"); 

  start_item(req);

  if(!req.randomize() with {operation == READ;
                            readDataStatus.size == 4;
                            targetAddress == 7'b1010101;
                            readDataStatus[0] == 0;
                            readDataStatus[1] == 0;
                            readDataStatus[2] == 0;
                            readDataStatus[3] == 0;}) begin
    `uvm_error(get_type_name(), "Randomization failed")
  end

  req.print();
  finish_item(req);

endtask:body

`endif


