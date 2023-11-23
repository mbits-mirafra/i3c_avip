module __testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  i3c_master_8b_read_seq_unit_test i3c_master_8b_read_seq_ut();


  //===================================
  // Build
  //===================================
  function void build();
    i3c_master_8b_read_seq_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(i3c_master_8b_read_seq_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    i3c_master_8b_read_seq_ut.run();
    svunit_ts.report();
  endtask

endmodule
