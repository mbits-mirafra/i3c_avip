`include "uvm_macros.svh"
import uvm_pkg::*;
`include "clk_and_reset.svh"

`include "svmock_defines.svh"
`include "svunit_defines.svh"

`include "i3c_globals_pkg.sv"
import i3c_globals_pkg::*;

`include "i3c_controller_tx.sv"
`include "i3c_controller_driver_proxy.sv"
`include "i3c_controller_driver_bfm.sv"

module i3c_controller_driver_bfm_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "i3c_controller_driver_bfm_ut";
  svunit_testcase svunit_ut;

//  `CLK_RESET_FIXTURE(10,4)

  bit clk;
  bit activeLowReset;
  bit scl_i;
  bit sda_i;

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  
 initial begin
   activeLowReset = 1'b1;

   repeat (2) begin
     @(posedge clk);
   end
   activeLowReset = 1'b0;

   repeat (2) begin
     @(posedge clk);
   end
   activeLowReset = 1'b1;
 end

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================

  i3c_controller_driver_bfm bfmInterface(.pclk(clk), .areset(activeLowReset), .scl_i(scl_i), .scl_o(scl_o), .scl_oen(scl_oen), .sda_i(sda_i), .sda_o(sda_o), .sda_oen(sda_oen));

  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
 // reset();

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

  `SVTEST(Given_waitForResetTask_When_called_ExpectInitialStateResetDeactivated)
    `FAIL_UNLESS(bfmInterface.state == RESET_DEACTIVATED)
    bfmInterface.wait_for_reset();
  `SVTEST_END

  `SVTEST(Given_waitForReset_When_ResetValueOne_Expect_stateResetDeactivated)
    fork
      begin : Arrange
        bfmInterface.wait_for_reset();
      end
    join_none

    bfmInterface.state = IDLE;
    activeLowReset = 1;
    #0 `FAIL_UNLESS(bfmInterface.state == RESET_DEACTIVATED)
  `SVTEST_END

  `SVTEST(Given_waitForResetTask_When_resetValueNoFallingEdge_Expect_stateResetNotActivated)
    activeLowReset = 0;
    #2;
    fork
      begin : Arrange
       bfmInterface.wait_for_reset();
      end
    join_none

    #2 activeLowReset = 0;
    repeat(3) @(posedge clk);
    `FAIL_IF(bfmInterface.state == RESET_ACTIVATED)
  `SVTEST_END

  `SVTEST(Given_waitForResetTask_When_resetValue1toValue0_Expect_stateResetActivated)
    fork
      begin : Arrange
        bfmInterface.wait_for_reset();
      end
    join_none

    activeLowReset = 1;
    #2 activeLowReset = 0;
    #0 `FAIL_UNLESS(bfmInterface.state == RESET_ACTIVATED)

  `SVTEST_END

  `SVTEST(Given_activeLowReset_When_waitForResetTaskCalled_Expect_TaskToReturnAfterAssertionFollowedbyDeassertion)
    //Arrange in parallel to Act
    fork
      begin : Arrange
        bfmInterface.wait_for_reset();
      end
    join_none

    begin : Act
      //initila value 
     // MSHA:  #2 activeLowReset = 0;
     // MSHA:  @(posedge clk);
     // MSHA:  `FAIL_UNLESS(bfmInterface.state == RESET_ACTIVATED)

     // MSHA:  #2 activeLowReset = 1;
     // MSHA:  `FAIL_UNLESS(bfmInterface.state == RESET_DEACTIVATED)
    
    end
  `SVTEST_END
// MSHA:   `SVTEST(When_callingWaitForResetMethod_Expect_waitForResetCalledOnec)
// MSHA:     bfmInterface.wait_for_reset();
// MSHA:   `SVTEST_END
// MSHA: 
// MSHA:   `SVTEST(Given_generatedClk_When_connectedToBfmAndComparingAtPosedge_Expect_SameClk)
// MSHA:     @(posedge clk)
// MSHA:     `FAIL_UNLESS(clk == bfmInterface.pclk) 
// MSHA:   `SVTEST_END
// MSHA: 
// MSHA:   `SVTEST(Given_generatedReset_When_connectedToBfmAndComparingAtPosedge_Expect_SameReset)
// MSHA:     @(posedge clk)
// MSHA:     `FAIL_UNLESS(activeLowReset == bfmInterface.areset) 
// MSHA:   `SVTEST_END
// MSHA:   
// MSHA:   `SVTEST(When_driveIdleStateCalled_Expect_stateIsEqualToIDLE)
// MSHA:     bfmInterface.drive_idle_state();
// MSHA:     `FAIL_UNLESS(bfmInterface.state == IDLE)
// MSHA:   `SVTEST_END
// MSHA:    
// MSHA:   `SVTEST(Given_SclAndSdaInput_When_bothAreOne_Expect_waitForIdleStateCalled)
// MSHA:     scl_i = 1;
// MSHA:     sda_i = 1;
// MSHA:     @(posedge clk)
// MSHA:     bfmInterface.wait_for_idle_state();
// MSHA:     `FAIL_UNLESS(scl_i == bfmInterface.scl_i) 
// MSHA:     `FAIL_UNLESS(sda_i == bfmInterface.sda_i) 
// MSHA:   `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
