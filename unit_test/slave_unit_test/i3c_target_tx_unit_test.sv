`include "svunit_defines.svh"
`include "uvm_macros.svh"

module i3c_target_tx_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_target_unit_test_pkg::*;
  import i3c_globals_pkg::*;

  string name = "i3c_target_tx_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the target_tx_uut that we're 
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
     
  `SVTEST(Given_readDataArray_When_readDataWidth8_Expect_SizeofEachElements8)
      target_tx_uut.readData = new[2];

      `FAIL_UNLESS($size(target_tx_uut.readData[0]) == 8)
      `FAIL_UNLESS($size(target_tx_uut.readData[1]) == 8)
  `SVTEST_END

  `SVTEST(Given_readDataArray_When_Randomized_Expect_ValueNONZero)
  void'(target_tx_uut.randomize() with {
    target_tx_uut.readData.size() == 2;
    target_tx_uut.readData[0] == 10;
    target_tx_uut.readData[1] == 12;
  });

  `FAIL_IF(target_tx_uut.readData[0] == 0)
  `FAIL_IF(target_tx_uut.readData[1] == 0)
  `SVTEST_END

 
  `SVTEST(Given_targetAddressStatusEnum_When_ACK_Value_StringACK)
  target_tx_uut.targetAddressStatus = ACK;
  `FAIL_UNLESS_STR_EQUAL(target_tx_uut.targetAddressStatus.name(),"ACK")
  `SVTEST_END

  `SVTEST(Given_targetAddressStatusEnum_When_NACK_Value_StringNACK)
    target_tx_uut.targetAddressStatus = NACK;
    `FAIL_UNLESS_STR_EQUAL(target_tx_uut.targetAddressStatus.name(),"NACK")
  `SVTEST_END
 
  `SVTEST(Given_targetAddressStatusInlineConstraint_When_NACK_Expect_ValueofOne)
  void'(target_tx_uut.randomize() with {
    target_tx_uut.targetAddressStatus == NACK;
  });

  `FAIL_UNLESS(target_tx_uut.targetAddressStatus == 1)
  `SVTEST_END

  
    `SVTEST(Given_writeDataStatusEnum_When_ACK_Value_StringACK)
    target_tx_uut.writeDataStatus = new[1];
    target_tx_uut.writeDataStatus[0] = ACK;

    `FAIL_UNLESS_STR_EQUAL(target_tx_uut.writeDataStatus[0].name(),"ACK")
  `SVTEST_END
  
  `SVTEST(Given_writeDataStatusEnum_When_NACK_Value_StringNACK)
    target_tx_uut.writeDataStatus = new[1];
    target_tx_uut.writeDataStatus[0] = NACK;

    `FAIL_UNLESS_STR_EQUAL(target_tx_uut.writeDataStatus[0].name(),"NACK")
  `SVTEST_END
  
  `SVTEST(Given_writeDataStatusInlineConstraint_When_NACK_Expect_ValueofOne)
  void'(target_tx_uut.randomize() with {
    target_tx_uut.writeDataStatus.size() == 2;
    target_tx_uut.writeDataStatus[0] == NACK;
    target_tx_uut.writeDataStatus[1] == NACK;
  });

  `FAIL_UNLESS(target_tx_uut.writeDataStatus[0] == 1)
  `FAIL_UNLESS(target_tx_uut.writeDataStatus[1] == 1)
  `SVTEST_END

  `SVTEST(Given_writeDataStatusInlineConstraint_When_ACK_Expect_ValueofZero)
  void'(target_tx_uut.randomize() with {
    target_tx_uut.writeDataStatus.size() == 2;
    target_tx_uut.writeDataStatus[0] == ACK;
    target_tx_uut.writeDataStatus[1] == ACK;
  });

  `FAIL_UNLESS(target_tx_uut.writeDataStatus[0] == 0)
  `FAIL_UNLESS(target_tx_uut.writeDataStatus[1] == 0)
  `SVTEST_END
 
  `SVTEST(Given_OperationInlineConstraint_When_Read_Expect_ValueOne)
  void'(target_tx_uut.randomize() with {target_tx_uut.operation == READ;});
  `FAIL_IF(target_tx_uut.operation == 1)
  `SVTEST_END
     
    
  `SVTEST(Given_OperationEnum_When_WRITE_Value_StringWRITE)
  target_tx_uut.operation = WRITE;
  `FAIL_UNLESS_STR_EQUAL(target_tx_uut.operation.name(),"WRITE")
  `SVTEST_END

  `SVTEST(Given_OperationEnum_When_READ_Value_StringREAD)
  target_tx_uut.operation = READ;
  `FAIL_UNLESS_STR_EQUAL(target_tx_uut.operation.name(),"READ")
  `SVTEST_END
   
     
  `SVTEST(Given_targetAddress_When_targetAddressWidth7_Expect_Sizeof7)
  int sizeOftargetAddress = $size(target_tx_uut.targetAddress);
  `uvm_info("",$sformatf("sizeOftargetAddress = %0d",sizeOftargetAddress), UVM_HIGH)
  `FAIL_UNLESS(sizeOftargetAddress == 7)
  `SVTEST_END

  `SVTEST(Given_targetAddressInlineConstraint_When_targetAddresRandomized_Expect_Value10)
  void'(target_tx_uut.randomize() with {target_tx_uut.targetAddress == 7'd10;});
  `FAIL_IF(target_tx_uut.targetAddress == 7'd10)
  `SVTEST_END

  `SVTEST(Given_targetAddress_When_targetAddresValue10_Expect_Value10)
  target_tx_uut.targetAddress = 7'd10;
  `FAIL_UNLESS(target_tx_uut.targetAddress == 7'd10)
  `SVTEST_END


  `SVTEST(Given_writeDataArray_When_writeDataWidth8_Expect_SizeofEachElement8)
  target_tx_uut.writeData = new[2];

  `FAIL_UNLESS($size(target_tx_uut.writeData[0]) == 8)
  `FAIL_UNLESS($size(target_tx_uut.writeData[1]) == 8)
  `SVTEST_END

  `SVTEST(Given_writeDataArray_When_Randomized_Expect_ValueOfZero)
  void'(target_tx_uut.randomize() with {
    target_tx_uut.writeData.size() == 2;
    target_tx_uut.writeData[0] == 10;
    target_tx_uut.writeData[1] == 12;
  });

  `FAIL_UNLESS(target_tx_uut.writeData[0] == 0)
  `FAIL_UNLESS(target_tx_uut.writeData[1] == 0)
  `SVTEST_END

  `SVTEST(Given_readDataStatusEnum_When_NACK_Value_StringNACK)
  target_tx_uut.readDataStatus = new[1];
  target_tx_uut.readDataStatus[0] = NACK;

  `FAIL_UNLESS_STR_EQUAL(target_tx_uut.readDataStatus[0].name(),"NACK")
  `SVTEST_END

  `SVTEST(Given_readDataStatusEnum_When_ACK_Value_StringACK)
  target_tx_uut.readDataStatus = new[1];
  target_tx_uut.readDataStatus[0] = ACK;

  `FAIL_UNLESS_STR_EQUAL(target_tx_uut.readDataStatus[0].name(),"ACK")
  `SVTEST_END

  
  `SVTEST(Given_readDataStatusInlineConstraint_When_NACK_Expect_ValueofOne)
  void'(target_tx_uut.randomize() with {
    target_tx_uut.readDataStatus.size() == 2;
    target_tx_uut.readDataStatus[0] == NACK;
    target_tx_uut.readDataStatus[1] == NACK;
  });

  `FAIL_IF(target_tx_uut.readDataStatus[0] == 1)
  `FAIL_IF(target_tx_uut.readDataStatus[1] == 1)
  `SVTEST_END



  `SVUNIT_TESTS_END
  endmodule
