`include "svunit_defines.svh"
//`include "i3c_slave_tx.sv"

module i3c_slave_tx_unit_test;
  import uvm_pkg::*;
  import svunit_pkg::svunit_testcase;
  import i3c_master_unit_test_pkg::*;

  string name = "i3c_slave_tx_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  i3c_slave_tx my_i3c_slave_tx;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    my_i3c_slave_tx = new(/* New arguments if needed */);
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
  // writing test for write transaction/Operation
  //===================================
  `SVTEST(set_WRITE_OP)
  void'(my_i3c_slave_tx.randomize()with { read_write == 0; });
 $display("the value of enum type read_write_type:%d",my_i3c_slave_tx.read_write); 
  `FAIL_UNLESS(my_i3c_slave_tx.read_write == 0)
  `SVTEST_END

  
  //===================================
  // writing test for read transaction/Operation
  //===================================
  `SVTEST(set_READ_OP)
  void'(my_i3c_slave_tx.randomize()with { read_write == 1; });
  $display("the value of enum type read_write_type:%d",my_i3c_slave_tx.read_write); 
  `FAIL_UNLESS(my_i3c_slave_tx.read_write == 1)
  `SVTEST_END

  
  `SVTEST(size_of_slave_address)
  void'(my_i3c_slave_tx.randomize());
  $display("The value of slave_address size of slave_address:%0d",$size(my_i3c_slave_tx.slave_address));
  `FAIL_UNLESS($size(my_i3c_slave_tx.slave_address) == 7)
  `SVTEST_END
 

  `SVTEST(Read_DATA)
  for(int i=1;i<=3;i++)
  begin
    void'(my_i3c_slave_tx.randomize() with {my_i3c_slave_tx.size == i;
    my_i3c_slave_tx.rd_data.size() == my_i3c_slave_tx.size;});
    $display("[i3c_slave_tx_size] size = %0d",my_i3c_slave_tx.size);
    $display("[i3c_slave_tx_rd_data] size of rd_data array = %0d",my_i3c_slave_tx.rd_data.size());
    for(int j=0; j<my_i3c_slave_tx.size;j++) begin
      $display("[i3c_slave_tx_rd_data] size of rd_data[%0d] = %0d",j,$size(my_i3c_slave_tx.rd_data[j]));
      `FAIL_UNLESS($size(my_i3c_slave_tx.rd_data[j]) == 8)
    end
  end
    `SVTEST_END
    `SVUNIT_TESTS_END
  endmodule
