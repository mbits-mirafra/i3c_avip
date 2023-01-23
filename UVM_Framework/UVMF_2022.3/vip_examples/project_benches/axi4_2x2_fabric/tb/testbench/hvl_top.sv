//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
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
import axi4_2x2_fabric_tests_pkg::*;

module hvl_top;

  // pragma uvmf custom module_item_additional begin
  // pragma uvmf custom module_item_additional end

  initial begin
    $timeformat(-9,3,"ns",5);
    run_test();
  end

endmodule

