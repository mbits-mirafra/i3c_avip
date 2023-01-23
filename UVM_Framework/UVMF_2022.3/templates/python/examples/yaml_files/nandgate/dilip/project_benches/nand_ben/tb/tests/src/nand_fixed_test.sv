`ifndef __NAND_FIXED_TEST
`define __NAND_FIXED_TEST

`include "uvm_macros.svh"

class nand_fixed_test extends test_top;

  `uvm_component_utils(nand_fixed_test)

  function new(string name = "nand_fixed_test", uvm_component parent = null );
    super.new(name, parent);
  endfunction : new


  virtual function void build_phase(uvm_phase phase );
  nand_ben_bench_sequence_base::type_id::set_type_override(nand_fixed_sequence ::get_type());
  super.build_phase(phase);
endfunction : build_phase 

endclass : nand_fixed_test

`endif
