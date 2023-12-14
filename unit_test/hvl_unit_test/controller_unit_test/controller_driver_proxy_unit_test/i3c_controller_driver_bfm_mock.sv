
interface i3c_controller_driver_bfm();

  i3c_controller_driver_proxy i3c_controller_drv_proxy_h;
  task wait_for_reset();
    $display("calling dummy wait_for_reset");
  endtask
endinterface
