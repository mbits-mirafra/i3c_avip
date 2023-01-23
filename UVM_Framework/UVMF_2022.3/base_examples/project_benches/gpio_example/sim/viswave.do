 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { gpio_a }
wave add uvm_test_top.environment.gpio_a.gpio_a_monitor.txn_stream -radix string -tag F0
wave group gpio_a_bus
wave add -group gpio_a_bus hdl_top.gpio_a_bus.* -radix hexadecimal -tag F0
wave group gpio_a_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { gpio_b }
wave add uvm_test_top.environment.gpio_b.gpio_b_monitor.txn_stream -radix string -tag F0
wave group gpio_b_bus
wave add -group gpio_b_bus hdl_top.gpio_b_bus.* -radix hexadecimal -tag F0
wave group gpio_b_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

