`include "svunit_defines.svh"
`include "uvm_macros.svh"

module i3c_target_agent_config_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_target_agent_config_unit_test_pkg::*;
  import i3c_globals_pkg::*;

  string name = "i3c_target_agent_config_ut";
  svunit_testcase svunit_ut;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_target_agent_config uut;

  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

   uut  = new(/* New arguments if needed */);
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

  `SVTEST(Given_DataTransferdirection_When_MSBFirst_Expect_ValueString_MSB_FIRST)
  uut.DataTransferdirection = 	MSB_FIRST;
  `FAIL_UNLESS_STR_EQUAL(uut.DataTransferdirection.name(),"MSB_FIRST")
  `SVTEST_END

  `SVTEST(Given_DataTransferdirection_When_LSBFirst_Expect_ValueString_LSB_FIRST)
  uut.DataTransferdirection = LSB_FIRST;
  `FAIL_UNLESS_STR_EQUAL(uut.DataTransferdirection.name(),"LSB_FIRST")
  `SVTEST_END

  `SVTEST(Given_targetAddress_When_FixingSizeOfArray_Expect_ArraysizeOfFive)
  uut.targetAddress = new[5];
  `FAIL_UNLESS(uut.targetAddress.size() == 5)
   `SVTEST_END
  
  `SVTEST(Given_defaultReadData_When_defaultValueAndSize_Expect_ValueFFandSize8)
  `FAIL_UNLESS($size(uut.defaultReadData) == 8) 
  `FAIL_UNLESS(uut.defaultReadData == 'hFF)
  `SVTEST_END

  `SVTEST(Given_targetFIFOMemory_When_pushbackAndpopfrontTotargetFIFOMemory_Expect_dataComparisionSuccess)
   bit dataComparisionSuccess;
   uut.targetFIFOMemory.push_back(8'hff);
   `FAIL_UNLESS(uut.targetFIFOMemory.pop_front() == 8'hff)
   `SVTEST_END

   `SVTEST(Given_targetFIFOMemory_When_PushingBackDataTotargetFIFOMemory_Expect_SizeOfElement8)
   bit sizeComparisionSuccess;
   uut.targetFIFOMemory.push_back(8'b1010_1010);
   if($size(uut.targetFIFOMemory[0]) == 8) 
   sizeComparisionSuccess = 1;
   else
   sizeComparisionSuccess = 0; 
   `FAIL_UNLESS(sizeComparisionSuccess)
   `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
