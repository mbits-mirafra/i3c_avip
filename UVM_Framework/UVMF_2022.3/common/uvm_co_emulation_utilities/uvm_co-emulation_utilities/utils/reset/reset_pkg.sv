package reset_pkg;
  
  timeunit 1fs;
  timeprecision 1fs;
  
  `include "uvm_macros.svh"

  import uvm_pkg::*;

  `include "reset_ctrl_base.svh"
  `include "async_reset_ctrl.svh"
  `include "sync_reset_ctrl.svh"

  
endpackage : reset_pkg