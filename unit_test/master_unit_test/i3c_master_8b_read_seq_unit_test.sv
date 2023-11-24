`include "svunit_defines.svh"

module i3c_master_8b_read_seq_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_master_unit_test_pkg::*;
  import i3c_globals_pkg::*;

  string name = "i3c_master_8b_read_seq_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_master_8b_read_seq my_i3c_master_8b_read_seq;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
    
    my_i3c_master_8b_read_seq = new(/* New arguments if needed */);
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

  //===================================
  // writing test for slave_address
  //===================================
  `SVTEST(slave_address_size_value)
    my_i3c_master_8b_read_seq.body();
    //`FAIL_UNLESS(my_i3c_master_8b_read_seq.req.slave_address == 7'b110_1000)
    //`FAIL_UNLESS($size(my_i3c_master_8b_read_seq.req.slave_address) == 7)
    $display("size = %0d",my_i3c_master_8b_read_seq.req.size);

    //my_i3c_master_8b_read_seq.req.slave_address = 7'b111_0011;
    //`FAIL_UNLESS(my_i3c_master_8b_read_seq.req.slave_address == 7'b111_0011)
  `SVTEST_END
  
  //================================================
  // writing test for transaction type write or read
  //================================================
//  `SVTEST(transaction_type)
//    `FAIL_UNLESS(my_i3c_master_8b_read_seq.req.read_write == READ)
//    `FAIL_IF(my_i3c_master_8b_read_seq.req.read_write == WRITE)
//  `SVTEST_END
//  
//  //===================================================
//  // writing test for size (How many bits need to read)
//  //===================================================
//  `SVTEST(size_of_data)
//    //if size is 1 then it will read 8bit data
//    `FAIL_UNLESS(my_i3c_master_8b_read_seq.req.size == 1)
//  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
