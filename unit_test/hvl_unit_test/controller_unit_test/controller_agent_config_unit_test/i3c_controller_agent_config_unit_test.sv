`include "svunit_defines.svh"

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "i3c_globals_pkg.sv"
import i3c_globals_pkg::*;

`include "i3c_controller_agent_config.sv"

module i3c_controller_agent_config_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "i3c_controller_agent_config_ut";
  svunit_testcase svunit_ut;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_controller_agent_config uut;


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

    `SVTEST(Given_isActiveEnum_When_UVM_ACTIVE_Expect_ValueString_UVM_ACTIVE)
    `FAIL_UNLESS_STR_EQUAL(uut.isActive.name(),"UVM_ACTIVE")
  `SVTEST_END
  
  `SVTEST(Given_hasCoverage_When_IsOne_Expect_ValueOne)
    `FAIL_UNLESS(uut.hasCoverage == 1)
  `SVTEST_END

  `SVTEST(Given_DataTransferdirectionInlineConstraint_When_MSBFirst_Expect_ValueString_MSB_FIRST)
    void'(uut.randomize() with {
            uut.DataTransferdirection ==	MSB_FIRST;});
    `FAIL_UNLESS_STR_EQUAL(uut.DataTransferdirection.name(),"MSB_FIRST")
  `SVTEST_END

  `SVTEST(Given_DataTransferdirectionInlineConstraint_When_LSBFirst_Expect_ValueString_LSB_FIRST)
    void'(uut.randomize() with {
            uut.DataTransferdirection ==	LSB_FIRST;});
    `FAIL_UNLESS_STR_EQUAL(uut.DataTransferdirection.name(),"LSB_FIRST")
  `SVTEST_END

  `SVTEST(Given_targetAddress_When_FixingSizeOfArray_Expect_ArraysizeOfFiveAndSizeOfElementSeven)
    uut.targetAddress = new[5];
    `FAIL_UNLESS(uut.targetAddress.size() == 5)
    `FAIL_UNLESS($size(uut.targetAddress[0]) == 7)
  `SVTEST_END

  `SVTEST(Given_ArgumentToSetClockRateDividervalueMethod_When_calledGetClockRateDividerValueMethod_Expect_ReturnValue12)
    bit [2:0] primary_prescalar = 1;
    bit [2:0] secondary_prescalar = 2;
  
    uut.set_clockrate_divider_value(
                          primary_prescalar,
                          secondary_prescalar);
    `FAIL_UNLESS(uut.get_clockrate_divider_value() == 12)
  `SVTEST_END

`SVUNIT_TESTS_END

endmodule
