 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { nand_in_agent }
wave add uvm_test_top.environment.nand_in_agent.nand_in_agent_monitor.txn_stream -radix string -tag F0
wave group nand_in_agent_bus
wave add -group nand_in_agent_bus hdl_top.nand_in_agent_bus.* -radix hexadecimal -tag F0
wave group nand_in_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { nand_out_agent }
wave add uvm_test_top.environment.nand_out_agent.nand_out_agent_monitor.txn_stream -radix string -tag F0
wave group nand_out_agent_bus
wave add -group nand_out_agent_bus hdl_top.nand_out_agent_bus.* -radix hexadecimal -tag F0
wave group nand_out_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

