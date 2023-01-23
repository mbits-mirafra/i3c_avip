onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {GPIO Signals}
add wave -noupdate -radix hexadecimal /hdl_top/gpio_mon_bfm/cb/cb_event
add wave -noupdate -radix hexadecimal /hdl_top/gpio_drv_bfm/cb/cb_event
add wave -noupdate -divider {Write Port}
add wave -noupdate -radix hexadecimal /hdl_top/gpio_bus/clk
add wave -noupdate -radix hexadecimal /hdl_top/gpio_drv_bfm/cb/write_port_
add wave -noupdate -radix hexadecimal /hdl_top/gpio_bus/write_port
add wave -noupdate -radix hexadecimal /hdl_top/gpio_mon_bfm/write_port_
add wave -noupdate -radix hexadecimal /hdl_top/gpio_mon_bfm/cb/write_port_
add wave -noupdate -divider {Read Port}
add wave -noupdate -radix hexadecimal /hdl_top/gpio_bus/clk
add wave -noupdate -radix hexadecimal /hdl_top/gpio_bus/read_port
add wave -noupdate -radix hexadecimal /hdl_top/gpio_mon_bfm/read_port_
add wave -noupdate -radix hexadecimal /hdl_top/gpio_mon_bfm/cb/read_port_
add wave -noupdate -radix hexadecimal /hdl_top/gpio_drv_bfm/read_port_
add wave -noupdate -radix hexadecimal /hdl_top/gpio_drv_bfm/cb/read_port_
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {398 ns} 0} {{Cursor 2} {400 ns} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ns} {98 ns}
