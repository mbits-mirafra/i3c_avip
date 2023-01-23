 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { ALU_in_agent }
wave add uvm_test_top.environment.ALU_in_agent.ALU_in_agent_monitor.txn_stream -radix string -tag F0
wave group ALU_in_agent_bus
wave add -group ALU_in_agent_bus hdl_top.ALU_in_agent_bus.* -radix hexadecimal -tag F0
wave group ALU_in_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { ALU_out_agent }
wave add uvm_test_top.environment.ALU_out_agent.ALU_out_agent_monitor.txn_stream -radix string -tag F0
wave group ALU_out_agent_bus
wave add -group ALU_out_agent_bus hdl_top.ALU_out_agent_bus.* -radix hexadecimal -tag F0
wave group ALU_out_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

