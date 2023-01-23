//This base object exists so that parameters don't have to passed around a
// testbench.  Handles of this base type can be used in most places without
// having to know the value for the phase_offset_in_fs parameter needed by the
// bfm.

class reset_ctrl_base extends uvm_object;

  `uvm_object_utils(reset_ctrl_base)
  
  string report_id = "reset_ctrl_base";

  event reset_asserted, reset_deasserted;
  bit   reset_active = 0;

  function new(string name = "reset_ctrl");
    super.new(name);
  endfunction : new

  virtual function void notify_reset_edge(bit asserted);
    reset_active = asserted;
    if (asserted) -> reset_asserted;
    else -> reset_deasserted;
  endfunction : notify_reset_edge;

  virtual task wait_reset_assertion();
    @reset_asserted;
  endtask : wait_reset_assertion

  virtual task wait_reset_asserted();
    if (!reset_active) @reset_asserted;
  endtask : wait_reset_asserted

  virtual task wait_reset_deassertion();
    @reset_deasserted;
  endtask : wait_reset_deassertion

  virtual task wait_reset_deasserted();
    if (reset_active) @reset_deasserted;
  endtask : wait_reset_deasserted

  virtual function void toggle_reset (int idle_cycles = -1, int num_clks_active = -1);
    `uvm_error({report_id, "::toggle_reset()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : toggle_reset

  virtual function void configure(int idle_cycles = -1, int num_clks_active = -1);
    `uvm_error({report_id, "::configure()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : configure

endclass : reset_ctrl_base
    
