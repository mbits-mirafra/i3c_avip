onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {AHB Transactions}
add wave -noupdate -radix hexadecimal /uvm_root/uvm_test_top/environment/a_agent/a_agent_monitor/txn_stream
add wave -noupdate -divider {AHB Signals}
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hclk
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hresetn
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/haddr
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hwdata
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/htrans
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hburst
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hsize
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hwrite
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hsel
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hready
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hrdata
add wave -noupdate -radix hexadecimal /hdl_top/ahb_bus/hresp
add wave -noupdate -divider {WB Transactions}
add wave -noupdate -radix hexadecimal /uvm_root/uvm_test_top/environment/b_agent/b_agent_monitor/txn_stream
add wave -noupdate -divider {WB Signals}
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/clk
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/rst
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/inta
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/cyc
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/stb
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/adr
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/we
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/din
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/dout
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/ack
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/err
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/rty
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/sel
add wave -noupdate -radix hexadecimal /hdl_top/wb_bus/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {955 ns} 0}
configure wave -namecolwidth 472
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
WaveRestoreZoom {191 ns} {1727 ns}
