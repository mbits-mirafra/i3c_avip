`include "svunit_defines.svh"
`include "uvm_macros.svh"

module i3c_controller_tx_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_controller_unit_test_pkg::*;
  import i3c_globals_pkg::*;


  string name = "i3c_controller_tx_ut";
  svunit_testcase svunit_ut;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_controller_tx uut;

  // Custom variable for unit testing
  bit randSuccess;

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
  
  `SVTEST(Given_targetAddress_When_targetAddressWidth7_Expect_Sizeof7)
    int sizeOftargetAddress = $size(uut.targetAddress);
    `uvm_info("",$sformatf("sizeOftargetAddress = %0d",sizeOftargetAddress), UVM_HIGH)
    `FAIL_UNLESS(sizeOftargetAddress == 7)
  `SVTEST_END
  
  `SVTEST(Given_targetAddressInlineConstraint_When_targetAddresRandomized_Expect_Value10)
    void'(uut.randomize() with {uut.targetAddress == 7'd10;});
    `FAIL_UNLESS(uut.targetAddress == 7'd10)
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
  
  `SVTEST(Given_readDataStatusEnum_When_NACK_Value_StringNACK)
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

  // Conflicting contraints is an error but it doesn't stop the simualtion
  // Any failure of randomization engine will return FALSE (logic 0)
  // Hence we can use the success of randomization effectively for checking constraints

  // Group0 - 0000 XXX (8 addresses)
  `SVTEST(Given_targetAddressInLineContraint_When_reservedGroup0_Expect_RandomizationFailure)
    randSuccess = (uut.randomize() with {
                        uut.targetAddress inside {[7'b0000_000 : 7'b0000_111]};
                      });
    `FAIL_IF(randSuccess)
  `SVTEST_END

  // Group1 - 1111 XXX (8 addresses)
  `SVTEST(Given_targetAddressInLineContraint_When_reservedGroup1_Expect_RandomizationFailure)
    randSuccess = (uut.randomize() with {
                        uut.targetAddress inside {[7'b1111_000 : 7'b1111_111]};
                      });
    `FAIL_IF(randSuccess)
  `SVTEST_END


  `SVTEST(Given_targetAddressStatusEnum_When_NACK_Value_StringNACK)
    uut.targetAddressStatus = NACK;

    `FAIL_UNLESS_STR_EQUAL(uut.targetAddressStatus.name(),"NACK")
  `SVTEST_END

  `SVTEST(Given_targetAddressStatusEnum_When_ACK_Value_StringACK)
    uut.targetAddressStatus = ACK;

    `FAIL_UNLESS_STR_EQUAL(uut.targetAddressStatus.name(),"ACK")
  `SVTEST_END
  
  
  `SVTEST(Given_targetAddressStatusInlineConstraint_When_NACK_Expect_ValueofOne)
    void'(uut.randomize() with {
                uut.targetAddressStatus == NACK;
              });

    `FAIL_IF(uut.targetAddressStatus == 1)
  `SVTEST_END

  `SVTEST(Given_writeDataStatusEnum_When_NACK_Value_StringNACK)
    uut.writeDataStatus = new[1];
    uut.writeDataStatus[0] = NACK;

    `FAIL_UNLESS_STR_EQUAL(uut.writeDataStatus[0].name(),"NACK")
  `SVTEST_END

  `SVTEST(Given_writeDataStatusEnum_When_ACK_Value_StringACK)
    uut.writeDataStatus = new[1];
    uut.writeDataStatus[0] = ACK;

    `FAIL_UNLESS_STR_EQUAL(uut.writeDataStatus[0].name(),"ACK")
  `SVTEST_END
  
  
  `SVTEST(Given_writeDataStatusInlineConstraint_When_NACK_Expect_ValueofOne)
    void'(uut.randomize() with {
                uut.writeDataStatus.size() == 2;
                uut.writeDataStatus[0] == NACK;
                uut.writeDataStatus[1] == NACK;
              });

    `FAIL_IF(uut.writeDataStatus[0] == 1)
    `FAIL_IF(uut.writeDataStatus[1] == 1)
  `SVTEST_END


  `SVTEST(Given_writeDataSizeInlineConstraint_When_GreterThanMAXIMUM_BYTES_Expect_RandomizationFailure)
    randSuccess = (uut.randomize() with {
                        uut.writeData.size()>128;
                        });
    `FAIL_IF(randSuccess)
  `SVTEST_END

  `SVTEST(Given_CrossConstraint_When_OperationWRITExWriteDataSizeZero_Expect_RandomizationFailure)
    randSuccess = (uut.randomize() with {
                        uut.operation == WRITE;
                        uut.writeData.size()==0;
                        });
    `FAIL_IF(randSuccess)
  `SVTEST_END


  `SVTEST(Given_CrossConstraint_When_OperationiREADxTargetAddressLinit_Expect_RandomizationFailure)
    randSuccess = (uut.randomize() with {
                        uut.operation == READ;
                        uut.targetAddress == 7'b0000_111;
                        });
    `FAIL_IF(randSuccess)
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
