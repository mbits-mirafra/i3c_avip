class sync_reset_ctrl #(bit RESET_POLARITY = 1,
                        int INITIAL_IDLE_CYCLES = 0,
                        int RESET_ACTIVE_CYCLES = 10) extends reset_ctrl_base;

  typedef sync_reset_ctrl #(RESET_POLARITY, INITIAL_IDLE_CYCLES, RESET_ACTIVE_CYCLES) this_t;
  typedef virtual sync_reset_bfm #(RESET_POLARITY, INITIAL_IDLE_CYCLES, RESET_ACTIVE_CYCLES) bfm_t;

  `uvm_object_param_utils(this_t);
  
  protected bfm_t bfm;

  function new(string name = "sync_reset_ctrl");
    super.new(name);
    report_id = name;
  endfunction : new

  function void set_bfm(bfm_t rbfm);
    bfm = rbfm;
    bfm.proxy = this;
  endfunction : set_bfm;

  virtual function void toggle_reset (int idle_cycles = -1, int num_clks_active = -1);
    bfm.toggle_reset(idle_cycles, num_clks_active);
  endfunction : toggle_reset

  virtual function void configure(int idle_cycles = -1, int num_clks_active = -1);
    bfm.configure(idle_cycles, num_clks_active);
  endfunction : configure
  
endclass : sync_reset_ctrl
