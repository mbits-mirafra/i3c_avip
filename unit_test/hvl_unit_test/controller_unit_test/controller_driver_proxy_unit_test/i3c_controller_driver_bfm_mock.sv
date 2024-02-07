
interface i3c_controller_driver_bfm();
  int waitForResetTaskCounter;
  int driveIdleStateTaskCounter;
  int waitForIdleStateCounter;
  int driveToBfmCounter;

  i3c_controller_driver_proxy i3c_controller_drv_proxy_h;

  task wait_for_reset();
    waitForResetTaskCounter++;
  endtask

  task drive_idle_state();
   driveIdleStateTaskCounter++; 
  endtask

  task wait_for_idle_state();
    waitForIdleStateCounter++;
  endtask

  task drive_data(inout i3c_transfer_bits_s bfm_packet, 
                  input i3c_transfer_cfg_s bfm_packet1);
    driveToBfmCounter++;
  endtask

 // GopalS:    task drive_data(i3c_transfer_bits_s packet, i3c_transfer_cfg_s, packet1);
 // GopalS:      $display("calling dummy wait_for_reset");
 // GopalS:    endtask
endinterface
