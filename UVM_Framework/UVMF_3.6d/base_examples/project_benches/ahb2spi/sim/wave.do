onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {AHB Transactions}
add wave -noupdate /uvm_root/uvm_test_top/environment/ahb2wb_env/a_agent/a_agent_monitor/txn_stream
add wave -noupdate -divider {AHB Signals}
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hclk
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hresetn
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/haddr
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hwdata
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/htrans
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hburst
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hsize
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hwrite
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hsel
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hready
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hrdata
add wave -noupdate -group ahb_bus -radix hexadecimal /hdl_top/ahb_bus/hresp
add wave -noupdate -divider {WB Transactions}
add wave -noupdate /uvm_root/uvm_test_top/environment/wb_mon/txn_stream
add wave -noupdate -divider {WB Signals}
add wave -noupdate -group wb_bus /hdl_top/wb/clk
add wave -noupdate -group wb_bus /hdl_top/wb/rst
add wave -noupdate -group wb_bus /hdl_top/wb/inta
add wave -noupdate -group wb_bus /hdl_top/wb/cyc
add wave -noupdate -group wb_bus /hdl_top/wb/stb
add wave -noupdate -group wb_bus /hdl_top/wb/adr
add wave -noupdate -group wb_bus /hdl_top/wb/we
add wave -noupdate -group wb_bus /hdl_top/wb/din
add wave -noupdate -group wb_bus /hdl_top/wb/dout
add wave -noupdate -group wb_bus /hdl_top/wb/ack
add wave -noupdate -group wb_bus /hdl_top/wb/err
add wave -noupdate -group wb_bus /hdl_top/wb/rty
add wave -noupdate -group wb_bus /hdl_top/wb/sel
add wave -noupdate -group wb_bus /hdl_top/wb/q
add wave -noupdate -divider {SPI Transactions}
add wave -noupdate /uvm_root/uvm_test_top/environment/wb2spi_env/spi_agent/spi_agent_monitor/txn_stream
add wave -noupdate -divider {SPI Signals}
add wave -noupdate -group spi_bus /hdl_top/spi_bus/sck
add wave -noupdate -group spi_bus /hdl_top/spi_bus/mosi
add wave -noupdate -group spi_bus /hdl_top/spi_bus/miso
add wave -noupdate -divider {SPI Mem Transactions}
add wave -noupdate /uvm_root/uvm_test_top/environment/wb2spi_env/spi_mem_slave_viewer/txn_stream
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {978 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 553
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1894 ns}
