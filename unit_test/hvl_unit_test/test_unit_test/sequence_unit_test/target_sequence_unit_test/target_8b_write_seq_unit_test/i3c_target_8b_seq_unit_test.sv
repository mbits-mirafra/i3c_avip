`include "svmock_defines.svh"
`include "svunit_defines.svh"
`include "uvm_macros.svh"

`include "uvm_sequence_mock.svh"
 import svmock_pkg::*;

module i3c_target_8b_seq_unit_test;
  import svunit_pkg::svunit_testcase;

  import uvm_pkg::*;
  import i3c_globals_pkg::*;
  import i3c_target_8b_seq_unit_test_pkg::*;

  string name = "i3c_target_8b_seq_ut";
  svunit_testcase svunit_ut;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  `SVMOCK_UVM_SEQUENCE(i3c_target_8b_seq)
  i3c_target_8b_seq_mock #(i3c_target_tx) uut;
  i3c_target_tx req;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    uut = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

    `ON_CALL(uut, start).will_by_default("_start");
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

    `FAIL_UNLESS(uut.verify())
  endtask
  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN



  `SVUNIT_TESTS_END

endmodule
