`include "svunit_defines.svh"
`include "uvm_macros.svh"

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
  i3c_master_tx uut;

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
  
  `SVTEST(Given_operationInlineConstraint_When_Write_Expect_ValueZero)
    void'(uut.randomize() with {uut.operation == WRITE;});
    `FAIL_UNLESS(uut.operation == 0)
  `SVTEST_END

  `SVTEST(Given_OperationInlineConstraint_When_Read_Expect_ValueOne)
    void'(uut.randomize() with {uut.operation == READ;});
    `FAIL_UNLESS(uut.operation == 1)
  `SVTEST_END

  `SVTEST(Given_OperationEnum_When_READ_Value_StringREAD)
    uut.operation = READ;
    `FAIL_UNLESS_STR_EQUAL(uut.operation.name(),"READ")
  `SVTEST_END

  `SVTEST(Given_OperationEnum_When_WRITE_Value_StringWRITE)
    uut.operation = WRITE;
    `FAIL_UNLESS_STR_EQUAL(uut.operation.name(),"WRITE")
  `SVTEST_END
  
  `SVTEST(Given_SlaveAddress_When_SlaveAddressWidth7_Expect_Sizeof7)
    int sizeOfSlaveAddress = $size(uut.slaveAddress);
    `uvm_info("",$sformatf("sizeOfSlaveAddress = %0d",sizeOfSlaveAddress), UVM_HIGH)
    `FAIL_UNLESS(sizeOfSlaveAddress == 7)
  `SVTEST_END
  
  `SVTEST(Given_SlaveAddressInlineConstraint_When_SlaveAddresRandomized_Expect_Value10)
    void'(uut.randomize() with {uut.slaveAddress == 7'd10;});
    `FAIL_UNLESS(uut.slaveAddress == 7'd10)
  `SVTEST_END

  `SVTEST(Given_writeDataArray_When_writeDataWidth8_Expect_SizeofEachElement8)
      uut.writeData = new[2];

      `FAIL_UNLESS($size(uut.writeData[0]) == 8)
      `FAIL_UNLESS($size(uut.writeData[1]) == 8)
  `SVTEST_END

  `SVTEST(Given_writeDataArray_When_Randomized_Expect_ValueNonZero)
    void'(uut.randomize() with {
                uut.writeData.size() == 2;
                uut.writeData[0] == 10;
                uut.writeData[1] == 12;
              });

    `FAIL_IF(uut.writeData[0] == 0)
    `FAIL_IF(uut.writeData[1] == 0)
  `SVTEST_END
  
  `SVTEST(Given_readDataArray_When_readDataWidth8_Expect_SizeofEachElements8)
      uut.readData = new[2];

      `FAIL_UNLESS($size(uut.readData[0]) == 8)
      `FAIL_UNLESS($size(uut.readData[1]) == 8)
  `SVTEST_END

  `SVTEST(Given_readDataArray_When_Randomized_Expect_ValueofZero)
    void'(uut.randomize() with {
                uut.readData.size() == 2;
                uut.readData[0] == 10;
                uut.readData[1] == 10;
              });

    `FAIL_UNLESS(uut.readData[0] == 0)
    `FAIL_UNLESS(uut.readData[1] == 0)
  `SVTEST_END

  `SVTEST(Given_readDataStatusEnum_When_ACK_Value_StringACK)
    uut.readDataStatus = new[1];
    uut.readDataStatus[0] = ACK;

    `FAIL_UNLESS_STR_EQUAL(uut.readDataStatus[0].name(),"ACK")
  `SVTEST_END
  
  `SVTEST(Given_readDataStatusEnum_When_NACK_Value_StringACK)
    uut.readDataStatus = new[1];
    uut.readDataStatus[0] = NACK;

    `FAIL_UNLESS_STR_EQUAL(uut.readDataStatus[0].name(),"NACK")
  `SVTEST_END
  
  `SVTEST(Given_readDataStatusInlineConstraint_When_NACK_Expect_ValueofOne)
    void'(uut.randomize() with {
                uut.readDataStatus.size() == 2;
                uut.readDataStatus[0] == NACK;
                uut.readDataStatus[1] == NACK;
              });

    `FAIL_UNLESS(uut.readDataStatus[0] == 1)
    `FAIL_UNLESS(uut.readDataStatus[1] == 1)
  `SVTEST_END

  `SVTEST(Given_readDataStatusInlineConstraint_When_ACK_Expect_ValueofZero)
    void'(uut.randomize() with {
                uut.readDataStatus.size() == 2;
                uut.readDataStatus[0] == ACK;
                uut.readDataStatus[1] == ACK;
              });

    `FAIL_UNLESS(uut.readDataStatus[0] == 0)
    `FAIL_UNLESS(uut.readDataStatus[1] == 0)
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
