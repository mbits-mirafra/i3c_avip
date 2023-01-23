 

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider ahb 
add wave -noupdate /uvm_root/uvm_test_top/environment/ahb2wb_env/ahb/ahb_monitor/txn_stream
add wave -noupdate -group ahb_bus /hdl_top/ahb_bus/*
add wave -noupdate -divider wb 
add wave -noupdate /uvm_root/uvm_test_top/environment/wb_mon/txn_stream
add wave -noupdate -group wb_bus /hdl_top/wb_bus/*
add wave -noupdate -divider spi 
add wave -noupdate /uvm_root/uvm_test_top/environment/wb2spi_env/spi/spi_monitor/txn_stream
add wave -noupdate -group spi_bus /hdl_top/spi_bus/*
add wave -noupdate -divider spi_mem_slave_transactions
add wave -noupdate /uvm_root/uvm_test_top/environment/wb2spi_env/spi_mem_slave_viewer/txn_stream

TreeUpdate [SetDefaultTree]
quietly wave cursor active 0
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
WaveRestoreZoom {27 ns} {168 ns}

