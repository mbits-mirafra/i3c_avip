//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This module loads the test package and starts the UVM phases.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

import uvm_pkg::*;
import ahb2wb_tests_pkg::*;

module hvl_top;

  // pragma uvmf custom module_item_additional begin
  // pragma uvmf custom module_item_additional end

  initial begin
    $timeformat(-9,3,"ns",5);
    run_test();
  end

endmodule

