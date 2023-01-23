//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
// Unit            : Top level HVL module
// File            : hvl_top.sv
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This module loads the test package and starts the UVM phases.
//
//----------------------------------------------------------------------
//

import uvm_pkg::*;
import axi4_2x2_fabric_test_pkg::*;

module hvl_top;

initial run_test();

endmodule

