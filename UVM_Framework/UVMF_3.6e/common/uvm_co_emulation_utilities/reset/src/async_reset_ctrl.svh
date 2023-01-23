class async_reset_ctrl #(bit RESET_POLARITY = 1,
                         int INITIAL_IDLE_TIME_IN_PS = 0,
                         int RESET_ACTIVE_TIME_IN_PS = 0) extends reset_ctrl_base;

  typedef async_reset_ctrl #(RESET_POLARITY, INITIAL_IDLE_TIME_IN_PS, RESET_ACTIVE_TIME_IN_PS) this_t;
  typedef virtual async_reset_bfm #(RESET_POLARITY, INITIAL_IDLE_TIME_IN_PS, RESET_ACTIVE_TIME_IN_PS) bfm_t;

  `uvm_object_param_utils(this_t);

  //string report_id = "async_reset_ctrl";
  
  protected bfm_t bfm;

  function new(string name = "async_reset_ctrl");
    super.new(name);
    report_id = name;
  endfunction : new

  function void set_bfm(bfm_t rbfm);
    bfm = rbfm;
    bfm.proxy = this;
    //bfm.set_proxy_guard(1);
  endfunction : set_bfm;

  virtual function void toggle_reset (int idle_cycles = -1, int num_clks_active = -1);
    bfm.toggle_reset(idle_cycles, num_clks_active);
  endfunction : toggle_reset

  virtual function void configure(int idle_cycles = -1, int num_clks_active = -1);
    bfm.configure(idle_cycles, num_clks_active);
  endfunction : configure
  
endclass : async_reset_ctrl
