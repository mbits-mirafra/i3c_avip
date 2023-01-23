 

onerror resume
wave update off

wave spacer -backgroundcolor Salmon { FPU_in_agent }
wave add uvm_pkg::uvm_phase::m_run_phases...uvm_test_top.environment.FPU_in_agent.FPU_in_agent_monitor.txn_stream -radix string
wave group FPU_in_agent_bus
wave add -group FPU_in_agent_bus hdl_top.FPU_in_agent_bus.* -radix hexadecimal
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { FPU_out_agent }
wave add uvm_pkg::uvm_phase::m_run_phases...uvm_test_top.environment.FPU_out_agent.FPU_out_agent_monitor.txn_stream -radix string
wave group FPU_out_agent_bus
wave add -group FPU_out_agent_bus hdl_top.FPU_out_agent_bus.* -radix hexadecimal
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

