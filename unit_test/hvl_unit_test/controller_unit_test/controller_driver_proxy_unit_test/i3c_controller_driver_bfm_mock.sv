
interface i3c_controller_driver_bfm();
  task wait_for_reset();
    $display("calling dummy wait_for_reset");
  endtask
endinterface
