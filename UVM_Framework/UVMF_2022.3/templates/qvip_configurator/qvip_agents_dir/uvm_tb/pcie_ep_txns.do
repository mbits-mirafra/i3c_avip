onerror resume
wave update off
wave tags  F0
wave spacer -group Transaction -backgroundcolor Salmon {PCIE_EP Txns}
wave group Transaction -backgroundcolor #004466
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.pipe_msg_txrx -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.pipe_msg_txrx_0 -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.pipe_msg_txrx_1 -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.transport -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.malformed_tlp -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.request -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.completion -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.tlp -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.tlp_to_dll -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.pmux_packet -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.tl_to_dll -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.retry_tlp -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.dllp_top -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.os_plp -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.tlp_dllp_to_mac -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.tlp_dllp_to_mac_packet -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.symbol -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.scramble_symbol -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.loc_mphy_reg_access -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.rrap_txn -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.com_n_pad_during_rrap -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.mpcie_ts_os -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.mpcie_skp_os -tag F0 -radix string
wave add -group Transaction hdl_qvip_agents.pcie_ep.pcie_ep.mpcie_ei_os -tag F0 -radix string
wave insertion [expr [wave index insertpoint] + 1]
wave update on
WaveSetStreamView
