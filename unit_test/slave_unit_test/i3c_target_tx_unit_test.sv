`include "svunit_defines.svh"
`include "uvm_macros.svh"

module i3c_target_tx_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_slave_unit_test_pkg::*;
  import i3c_globals_pkg::*;

  string name = "i3c_slave_tx_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_target_tx target_tx_uut;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    target_tx_uut = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

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
     `SVTEST(Given_operationInlineConstraint_When_Write_Expect_ValueZero)
      void'(target_tx_uut.randomize() with {target_tx_uut.operation == WRITE;});
     `FAIL_UNLESS(target_tx_uut.operation == 0)
     `SVTEST_END


  `SVUNIT_TESTS_END
  endmodule
