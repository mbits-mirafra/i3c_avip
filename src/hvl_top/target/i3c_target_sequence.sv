`ifndef I3C_TARGET_SEQUENCE_INCLUDED_
`define I3C_TARGET_SEQUENCE_INCLUDED_

class i3c_target_sequence extends uvm_object;
  `uvm_object_utils(i3c_target_sequence)

   extern function new(string name = "i3c_target_sequence");
endclass : i3c_target_sequence

function i3c_target_sequence::new(string name = "i3c_target_sequence");
  super.new(name);
endfunction : new

`endif
