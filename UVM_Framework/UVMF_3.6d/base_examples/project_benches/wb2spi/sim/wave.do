onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {WB Transactions}
add wave -noupdate /uvm_root/uvm_test_top/environment/wb_agent/wb_agent_monitor/txn_stream
add wave -noupdate -divider {WB Signals}
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/clk
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/rst
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/inta
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/cyc
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/adr
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/we
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/din
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/dout
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/ack
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/err
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/rty
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/sel
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/stb
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/q
add wave -noupdate -divider {WB Monitor}
add wave -noupdate /uvm_root/uvm_test_top/environment/wb_agent/wb_agent_monitor/txn_stream
add wave -noupdate -divider {SPI Transactions}
add wave -noupdate -height 32 /uvm_root/uvm_test_top/environment/spi_agent/spi_agent_monitor/txn_stream
add wave -noupdate -divider {SPI Signals}
add wave -noupdate -radix hexadecimal /hdl_top/spi_bus/sck
add wave -noupdate -radix hexadecimal /hdl_top/spi_bus/mosi
add wave -noupdate -radix hexadecimal /hdl_top/spi_bus/miso
add wave -noupdate -divider {SPI Mem Transactions}
add wave -noupdate /uvm_root/uvm_test_top/environment/spi_mem_slave_viewer/txn_stream
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 562
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
WaveRestoreZoom {0 ns} {2012 ns}
