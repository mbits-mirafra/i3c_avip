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

  initial begin
       $dumpfile("waveform.vcd");
       $dumpvars();
    end

  `CLK_RESET_FIXTURE(10,4)

 /* bit pclk;
  bit areset;
  
  initial begin
    pclk = 1;
    forever #10 pclk = ~pclk;
  end
  
 initial begin
   areset = 1'b1;

   repeat (2) begin
     @(posedge pclk);
   end
   areset = 1'b0;

   repeat (2) begin
     @(posedge pclk);
   end
   areset = 1'b1;
 end
*/
  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================

  i3c_controller_driver_bfm bfmInterface(.pclk(clk), .areset(rst_n), .scl_i(scl_i), .scl_o(scl_o), .scl_oen(scl_oen), .sda_i(sda_i), .sda_o(sda_o), .sda_oen(sda_oen));

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
  reset();

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

  `SVTEST(Given_generatedClk_When_connectedToBfmAndComparingAtPosedge_Expect_SameClk)
    @(posedge clk)
    `FAIL_UNLESS(clk == bfmInterface.pclk) 
  `SVTEST_END

  `SVTEST(Given_generatedReset_When_connectedToBfmAndComparingAtPosedge_Expect_SameReset)
    @(posedge clk)
    `FAIL_UNLESS(rst_n == bfmInterface.areset) 
  `SVTEST_END


  `SVTEST(When_callingWaitForResetMethod_Expect_waitForResetCalledOnec)
   // `EXPECT_CALL(bfmInterface, wait_for_reset).exactly(1);
   @(posedge clk)
  // rst_n = 0;
    bfmInterface.wait_for_reset();
    $display("[before negedge] rst_n = %0b and arset = %0b]",rst_n,bfmInterface.areset);
    @(negedge rst_n)
    #1 `FAIL_UNLESS(bfmInterface.areset == 0)
    $display("[afetr negedge and before posedge] rst_n = %0b and arset = %0b]",rst_n,bfmInterface.areset);

    @(posedge rst_n)
    #1 `FAIL_UNLESS(bfmInterface.areset == 1)
    $display("[after posedge] rst_n = %0b and arset = %0b]",rst_n,bfmInterface.areset);

  `SVTEST_END
   

  `SVUNIT_TESTS_END

endmodule
