package clock_pkg;
  
  timeunit 1ps;
  timeprecision 1ps;
  
  `include "uvm_macros.svh"

  import uvm_pkg::*;

  `include "XlSvQueue.svh"
  `include "XlSvTimeSync.svh"
  `include "clock_ctrl_base.svh"
  `include "clock_ctrl.svh"

  
endpackage : clock_pkg