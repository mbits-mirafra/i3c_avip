package clock_pkg;
  
  timeunit 1ps;
  timeprecision 1ps;
  
  `include "uvm_macros.svh"

  import uvm_pkg::*;

  `include "src/XlSvQueue.svh"
  `include "src/XlSvTimeSync.svh"
  `include "src/clock_ctrl_base.svh"
  `include "src/clock_ctrl.svh"

  
endpackage : clock_pkg