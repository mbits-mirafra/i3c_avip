`ifndef __NAND_FIXED_SEQUENCE
`define __NAND_FIXED_SEQUENCE

`include "uvm_macros.svh"

class nand_fixed_sequence extends nand_ben_bench_sequence_base;

  `uvm_object_utils(nand_fixed_sequence)

  function new(string name = "nand_fixed_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
  nand_in_agent_fixed_seq = nand_in_fixed_sequence::type_id::create("nand_in_agent_fixed_seq");

  nand_in_agent_config.wait_for_reset();
  nand_in_agent_config.wait_for_num_clocks(10);

  nand_in_agent_fixed_seq.start(nand_in_agent_sequencer);

  // add_in_agent_config.wait_for_num_clocks(50);

endtask

endclass :nand_fixed_sequence

   `endif
