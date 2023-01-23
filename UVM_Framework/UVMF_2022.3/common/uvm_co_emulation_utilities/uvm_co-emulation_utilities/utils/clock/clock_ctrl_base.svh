//This base object exists so that parameters don't have to passed around a
// testbench.  Handles of this base type can be used in most places without
// having to know the value for the PHASE_OFFSET_IN_PS parameter needed by the
// bfm.

class clock_ctrl_base extends uvm_object;

  `uvm_object_utils(clock_ctrl_base)
  
  string report_id = "clock_ctrl_base";
  
  //Associative array to hold counters for clock advance hits based on
  //string index
  protected static int stats_hash[string] = '{default:0};
  protected static bit collectStats;

  function new(string name = "clock_ctrl");
    super.new(name);
  endfunction : new

  /////////////////////////////////////////////////////////////////////////////
  //Clock Interaction Code
  /////////////////////////////////////////////////////////////////////////////
  
  virtual task wait_clocks(int unsigned numClocksArg = 1,
                           string file = "",
                           int unsigned line = 0);
    `uvm_error({report_id, "::wait_clocks()"}, "Need a clock_ctrl object, not a clock_ctrl_base object")
  endtask : wait_clocks


  /////////////////////////////////////////////////////////////////////////////
  //Clock Adjustment Code
  /////////////////////////////////////////////////////////////////////////////
  
  virtual function void update_half_period_in_ps (int unsigned half_period);
    `uvm_error({report_id, "::update_half_period_in_ps()"}, "Need a clock_ctrl object, not a clock_ctrl_base object")
  endfunction : update_half_period_in_ps

  virtual function void update_clock_enable (bit enable);
    `uvm_error({report_id, "::update_clock_enable()"}, "Need a clock_ctrl object, not a clock_ctrl_base object")
  endfunction : update_clock_enable


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
    
    $display("Displaying statistics for Clock Utility calls");
    $display("================================================");
    foreach (stats_hash[i]) begin
      $display("Called %d times from: %s", stats_hash[i], i);
    end
  endfunction : print_stats

endclass : clock_ctrl_base
    