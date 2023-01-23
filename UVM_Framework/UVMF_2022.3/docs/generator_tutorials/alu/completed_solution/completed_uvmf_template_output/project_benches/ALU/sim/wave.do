 

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider ALU_in_agent 
add wave -noupdate /uvm_root/uvm_test_top/environment/ALU_in_agent/ALU_in_agent_monitor/txn_stream
add wave -noupdate -group ALU_in_agent_bus /hdl_top/ALU_in_agent_bus/*
add wave -noupdate -divider ALU_out_agent 
add wave -noupdate /uvm_root/uvm_test_top/environment/ALU_out_agent/ALU_out_agent_monitor/txn_stream
add wave -noupdate -group ALU_out_agent_bus /hdl_top/ALU_out_agent_bus/*

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

