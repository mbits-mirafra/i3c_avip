onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdl_top/ahb_bus/hclk
add wave -noupdate /hdl_top/ahb_bus/hresetn
add wave -noupdate /hdl_top/ahb_bus/haddr
add wave -noupdate /hdl_top/ahb_bus/hwdata
add wave -noupdate /hdl_top/ahb_bus/htrans
add wave -noupdate /hdl_top/ahb_bus/hburst
add wave -noupdate /hdl_top/ahb_bus/hsize
add wave -noupdate /hdl_top/ahb_bus/hwrite
add wave -noupdate /hdl_top/ahb_bus/hsel
add wave -noupdate /hdl_top/ahb_bus/hready
add wave -noupdate /hdl_top/ahb_bus/hrdata
add wave -noupdate /hdl_top/ahb_bus/hresp
add wave -noupdate -divider {New Divider}
add wave -noupdate /hdl_top/ahb2spi/wb/clk
add wave -noupdate /hdl_top/ahb2spi/wb/rst
add wave -noupdate /hdl_top/ahb2spi/wb/inta
add wave -noupdate /hdl_top/ahb2spi/wb/cyc
add wave -noupdate /hdl_top/ahb2spi/wb/stb
add wave -noupdate /hdl_top/ahb2spi/wb/adr
add wave -noupdate /hdl_top/ahb2spi/wb/we
add wave -noupdate /hdl_top/ahb2spi/wb/din
add wave -noupdate /hdl_top/ahb2spi/wb/dout
add wave -noupdate /hdl_top/ahb2spi/wb/ack
add wave -noupdate /hdl_top/ahb2spi/wb/err
add wave -noupdate /hdl_top/ahb2spi/wb/rty
add wave -noupdate /hdl_top/ahb2spi/wb/sel
add wave -noupdate /hdl_top/ahb2spi/wb/q
add wave -noupdate -divider {New Divider}
add wave -noupdate /hdl_top/spi_bus/sck
add wave -noupdate /hdl_top/spi_bus/mosi
add wave -noupdate /hdl_top/spi_bus/miso
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 272
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
WaveRestoreZoom {0 ns} {875 ns}
