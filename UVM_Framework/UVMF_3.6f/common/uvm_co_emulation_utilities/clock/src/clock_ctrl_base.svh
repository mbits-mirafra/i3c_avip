//This base object exists so that parameters don't have to passed around a
// testbench.  Handles of this base type can be used in most places without
// having to know the value for the PHASE_OFFSET_IN_PS parameter needed by the
// bfm.

class clock_ctrl_base extends uvm_object;

  `uvm_object_utils(clock_ctrl_base)
  
  string report_id = "clock_ctrl_base";

  function new(string name = "clock_ctrl");
    super.new(name);
  endfunction : new

  /////////////////////////////////////////////////////////////////////////////
  //Clock Interaction Code
  /////////////////////////////////////////////////////////////////////////////
  
  virtual task wait_clocks(int unsigned numClocksArg = 1);
    `uvm_error({report_id, "::wait_clocks()"}, "Need a clock_ctrl object, not a clock_ctrl_base object")
  endtask : wait_clocks


  /////////////////////////////////////////////////////////////////////////////
  //Clock Adjustment Code
  /////////////////////////////////////////////////////////////////////////////
  
  virtual function void update_half_period_in_ps (shortint unsigned half_period);
    `uvm_error({report_id, "::update_half_period_in_ps()"}, "Need a clock_ctrl object, not a clock_ctrl_base object")
  endfunction : update_half_period_in_ps

  virtual function void update_clock_enable (bit enable);
    `uvm_error({report_id, "::update_clock_enable()"}, "Need a clock_ctrl object, not a clock_ctrl_base object")
  endfunction : update_clock_enable

endclass : clock_ctrl_base
    