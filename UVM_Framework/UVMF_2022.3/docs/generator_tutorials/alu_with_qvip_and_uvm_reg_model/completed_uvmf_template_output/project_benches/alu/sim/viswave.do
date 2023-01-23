 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { alu_in_agent }
wave add uvm_test_top.environment.alu_in_agent.alu_in_agent_monitor.txn_stream -radix string -tag F0
wave group alu_in_agent_bus
wave add -group alu_in_agent_bus hdl_top.alu_in_agent_bus.* -radix hexadecimal -tag F0
wave group alu_in_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { alu_out_agent }
wave add uvm_test_top.environment.alu_out_agent.alu_out_agent_monitor.txn_stream -radix string -tag F0
wave group alu_out_agent_bus
wave add -group alu_out_agent_bus hdl_top.alu_out_agent_bus.* -radix hexadecimal -tag F0
wave group alu_out_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

