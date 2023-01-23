class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  string  report_id = "BASE_TEST";

  //variable: clk_ctrl
  //Clock Proxy Object used to control the Clock
  // Must be extended clock_ctrl object and not clock_ctrl_base because
  // bfm is set here.  Usage elsewhere in testbench can just use a
  // clock_ctrl_base handle.
  clock_ctrl #(shared_params_pkg::CLK_INIT_HALF_PERIOD_IN_PS,
               shared_params_pkg::CLK_PHASE_OFFSET_IN_PS) clk_ctrl[shared_params_pkg::NUM_CLK_RSTS];
  
  //variable: reset_ctrl
  //Reset Proxy Object used to control Reset
  // Must be extended reset_ctrl object and not reset_ctrl_base because bfm
  // is set here.  Usage elsewhere in testbench can just use a reset_ctrl_base
  // handle
  sync_reset_ctrl #(shared_params_pkg::RST_POLARITY) reset_ctrl[shared_params_pkg::NUM_CLK_RSTS];
  
  //variable: async_reset_ctrl
  //Reset Proxy Object used to control Reset
  // Must be extended reset_ctrl object and not reset_ctrl_base because bfm
  // is set here.  Usage elsewhere in testbench can just use a reset_ctrl_base
  // handle
  async_reset_ctrl #(shared_params_pkg::ASYNC_RST_POLARITY,
                     shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS,
                     shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS) async_reset_ctrl0;
  async_reset_ctrl #(shared_params_pkg::ASYNC_RST_POLARITY,
                     shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS * 2,
                     shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS * 2) async_reset_ctrl1;
  async_reset_ctrl #(shared_params_pkg::ASYNC_RST_POLARITY,
                     shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS * 3,
                     shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS * 3) async_reset_ctrl2;

  int clock_period[shared_params_pkg::NUM_CLK_RSTS] = '{2000, 3000, 5000};

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    //Temp handle to clock_bfm and reset_bfm
    virtual clock_bfm #(shared_params_pkg::CLK_INIT_HALF_PERIOD_IN_PS, shared_params_pkg::CLK_PHASE_OFFSET_IN_PS) clk_bfm;
    virtual sync_reset_bfm #(shared_params_pkg::RST_POLARITY) sync_rst_bfm;
    virtual async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                              shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS,
                              shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS) async_rst_bfm0;
    virtual async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                              shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS * 2,
                              shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS * 2) async_rst_bfm1;
    virtual async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                              shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS * 3,
                              shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS * 3) async_rst_bfm2;
    
    // Create the clock ctrl
    for (int ii = 0; ii < shared_params_pkg::NUM_CLK_RSTS; ii++) begin
      clk_ctrl[ii] = clock_ctrl #(shared_params_pkg::CLK_INIT_HALF_PERIOD_IN_PS, shared_params_pkg::CLK_PHASE_OFFSET_IN_PS)::type_id::create($sformatf("clk_ctrl%0d", ii));
      //Set the bfm handle in the clk_ctrl
      if (!uvm_config_db#(virtual clock_bfm #(shared_params_pkg::CLK_INIT_HALF_PERIOD_IN_PS, shared_params_pkg::CLK_PHASE_OFFSET_IN_PS))::get(this, "", $sformatf("clk%0d_if_h", ii), clk_bfm)) begin
        `uvm_fatal(report_id, $sformatf("Could not get the Clock %0d BFM Interface", ii))
      end
      clk_ctrl[ii].set_bfm(clk_bfm);

      // Create the reset ctrl
      reset_ctrl[ii] = sync_reset_ctrl #(shared_params_pkg::RST_POLARITY)::type_id::create($sformatf("reset_ctrl%0d", ii));
      //Set the bfm handle in the reset_ctrl
      if (!uvm_config_db#(virtual sync_reset_bfm #(shared_params_pkg::RST_POLARITY))::get(this, "", $sformatf("rst%0d_if_h", ii), sync_rst_bfm)) begin
        `uvm_fatal(report_id, $sformatf("Could not get the Reset %0d BFM Interface", ii))
      end
      reset_ctrl[ii].set_bfm(sync_rst_bfm);
    
      //Setup a period of 4 ns (half period of 2ns)
      clk_ctrl[ii].update_half_period_in_ps(clock_period[ii]/2);

      //Setup the Reset Clock Cycle Numbers
      reset_ctrl[ii].configure(.idle_cycles(0), .num_clks_active((ii+1)*50));
    end // for (int ii = 0; ii < shared_params_pkg::NUM_CLK_RSTS; ii++)

    // Create the async reset ctrl
    async_reset_ctrl0 = async_reset_ctrl #(shared_params_pkg::ASYNC_RST_POLARITY,
                   shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS,
                   shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS)::type_id::create("async_reset_ctrl0");
    //Set the bfm handle in the reset_ctrl
    if (!uvm_config_db#(virtual async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                   shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS,
                   shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS))::get(this, "", "async_rst0_if_h", async_rst_bfm0)) begin
      `uvm_fatal(report_id, "Could not get the Async Reset 0 BFM Interface")
    end
    async_reset_ctrl0.set_bfm(async_rst_bfm0);

    // Create the async reset ctrl
    async_reset_ctrl1 = async_reset_ctrl #(shared_params_pkg::ASYNC_RST_POLARITY,
                   shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS*2,
                   shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS*2)::type_id::create("async_reset_ctrl1");
    //Set the bfm handle in the reset_ctrl
    if (!uvm_config_db#(virtual async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                   shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS*2,
                   shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS*2))::get(this, "", "async_rst1_if_h", async_rst_bfm1)) begin
      `uvm_fatal(report_id, "Could not get the Async Reset 1 BFM Interface")
    end
    async_reset_ctrl1.set_bfm(async_rst_bfm1);

    // Create the async reset ctrl
    async_reset_ctrl2 = async_reset_ctrl #(shared_params_pkg::ASYNC_RST_POLARITY,
                   shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS*3,
                   shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS*3)::type_id::create("async_reset_ctrl2");
    //Set the bfm handle in the reset_ctrl
    if (!uvm_config_db#(virtual async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                   shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS*3,
                   shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS*3))::get(this, "", "async_rst2_if_h", async_rst_bfm2)) begin
      `uvm_fatal(report_id, "Could not get the Async Reset 2 BFM Interface")
    end
    async_reset_ctrl2.set_bfm(async_rst_bfm2);
    
  endfunction : build_phase
  

endclass : base_test
