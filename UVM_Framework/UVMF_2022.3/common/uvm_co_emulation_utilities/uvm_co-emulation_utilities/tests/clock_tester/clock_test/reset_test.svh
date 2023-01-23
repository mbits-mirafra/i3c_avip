class reset_test extends base_test;

  `uvm_component_utils(reset_test)

  function new(string name = "reset_test", uvm_component parent = null);
    super.new(name, parent);
    report_id = name;
  endfunction : new

  function void build_phase(uvm_phase phase);
    clock_period[0] = 4000;
    clock_period[1] = 3000;
    clock_period[2] = 5000;

    //Turn on stats collection for the resets for this test
    reset_ctrl_base::set_stat_collection(1);

    super.build_phase(phase);
    
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

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

  task initial_test_sync_reset(int num);
    reset_ctrl[num].wait_reset_deassertion();
    `uvm_info(report_id, $sformatf("sync reset %0d deasserted", num), UVM_LOW)
    
    clk_ctrl[num].wait_clocks(10);

    for (int ii = 0; ii < 30; ii++)
      test_sync_reset(num, $urandom_range(1,15), $urandom_range(3, 100));
  endtask : initial_test_sync_reset
  
  task test_sync_reset(int num, int idle_cycles = 10, int num_clks_active = 100);
    fork
      test_sync_reset_thread(num, idle_cycles, num_clks_active);
      test_sync_reset_thread(num, idle_cycles, num_clks_active);
      test_sync_reset_thread(num, idle_cycles, num_clks_active);
      reset_ctrl[num].toggle_reset(.idle_cycles(idle_cycles),
                                   .num_clks_active(num_clks_active),
                                   .file(`__FILE__),.line(`__LINE__));
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
      0: async_reset_ctrl0.wait_reset_deassertion();
      1: async_reset_ctrl1.wait_reset_deassertion();
      2: async_reset_ctrl2.wait_reset_deassertion();
    endcase
    `uvm_info(report_id, $sformatf("async reset %0d deasserted", num), UVM_LOW)
    
    clk_ctrl[num].wait_clocks(10);

    for (int ii = 0; ii < 30; ii++)
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


  
endclass : reset_test
