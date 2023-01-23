 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { m_agent }
wave add uvm_test_top.environment.m_agent.m_agent_monitor.txn_stream -radix string -tag F0
wave group m_agent_bus
wave add -group m_agent_bus hdl_top.m_agent_bus.* -radix hexadecimal -tag F0
wave group m_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { s_agent }
wave add uvm_test_top.environment.s_agent.s_agent_monitor.txn_stream -radix string -tag F0
wave group s_agent_bus
wave add -group s_agent_bus hdl_top.s_agent_bus.* -radix hexadecimal -tag F0
wave group s_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

