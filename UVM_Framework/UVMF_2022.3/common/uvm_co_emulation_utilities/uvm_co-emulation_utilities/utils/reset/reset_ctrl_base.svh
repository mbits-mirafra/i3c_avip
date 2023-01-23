//This base object exists so that parameters don't have to passed around a
// testbench.  Handles of this base type can be used in most places without
// having to know the value for the phase_offset_in_fs parameter needed by the
// bfm.

class reset_ctrl_base extends uvm_object;

  `uvm_object_utils(reset_ctrl_base)
  
  string report_id = "reset_ctrl_base";

  event reset_asserted, reset_deasserted;
  bit   reset_active = 0;
  
  //Associative array to hold counters for reset toggle hits based on
  //string index
  protected static int stats_hash[string] = '{default:0};
  protected static bit collectStats;

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

  virtual function void toggle_reset (int    idle_cycles = -1,
                                      int    num_clks_active = -1,
                                      string file = "",
                                      int unsigned line = 0);
    `uvm_error({report_id, "::toggle_reset()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : toggle_reset

  function void assert_reset(string file = "", int unsigned line = 0);
    `uvm_error({report_id, "::assert_reset()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : assert_reset

  function void deassert_reset(string file = "", int unsigned line = 0);
    `uvm_error({report_id, "::deassert_reset()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : deassert_reset

  virtual function void configure(int idle_cycles = -1, int num_clks_active = -1);
    `uvm_error({report_id, "::configure()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : configure

  function void set_manual_control(bit mc);
    `uvm_error({report_id, "::set_manual_control()"}, "Need a reset_ctrl object, not a reset_ctrl_base object")
  endfunction : set_manual_control


  /////////////////////////////////////////////////////////////////////////////
  //Statistics Collection Code
  /////////////////////////////////////////////////////////////////////////////
  
  static function void set_stat_collection( input bit val );
    collectStats = val;
  endfunction : set_stat_collection
  
  static function void count_stat( input string scope = "",
                                   input string file = "",
                                   input int unsigned line = 0);
    if (file != "") begin
      string str = $sformatf("%s called from %s:%4d", scope, file, line);
      stats_hash[str]++;
    end
  endfunction : count_stat
  
  static function void print_stats();
    if (stats_hash.size == 0)
      return;

    $display("Displaying statistics for Reset Utility calls");
    $display("================================================");
    foreach (stats_hash[i]) begin
      $display("Called %d times from: %s", stats_hash[i], i);
    end
  endfunction : print_stats
  
endclass : reset_ctrl_base
    
