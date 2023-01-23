 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { ahb2wb_wb }
wave add uvm_test_top.environment.ahb2wb.wb.wb_monitor.txn_stream -radix string -tag F0
wave group ahb2wb_wb_bus
wave add -group ahb2wb_wb_bus hdl_top.ahb2wb_wb_bus.* -radix hexadecimal -tag F0
wave group ahb2wb_wb_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { ahb2wb_ahb }
wave add uvm_test_top.environment.ahb2wb.ahb.ahb_monitor.txn_stream -radix string -tag F0
wave group ahb2wb_ahb_bus
wave add -group ahb2wb_ahb_bus hdl_top.ahb2wb_ahb_bus.* -radix hexadecimal -tag F0
wave group ahb2wb_ahb_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { wb2spi_wb }
wave add uvm_test_top.environment.wb2spi.wb.wb_monitor.txn_stream -radix string -tag F0
wave group wb2spi_wb_bus
wave add -group wb2spi_wb_bus hdl_top.wb2spi_wb_bus.* -radix hexadecimal -tag F0
wave group wb2spi_wb_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { wb2spi_spi }
wave add uvm_test_top.environment.wb2spi.spi.spi_monitor.txn_stream -radix string -tag F0
wave group wb2spi_spi_bus
wave add -group wb2spi_spi_bus hdl_top.wb2spi_spi_bus.* -radix hexadecimal -tag F0
wave group wb2spi_spi_bus -collapse
wave insertion [expr [wave index insertpoint] +1]

wave update on
WaveSetStreamView

