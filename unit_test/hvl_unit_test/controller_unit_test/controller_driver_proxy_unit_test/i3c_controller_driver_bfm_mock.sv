
interface i3c_controller_driver_bfm();
  int waitForResetTaskCounter;
  int driveIdleStateTaskCounter;
  i3c_controller_driver_proxy i3c_controller_drv_proxy_h;

  task wait_for_reset();
    $display("calling dummy wait_for_reset");
    waitForResetTaskCounter++;
  endtask

  // MSHA: task drive_data(i3c_transfer_bits_s packet, i3c_transfer_cfg_s, packet1);
  // MSHA:   $display("calling dummy wait_for_reset");
  // MSHA: endtask
endinterface
