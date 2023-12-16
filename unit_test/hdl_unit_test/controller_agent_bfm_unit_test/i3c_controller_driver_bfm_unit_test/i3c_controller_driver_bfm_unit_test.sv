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
  bit sclInput;
  bit sdaInput;
  bit sclOutputEnable;
  bit sclOutput;
  bit sdaOutputEnable;
  bit sdaOutput;

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

  i3c_controller_driver_bfm bfmInterface(.pclk(clk), .areset(activeLowReset), .scl_i(sclInput), .scl_o(sclOutput), .scl_oen(sclOutputEnable), .sda_i(sdaInput), .sda_o(sdaOutput), .sda_oen(sdaOutputEnable));

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

  `SVTEST(Given_waitForResetTask_When_ResetValueOne_Expect_stateResetDeactivated)
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
    #0 `FAIL_IF(bfmInterface.state == RESET_ACTIVATED)
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

  `SVTEST(Given_waitForResetTask_When_resetValueNoRisingedge_Expect_stateResetNotDeactivated)
  activeLowReset = 1;
  #0;
    fork
      begin : Arrange
        bfmInterface.wait_for_reset();
      end
    join_none

    activeLowReset = 0;
    repeat(3) @(posedge clk);
    #0 `FAIL_IF(bfmInterface.state == RESET_DEACTIVATED)
  `SVTEST_END

  `SVTEST(Given_waitForResetTask_When_resetValue0toValue1_Expect_stateResetDeactivated)
  activeLowReset = 1;
  #0;
    fork
      begin : Arrange
        bfmInterface.wait_for_reset();
      end
    join_none

    activeLowReset = 0;
    #2 activeLowReset = 1;
    #0 `FAIL_UNLESS(bfmInterface.state == RESET_DEACTIVATED)
  `SVTEST_END

  `SVTEST(Given_driveIdleStateTask_When_clkValue0To1_Expect_sclOutputEnableZero)
    sclOutputEnable = 1;
    fork
      begin : Arrange
        bfmInterface.drive_idle_state();
      end
    join_none
   
    @(posedge clk);
    #2 `FAIL_UNLESS(bfmInterface.scl_oen == 0)
  `SVTEST_END


  `SVTEST(Given_driveIdleStateTask_When_clkValue0To1_Expect_sclOutputOne)
    sclOutput = 0;
    fork
      begin : Arrange
        bfmInterface.drive_idle_state();
      end
    join_none
   
    @(posedge clk);
    #2 `FAIL_UNLESS(bfmInterface.scl_o == 1)
  `SVTEST_END

  
  `SVTEST(Given_driveIdleStateTask_When_clkValue0To1_Expect_sdaOutputEnableZero)
    sdaOutputEnable = 1;
    fork
      begin : Arrange
        bfmInterface.drive_idle_state();
      end
    join_none
   
    @(posedge clk);
    #2 `FAIL_UNLESS(bfmInterface.sda_oen == 0)
  `SVTEST_END

  `SVTEST(Given_driveIdleStateTask_When_clkValue0To1_Expect_sdaOutputOne)
    sdaOutput = 0;
    fork
      begin : Arrange
        bfmInterface.drive_idle_state();
      end
    join_none
   
    @(posedge clk);
    #2 `FAIL_UNLESS(bfmInterface.sda_o == 1)
  `SVTEST_END


  `SVTEST(Given_driveIdleStateTask_When_SclOutputEnableValue0SclOutputValue1sdaOutputEnableValue0SdaOutputValue1_Expect_stateIsIDLE)
    fork
      begin : Arrange
        bfmInterface.drive_idle_state();
      end
    join_none
   
    repeat(2) @(posedge clk);
    `FAIL_UNLESS(bfmInterface.state == IDLE)
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
