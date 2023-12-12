`SVMOCK(i3c_controller_driver_bfm_mock, i3c_controller_driver_bfm)
  `SVMOCK_TASK0(wait_for_reset)
  `SVMOCK_TASK0(drive_idle_state)
  `SVMOCK_TASK0(wait_for_idle_state)
  `SVMOCK_TASK(drive_data,,inout,i3c_transfer_bits_s,p_data_packet,input,i3c_transfer_cfg_s,p_cfg_pkt)


  `SVMOCK_MAP_TASK0(wait_for_reset,_wait_for_reset)
  task _wait_for_reset();
    $display("_wait_for_reset called");
  endtask

`SVMOCK_END

