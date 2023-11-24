`include "svunit_defines.svh"
// MSHA: `include "i3c_master_tx.sv"

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
  
  //===================================
  // writing test for write transaction
  //===================================
  `SVTEST(set_write_tx)
    //void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.read_write == 0;});
    void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.read_write == WRITE;});
    $display("[i3c_master_write_tx] read_write is = %0d",my_i3c_master_tx.read_write);
    `FAIL_UNLESS(my_i3c_master_tx.read_write == 0)
    //`FAIL_UNLESS(my_i3c_master_tx.read_write == WRITE)
  `SVTEST_END

  //===================================
  // writing test for read transaction
  //===================================
  `SVTEST(set_read_tx)
    //void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.read_write == 1;});
    void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.read_write == READ;});
    $display("[i3c_master_read_tx] read_write is = %0d",my_i3c_master_tx.read_write);
    `FAIL_UNLESS(my_i3c_master_tx.read_write == 1)
    //`FAIL_UNLESS(my_i3c_master_tx.read_write == READ)
  `SVTEST_END

  //===================================
  // writing test for slave_address
  //===================================
  `SVTEST(size_of_slave_address)
    void'(my_i3c_master_tx.randomize());
    $display("[i3c_master_tx_slave_address] size of slave_address = %0d",$size(my_i3c_master_tx.slave_address));
    `FAIL_UNLESS($size(my_i3c_master_tx.slave_address) == 7)
  `SVTEST_END
  
  //===================================
  // writing test for wr_data
  //===================================
  `SVTEST(size_of_wr_data)
    for(int i=1;i<=3;i++) begin
      void'(my_i3c_master_tx.randomize() with {my_i3c_master_tx.size == i;
                                               my_i3c_master_tx.wr_data.size() == my_i3c_master_tx.size;});
      $display("[i3c_master_tx_size] size = %0d",my_i3c_master_tx.size);
      $display("[i3c_master_tx_wr_data] size of wr_data array = %0d",my_i3c_master_tx.wr_data.size());
      for(int j=0;j<my_i3c_master_tx.size;j++) begin
        $display("[i3c_master_tx_wr_data] size of wr_data[%0d] = %0d",j,$size(my_i3c_master_tx.wr_data[j]));
        `FAIL_UNLESS($size(my_i3c_master_tx.wr_data[j]) == 8)
      end
    end
  `SVTEST_END
  `SVUNIT_TESTS_END

endmodule
