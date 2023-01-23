class sync_reset_ctrl #(bit RESET_POLARITY = 1,
                        int INITIAL_IDLE_CYCLES = 0,
                        int RESET_ACTIVE_CYCLES = 10) extends reset_ctrl_base;

  typedef sync_reset_ctrl #(RESET_POLARITY, INITIAL_IDLE_CYCLES, RESET_ACTIVE_CYCLES) this_t;
  typedef virtual sync_reset_bfm #(RESET_POLARITY, INITIAL_IDLE_CYCLES, RESET_ACTIVE_CYCLES) bfm_t;

  `uvm_object_param_utils(this_t);
  
  protected bfm_t m_bfm;

  function new(string name = "sync_reset_ctrl");
    super.new(name);
    report_id = name;
  endfunction : new

  function void set_bfm(bfm_t rbfm);
    m_bfm = rbfm;
    m_bfm.proxy = this;
  endfunction : set_bfm;

  virtual function void toggle_reset (int    idle_cycles = -1,
                                      int    num_clks_active = -1,
                                      string file = "",
                                      int unsigned line = 0);
    if (collectStats) count_stat({get_full_name(),".toggle_reset()"},file,line);
    m_bfm.toggle_reset(idle_cycles, num_clks_active);
  endfunction : toggle_reset

  function void assert_reset(string file = "", int unsigned line = 0);
    if (collectStats) count_stat({get_full_name(),".assert_reset()"},file,line);
    m_bfm.assert_reset();
  endfunction : assert_reset

  function void deassert_reset(string file = "", int unsigned line = 0);
    if (collectStats) count_stat({get_full_name(),".deassert_reset()"},file,line);
    m_bfm.deassert_reset();
  endfunction : deassert_reset

  virtual function void configure(int idle_cycles = -1, int num_clks_active = -1);
    m_bfm.configure(idle_cycles, num_clks_active);
  endfunction : configure

  function void set_manual_control(bit mc);
    m_bfm.set_manual_control(mc);
  endfunction : set_manual_control
  
endclass : sync_reset_ctrl
