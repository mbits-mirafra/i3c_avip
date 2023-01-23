onerror resume
wave update off
wave tags  F0
wave spacer -group Transaction -backgroundcolor Salmon {MGC_AXI4_M1 Txns}
wave group Transaction -backgroundcolor #004466
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.rw_transaction -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_data_burst -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read_addr_channel_phase -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read_channel_phase -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_addr_channel_phase -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_channel_phase -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_resp_channel_phase -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read_addr_channel_cycle -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read_addr_channel_ready -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read_channel_cycle -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.read_channel_ready -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_addr_channel_cycle -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_addr_channel_ready -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_channel_cycle -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_channel_ready -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_resp_channel_cycle -tag F0 -radix string
wave add -group Transaction hdl_axi4_2x2_fabric_qvip.mgc_axi4_m1.axi4_if.write_resp_channel_ready -tag F0 -radix string
wave insertion [expr [wave index insertpoint] + 1]
wave update on
WaveSetStreamView
