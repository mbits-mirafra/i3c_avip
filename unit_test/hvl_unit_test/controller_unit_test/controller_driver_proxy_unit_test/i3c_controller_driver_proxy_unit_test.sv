`include "uvm_macros.svh"
import uvm_pkg::*;
`include "clk_and_reset.svh"

`include "svmock_defines.svh"
`include "svunit_defines.svh"

`include "i3c_globals_pkg.sv"
import i3c_globals_pkg::*;

`include "i3c_controller_tx.sv"
`include "i3c_controller_driver_bfm_mock.sv"
`include "i3c_controller_driver_proxy.sv"

//`include "i3c_controller_pkg.sv"
//import i3c_controller_pkg::*;

//`include "i3c_controller_driver_bfm.sv"

typedef uvm_seq_item_pull_port#(i3c_controller_tx,i3c_controller_tx) item_pull_port_t;

`include "svunit_uvm_mock_pkg.sv"
import svunit_uvm_mock_pkg::*;

`include "svmock_pkg.sv"
import svmock_pkg::*;
`include "uvm-mock/uvm_seq_item_port_mock.sv"


class i3c_controller_driver_proxy_uvm_wrapper extends i3c_controller_driver_proxy;

  `uvm_component_utils(i3c_controller_driver_proxy_uvm_wrapper)

    virtual i3c_controller_driver_bfm dummyBfm;

  function new(string name = "i3c_controller_driver_proxy_uvm_wrapper", uvm_component parent);
    super.new(name, parent);
  endfunction

  //===================================
  // Build
  //===================================
  function void build_phase(uvm_phase phase);

     super.build_phase(phase);
     dummyBfm = i3c_controller_drv_bfm_h;
    /* Place Build Code Here */
  endfunction

  //==================================
  // Connect
  //=================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    /* Place Connection Code Here */
  endfunction

endclass

module i3c_controller_driver_proxy_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "i3c_controller_driver_proxy_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  `CLK_RESET_FIXTURE(5, 11)

  i3c_controller_driver_proxy_uvm_wrapper uut;
  i3c_controller_tx _item, rsp;

  uvm_seq_item_pull_port_mock #(i3c_controller_tx) mock_seq_item_port;

  // GopalS: i3c_controller_driver_bfm_mock bfmMock = new(); 

   i3c_controller_driver_bfm dummyBfm();

   //virtual i3c_controller_driver_bfm bfm;
  // bfm = dummyBfm;

   initial begin
     uvm_config_db#(virtual i3c_controller_driver_bfm)::set(null,"*","i3c_controller_driver_bfm",dummyBfm);
   end
  //i3c_controller_driver_bfm bfmInterface(.pclk(pclk), .areset(areset), .scl_i(scl_i), .scl_o(scl_o), .scl_oen(scl_oen), .sda_i(sda_i), .sda_o(sda_o), .sda_oen(sda_oen));

  // GopalS: virtual i3c_controller_driver_bfm bfm;
  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    uut = i3c_controller_driver_proxy_uvm_wrapper::type_id::create("", null);
    mock_seq_item_port = new("mock_seq_item_port", null);
    uut.seq_item_port = mock_seq_item_port;

    // GopalS: uut.i3c_controller_drv_bfm_h = bfmMock;
  // GopalS: bfm = bfmInterface;

   //uvm_config_db#(virtual i3c_controller_driver_bfm)::set(null,"","i3c_controller_driver_bfm",bfm);
    svunit_deactivate_uvm_component(uut);
  endfunction


   // GopalS: virtual i3c_controller_driver_bfm bfm;
  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

   //  uvm_config_db#(virtual i3c_controller_driver_bfm)::get(null,"","i3c_controller_driver_bfm",bfm);

    `ON_CALL(mock_seq_item_port, get_next_item).will_by_default("_get_next_item");
    `ON_CALL(mock_seq_item_port, item_done).will_by_default("_item_done");
    `ON_CALL(mock_seq_item_port, put_response).will_by_default("_put_response");

    // GopalS: `ON_CALL(bfmMock, wait_for_reset).will_by_default("_wait_for_reset");
    svunit_activate_uvm_component(uut);

    //-----------------------------
    // start the testing phase
    //-----------------------------
    svunit_uvm_test_start();

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    `FAIL_UNLESS(mock_seq_item_port.verify());
    
   // GopalS:  `FAIL_UNLESS(bfmMock.verify());

    //-----------------------------
    // terminate the testing phase 
    //-----------------------------
    svunit_uvm_test_finish();

    /* Place Teardown Code Here */

    svunit_deactivate_uvm_component(uut);
    mock_seq_item_port.flush();
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

  `SVTEST(Expect_i3cControllerBfm_NotNull)
    `FAIL_UNLESS(uut.dummyBfm != null)
  `SVTEST_END

  `SVTEST(Given_When_runPhaseStarted_Expect_waitForResetCalledOnce)
    `FAIL_UNLESS(uut.dummyBfm.waitForResetTaskCounter == 1);
  `SVTEST_END
/*
 `SVTEST(When_runPhasesStarted_Expect_waitForResetCalledOnce)
  // `EXPECT_CALL(bfmMock, wait_for_reset).exactly(1);
   //`EXPECT_CALL(uut, wait_for_reset).exactly(1);
   bfmInterface.wait_for_reset();
   //uut.wait_for_reset();
 `SVTEST_END

 `SVTEST(When_runPhasesStarted_Expect_getNextItemCalledOnce)
   `EXPECT_CALL(mock_seq_item_port, get_next_item).exactly(1);
 `SVTEST_END

 `SVTEST(When_runPhasesCompletes_Expect_itemDoneCalledOnce)
   put_item(_item);
   `EXPECT_CALL(mock_seq_item_port, item_done).exactly(1);
 `SVTEST_END

 `SVTEST(When_itemSentIsNull_Expect_ReqNull)
   put_item(null);
   `FAIL_UNLESS(uut.req == null)
 `SVTEST_END

 `SVTEST(When_itemSentViaPullPort_Expect_ReqSameAsItemSent)
   _item = new();
   put_item(_item);
   step(1);
   `FAIL_UNLESS(uut.req == _item)
 `SVTEST_END

 `SVTEST(When_FouritemSentViaPullPort_Expect_FourReqSameAsItemSent)
    repeat(4) begin
     _item = new();
     put_item(_item);
     step(1);
     `FAIL_UNLESS(uut.req == _item)
    end
 `SVTEST_END
*/

  `SVUNIT_TESTS_END

  function void put_item(i3c_controller_tx t);
    void'(mock_seq_item_port.item_mb.try_put(t));
  endfunction
endmodule
