package clock_test_pkg;
  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  import clock_pkg::*;
  import reset_pkg::*;

`include "uvm_macros.svh"

`include "base_test.svh"
`include "clock_test.svh"
`include "reset_test.svh"
`include "manual_reset_test.svh"
  
endpackage : clock_test_pkg
