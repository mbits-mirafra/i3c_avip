//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Simulation Bench 
// Unit            : Top level HVL module
// File            : hvl_top.sv
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This module loads the test package and starts the UVM phases.
//
//----------------------------------------------------------------------
//

import uvm_pkg::*;
import ahb2wb_test_pkg::*;

module hvl_top;

initial run_test();

endmodule

