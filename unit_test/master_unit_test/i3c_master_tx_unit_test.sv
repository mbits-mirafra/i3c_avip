`include "svunit_defines.svh"

module i3c_master_tx_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_master_unit_test_pkg::*;
  import i3c_globals_pkg::*;


  string name = "i3c_master_tx_ut";
  svunit_testcase svunit_ut;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_master_tx my_i3c_master_tx;

  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    my_i3c_master_tx = new(/* New arguments if needed */);
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
  
  `SVTEST(Given_OperationInlineConstraint_When_Write_Expect_ValueZero)
    void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.operation == WRITE;});
    `FAIL_UNLESS(my_i3c_master_tx.operation == 0)
  `SVTEST_END

  `SVTEST(Given_OperationInlineConstraint_When_Read_Expect_ValueOne)
    void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.operation == READ;});
    `FAIL_UNLESS(my_i3c_master_tx.operation == 1)
  `SVTEST_END

  `SVTEST(Given_slaveAddress_When_slaveAddressWidth7_Expect_Sizeof7)
    `FAIL_UNLESS($size(my_i3c_master_tx.slaveAddress) == 7)
  `SVTEST_END
  
  `SVTEST(Given_writeDataArray_When_writeDataWidth8_Expect_SizeofEachElements8)
    for(int i=1;i<=3;i++) begin
      void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.writeData.size() == i;});
      for(int j=0;j<i;j++) begin
        `FAIL_UNLESS($size(my_i3c_master_tx.writeData[j]) == 8)
      end
    end
  `SVTEST_END

  `SVTEST(Given_readDataArray_When_readDataWidth8_Expect_SizeofEachElements8)
    for(int i=1;i<=3;i++) begin
      my_i3c_master_tx.readData.size() = i;
      for(int j=0;j<i;j++) begin
        `FAIL_UNLESS($size(my_i3c_master_tx.readData[j]) == 8)
      end
    end
  `SVTEST_END
  
  `SVUNIT_TESTS_END

endmodule
