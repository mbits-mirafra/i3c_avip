module __target_tx_unit_test_testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__target_tx_unit_test_ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  i3c_target_tx_unit_test i3c_target_tx_ut();


  //===================================
  // Build
  //===================================
  function void build();
    i3c_target_tx_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(i3c_target_tx_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    i3c_target_tx_ut.run();
    svunit_ts.report();
  endtask

endmodule
