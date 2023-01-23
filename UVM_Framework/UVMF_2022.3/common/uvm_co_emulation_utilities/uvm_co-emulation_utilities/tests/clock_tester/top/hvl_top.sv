module hvl_top();
  import uvm_pkg::*;
  import clock_test_pkg::*;

  initial begin
    //TimeFormat to make the time displays pretty and to allow you to double
    // click on the time in the transcript window and then have the wave
    // cursor jump to that time.
    $timeformat(-9, 1, " ns", 5);
    
    run_test("clock_test");
  end

endmodule : hvl_top