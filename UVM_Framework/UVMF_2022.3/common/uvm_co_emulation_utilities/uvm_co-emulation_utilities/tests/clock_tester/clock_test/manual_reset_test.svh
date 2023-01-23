class manual_reset_test extends base_test;

  `uvm_component_utils(manual_reset_test)

  function new(string name = "manual_reset_test", uvm_component parent = null);
    super.new(name, parent);
    report_id = name;
  endfunction : new

  function void build_phase(uvm_phase phase);
    clock_period[0] = 10000;
    clock_period[1] = 3000;
    clock_period[2] = 7000;

    //Turn on stats collection for the resets for this test
    reset_ctrl_base::set_stat_collection(1);

    super.build_phase(phase);
    
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    fork
      initial_test_manual_ctrl(0);
      initial_test_manual_ctrl(1);
      initial_test_manual_ctrl(2);
    join

    `uvm_info(report_id, "Starting automatic reset toggles", UVM_LOW)
    
    fork
      initial_test_sync_reset(0);
      initial_test_sync_reset(1);
      initial_test_sync_reset(2);
      initial_test_async_reset(0);
      initial_test_async_reset(1);
      initial_test_async_reset(2);
    join
      
    phase.drop_objection(this);
  endtask : run_phase

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    reset_ctrl_base::print_stats();
  endfunction : report_phase

  task initial_test_manual_ctrl(int num);
    test_manual_ctrl(num, 1);
    for (int ii = 0; ii < 30; ii++)
      test_manual_ctrl(num, 0);
  endtask : initial_test_manual_ctrl

  task test_manual_ctrl(int num, bit set_mc = 0);
    int unsigned waittime;
    if (set_mc) reset_ctrl[num].set_manual_control(1); //Used for time 0
    waittime = $urandom_range(5,20);
    `uvm_info(report_id, $sformatf("Waiting for %0d clocks for group %0d to assert_reset", waittime, num), UVM_MEDIUM)
    clk_ctrl[num].wait_clocks(waittime);
    reset_ctrl[num].assert_reset(`__FILE__, `__LINE__);
    waittime = $urandom_range(50,100);
    `uvm_info(report_id, $sformatf("Waiting for %0d clocks for group %0d to deassert_reset", waittime, num), UVM_MEDIUM)
    clk_ctrl[num].wait_clocks(waittime);
    reset_ctrl[num].deassert_reset(`__FILE__, `__LINE__);
  endtask : test_manual_ctrl
  

  task initial_test_sync_reset(int num);
    reset_ctrl[num].wait_reset_deasserted();
    `uvm_info(report_id, $sformatf("sync reset %0d deasserted", num), UVM_LOW)
    
    clk_ctrl[num].wait_clocks(10);

    for (int ii = 0; ii < 10; ii++)
      test_sync_reset(num, $urandom_range(1,15), $urandom_range(3, 100));
  endtask : initial_test_sync_reset
  
  task test_sync_reset(int num, int idle_cycles = 10, int num_clks_active = 100);
    fork
      test_sync_reset_thread(num, idle_cycles, num_clks_active);
      test_sync_reset_thread(num, idle_cycles, num_clks_active);
      test_sync_reset_thread(num, idle_cycles, num_clks_active);
      reset_ctrl[num].toggle_reset(.idle_cycles(idle_cycles), .num_clks_active(num_clks_active), .file(`__FILE__),.line(`__LINE__));
    join
    
  endtask : test_sync_reset

  task test_sync_reset_thread(int num, int idle_cycles = 10, int num_clks_active = 100);
    time start_time = $time;
    
    reset_ctrl[num].wait_reset_assertion();
    `uvm_info(report_id, $sformatf("sync reset %0d asserted", num), UVM_LOW)
    if (start_time + ((idle_cycles + 1) * clock_period[num]) != $time)
      `uvm_error(report_id, $sformatf("sync reset %0d asserted at incorrect time", num))
    reset_ctrl[num].wait_reset_deassertion();
    `uvm_info(report_id, $sformatf("sync reset %0d deasserted", num), UVM_LOW)
    if (start_time + ((idle_cycles + 1 + num_clks_active) * clock_period[num]) != $time)
      `uvm_error(report_id, $sformatf("sync reset %0d deasserted at incorrect time", num))
  endtask : test_sync_reset_thread

  

  task initial_test_async_reset(int num);
    case (num)
      0: async_reset_ctrl0.wait_reset_deasserted();
      1: async_reset_ctrl1.wait_reset_deasserted();
      2: async_reset_ctrl2.wait_reset_deasserted();
    endcase
    `uvm_info(report_id, $sformatf("async reset %0d deasserted", num), UVM_LOW)
    
    clk_ctrl[num].wait_clocks(10);

    for (int ii = 0; ii < 10; ii++)
      test_async_reset(num, $urandom_range(1,15), $urandom_range(3, 100));
  endtask : initial_test_async_reset
  
  task test_async_reset(int num, int idle_cycles = 10, int num_clks_active = 100);
    time start_time;

    start_time = $time;
    fork
      test_async_reset_thread(num, idle_cycles, num_clks_active);
      test_async_reset_thread(num, idle_cycles, num_clks_active);
      test_async_reset_thread(num, idle_cycles, num_clks_active);
      case (num)
        0: async_reset_ctrl0.toggle_reset(.idle_cycles(idle_cycles),.num_clks_active(num_clks_active), .file(`__FILE__),.line(`__LINE__));
        1: async_reset_ctrl1.toggle_reset(.idle_cycles(idle_cycles),.num_clks_active(num_clks_active), .file(`__FILE__),.line(`__LINE__));
        2: async_reset_ctrl2.toggle_reset(.idle_cycles(idle_cycles),.num_clks_active(num_clks_active), .file(`__FILE__),.line(`__LINE__));
      endcase
    join
    
  endtask : test_async_reset

  task test_async_reset_thread(int num, int idle_cycles = 10, int num_clks_active = 100);
    time start_time = $time;
    
    case (num)
      0: async_reset_ctrl0.wait_reset_assertion();
      1: async_reset_ctrl1.wait_reset_assertion();
      2: async_reset_ctrl2.wait_reset_assertion();
    endcase
    `uvm_info(report_id, $sformatf("async reset %0d asserted", num), UVM_LOW)
    if (start_time + ((idle_cycles + 1 + 1) * clock_period[num]) != $time)
      `uvm_error(report_id, $sformatf("async reset %0d asserted at incorrect time", num))
    case (num)
      0: async_reset_ctrl0.wait_reset_deassertion();
      1: async_reset_ctrl1.wait_reset_deassertion();
      2: async_reset_ctrl2.wait_reset_deassertion();
    endcase
    `uvm_info(report_id, $sformatf("async reset %0d deasserted", num), UVM_LOW)
    if (start_time + ((idle_cycles + 1 + num_clks_active + 1) * clock_period[num]) != $time)
      `uvm_error(report_id, $sformatf("async reset %0d deasserted at incorrect time", num))
  endtask : test_async_reset_thread


  
endclass : manual_reset_test
