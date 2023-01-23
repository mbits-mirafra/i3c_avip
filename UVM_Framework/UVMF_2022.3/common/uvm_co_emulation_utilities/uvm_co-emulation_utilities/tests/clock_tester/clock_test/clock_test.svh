class clock_test extends base_test;

  `uvm_component_utils(clock_test)

  function new(string name = "clock_test", uvm_component parent = null);
    super.new(name, parent);
    report_id = name;
  endfunction : new

  function void build_phase(uvm_phase phase);
    clock_period[0] = 4000;
    clock_period[1] = 3000;
    clock_period[2] = 5000;

    //Turn on stats collection for the clocks for this test
    clock_ctrl_base::set_stat_collection(1);

    super.build_phase(phase);
    
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    big_test_wait_clocks();
    
    phase.drop_objection(this);
  endtask : run_phase

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    clock_ctrl_base::print_stats();
  endfunction : report_phase

  task test_clk_rst(int num = 0);
    //Wait for Reset
    reset_ctrl[num].wait_reset_assertion();
    `uvm_info(report_id, "thread0: reset asserted", UVM_LOW)
    reset_ctrl[num].wait_reset_deassertion();
    `uvm_info(report_id, "thread0: reset deasserted", UVM_LOW)

    fork
      begin : thread3
        `uvm_info(report_id, "thread3: After reset before waiting for 100 clocks", UVM_LOW)
        test_wait_clocks(num, 100);
        `uvm_info(report_id, "thread3: After waiting for 100 clocks", UVM_LOW)
      end
      begin : thread4
        `uvm_info(report_id, "thread4: After reset before waiting for 10 clocks", UVM_LOW)
        test_wait_clocks(num, 10);
        `uvm_info(report_id, "thread4: After waiting for 10 clocks", UVM_LOW)
        test_wait_clocks(num, 10);
        `uvm_info(report_id, "thread4: After waiting for 10 clocks", UVM_LOW)
        test_wait_clocks(num, 10);
        `uvm_info(report_id, "thread4: After waiting for 10 clocks", UVM_LOW)
        test_wait_clocks(num, 10);
        `uvm_info(report_id, "thread4: After waiting for 10 clocks", UVM_LOW)
      end
      begin : thread5
        `uvm_info(report_id, "thread5: After reset before waiting for incrementing clocks", UVM_LOW)
        for (int ii = 1; ii < 50; ii++) begin
          `uvm_info(report_id, $sformatf("thread5: before waiting for %0d clocks", ii), UVM_LOW)
          test_wait_clocks(num, ii);
          `uvm_info(report_id, $sformatf("thread5: after waiting for %0d clocks", ii), UVM_LOW)
        end
      end
    join 

    reset_ctrl[num].toggle_reset();
    reset_ctrl[num].wait_reset_deassertion();
    `uvm_info(report_id, "reset deasserted", UVM_LOW)

    fork
      begin : thread6
        test_wait_clocks(num, 29);
        test_wait_clocks(num, 29);
        test_wait_clocks(num, 29);
        test_wait_clocks(num, 29);
      end
      begin : thread7
        for (int ii = 100; ii > 0; ii-=2)
          test_wait_clocks(num, ii);
      end
      begin : thread8
        test_wait_clocks(num, 300);
      end
    join
    `uvm_info(report_id, "End of More Wait for Clocks", UVM_LOW)

    for(int ii=1; ii< 200 ; ii++)begin
      fork
        parall_wait_cycles_self_check(num, ii);
        parall_wait_cycles_self_check(num, ii);
      join
    end
    
  endtask : test_clk_rst

  task big_test_wait_clocks();
    //Wait for Reset
    reset_ctrl[2].wait_reset_assertion();
    `uvm_info(report_id, "reset 2 asserted", UVM_LOW)
    reset_ctrl[2].wait_reset_deassertion();
    `uvm_info(report_id, "reset 2 deasserted", UVM_LOW)
    
    for(int ii=1; ii< 200 ; ii++)begin
      fork
        parall_wait_cycles_self_check(0, ii, (2*ii));
        parall_wait_cycles_self_check(0, ii, (2*ii)+1);
        parall_wait_cycles_self_check(1, ii, (2*ii));
        parall_wait_cycles_self_check(1, ii, (2*ii)+1);
        parall_wait_cycles_self_check(2, ii, (2*ii));
        parall_wait_cycles_self_check(2, ii, (2*ii)+1);
      join_any
    end
    wait fork;

    `uvm_info(report_id, "Changing the clock frequencies", UVM_LOW)
    //Now Change the clock frequency and check to ensure everything still works.
    clock_period[0] = 2000;
    clock_period[1] = 6000;
    clock_period[2] = 7000;
    for (int ii = 0; ii < shared_params_pkg::NUM_CLK_RSTS; ii++) begin
      clk_ctrl[ii].update_half_period_in_ps(clock_period[ii]/2);
    end
    //Now wait a single clock cycle to resync everything
    fork
      clk_ctrl[0].wait_clocks(1, `__FILE__, `__LINE__);
      clk_ctrl[1].wait_clocks(1, `__FILE__, `__LINE__);
      clk_ctrl[2].wait_clocks(1, `__FILE__, `__LINE__);
    join

    //Now run the test again
    for(int ii=1; ii< 200 ; ii++)begin
      fork
        parall_wait_cycles_self_check(0, ii, (2*ii));
        parall_wait_cycles_self_check(0, ii, (2*ii)+1);
        parall_wait_cycles_self_check(1, ii, (2*ii));
        parall_wait_cycles_self_check(1, ii, (2*ii)+1);
        parall_wait_cycles_self_check(2, ii, (2*ii));
        parall_wait_cycles_self_check(2, ii, (2*ii)+1);
      join_any
    end
    wait fork;

    `uvm_info(report_id, "Changing the clock frequencies", UVM_LOW)
    //Now Change the clock frequency and check to ensure everything still works.
    clock_period[0] = 11000;
    clock_period[1] = 500;
    clock_period[2] = 1000;
    for (int ii = 0; ii < shared_params_pkg::NUM_CLK_RSTS; ii++) begin
      clk_ctrl[ii].update_half_period_in_ps(clock_period[ii]/2);
    end
    //Now wait a single clock cycle to resync everything
    fork
      clk_ctrl[0].wait_clocks(1, `__FILE__, `__LINE__);
      clk_ctrl[1].wait_clocks(1, `__FILE__, `__LINE__);
      clk_ctrl[2].wait_clocks(1, `__FILE__, `__LINE__);
    join

    //Now run the test again
    for(int ii=1; ii< 200 ; ii++)begin
      fork
        parall_wait_cycles_self_check(0, ii, (2*ii));
        parall_wait_cycles_self_check(0, ii, (2*ii)+1);
        parall_wait_cycles_self_check(1, ii, (2*ii));
        parall_wait_cycles_self_check(1, ii, (2*ii)+1);
        parall_wait_cycles_self_check(2, ii, (2*ii));
        parall_wait_cycles_self_check(2, ii, (2*ii)+1);
      join_any
    end
    wait fork;
    
  endtask : big_test_wait_clocks

  
  task test_wait_clocks(int clk_num = 0, int num_advance = 1);
    time expected_time = num_advance * clock_period[clk_num];
    time start_time = $time;
    time end_time;
    
    clk_ctrl[clk_num].wait_clocks(num_advance, `__FILE__, `__LINE__);
    end_time = $time;

    if (expected_time != (end_time - start_time))
      `uvm_error(report_id, $sformatf("Clock Num: %0d  Wait Clocks %0d  start_time: %t  end_time: %t  expected_time: %t", clk_num, num_advance, start_time, end_time, start_time + expected_time))
      //`uvm_error(report_id, $sformatf("Clock Num: %0d  Wait Clocks %0d  start_time: %t  end_time: %t  expected_time: %t  Queue: %s", clk_num, num_advance, start_time, end_time, start_time + expected_time, $get_id_from_handle(clk_ctrl[clk_num].dTimeQueue)))
  endtask : test_wait_clocks

  task parall_wait_cycles_self_check(int index , int thread_num = 10, int id = -1);
    automatic bit fail;
    automatic time start, finish;
    automatic time period;
    automatic int max_cycles =0;
    automatic int cycles_same = $urandom_range(100,1);
    automatic bit mode = $urandom_range(1,0);
    period = clock_period[index];

    `uvm_info(report_id, $sformatf("Call parall_wait_cycles_self_check to check clock[%0d], thread_num %0d, period: %0d" , index,thread_num , period), UVM_LOW);
    clk_ctrl[index].wait_clocks(1, `__FILE__, `__LINE__); //Single clock wait to get the thread synchronized to the clock edge
    start  = $time;
    begin
      for(int i =0 ; i<thread_num ; i ++) begin
        automatic int cycles = mode==0?cycles_same:$urandom_range(100,9);
        automatic int ii = i;
        if(cycles>max_cycles) max_cycles = cycles;
        //`uvm_info(report_id , $sformatf("clock[%0d], thread_num: %0d, period: %0d, id: %0d, i: %0d  Before Fork , cycle number :%d", index, thread_num, period, id, i, cycles) , UVM_LOW)

        fork
          begin
            //`uvm_info(report_id , $sformatf("clock[%0d], thread_num: %0d, period: %0d, id: %0d, i: %0d   Wait Begin , cycle number :%d", index, thread_num, period, id, ii, cycles) , UVM_LOW)
            test_wait_clocks(index, cycles);
            //`uvm_info(report_id , $sformatf("clock[%0d], thread_num: %0d, period: %0d, id: %0d, i: %0d   Wait End , cycle number :%d",  index, thread_num, period, id, ii, cycles) , UVM_LOW)
          end
        join_none
      end
    end
    wait fork;

    finish  = $time;
    if(((finish-start)>max_cycles*period) | ((finish-start)<(max_cycles-1)*period))
      begin
        `uvm_error(report_id , $sformatf("<< clock[%0d] >> Max : %d, Min : %d , Now: %d" , index,  max_cycles*period , (max_cycles-1)*period , finish-start))
        `uvm_info(report_id, $sformatf("period: %d , start:%d , end:%d , max_cycles: %d" , period , start , finish , max_cycles), UVM_MEDIUM);
      end
  endtask : parall_wait_cycles_self_check
  
endclass : clock_test
