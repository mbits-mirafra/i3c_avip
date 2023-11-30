module __testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  i3c_target_agent_config_unit_test i3c_target_agent_config_ut();


  //===================================
  // Build
  //===================================
  function void build();
    i3c_target_agent_config_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(i3c_target_agent_config_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    i3c_target_agent_config_ut.run();
    svunit_ts.report();
  endtask

endmodule
