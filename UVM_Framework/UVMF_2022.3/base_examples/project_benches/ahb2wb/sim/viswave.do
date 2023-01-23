 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { wb }
wave add uvm_test_top.environment.wb.wb_monitor.txn_stream -radix string -tag F0
wave group wb_bus
wave add -group wb_bus hdl_top.wb_bus.* -radix hexadecimal -tag F0
wave group wb_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { ahb }
wave add uvm_test_top.environment.ahb.ahb_monitor.txn_stream -radix string -tag F0
wave group ahb_bus
wave add -group ahb_bus hdl_top.ahb_bus.* -radix hexadecimal -tag F0
wave group ahb_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

