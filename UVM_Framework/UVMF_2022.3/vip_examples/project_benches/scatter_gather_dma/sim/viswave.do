onerror resume
wave tags  F0
wave update off
wave spacer -backgroundcolor Salmon { dma_done_rsc }
wave add uvm_test_top.environment.dma_done_rsc.dma_done_rsc_monitor.txn_stream -tag F0 -radix string -select
wave group dma_done_rsc_bus -backgroundcolor #004466
wave add -group dma_done_rsc_bus hdl_top.dma_done_rsc_bus.clk -tag F0 -radix hexadecimal
wave add -group dma_done_rsc_bus hdl_top.dma_done_rsc_bus.rst -tag F0 -radix hexadecimal
wave add -group dma_done_rsc_bus hdl_top.dma_done_rsc_bus.rdy -tag F0 -radix hexadecimal
wave add -group dma_done_rsc_bus hdl_top.dma_done_rsc_bus.vld -tag F0 -radix hexadecimal
wave add -group dma_done_rsc_bus hdl_top.dma_done_rsc_bus.dat -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group Transaction -backgroundcolor #006666
wave add -group Transaction hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_m0.mgc_axi4_m0.axi4_if.write -tag F0 -radix string
wave add -group Transaction hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.axi4_if.read -tag F0 -radix string
wave add -group Transaction hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.axi4_if.write -tag F0 -radix string
wave insertion [expr [wave index insertpoint] + 1]
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.ACLK -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.ARESETn -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.ARVALID -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.ARREADY -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.RVALID -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.RREADY -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.AWVALID -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.AWREADY -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.WVALID -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.WREADY -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.BVALID -tag F0 -radix hexadecimal
wave add hdl_top.uvm_test_top_environment_scatter_gather_dma_qvip_subenv_qvip_hdl.generate_active_mgc_axi4_s0.mgc_axi4_s0.BREADY -tag F0 -radix hexadecimal
wave update on
wave top 0
wave zoom range 0 10075155
