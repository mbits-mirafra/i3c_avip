onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider ALU_IN
add wave -noupdate sim:/uvm_root/uvm_test_top/environment/in_agent/in_agent_monitor/txn_stream
add wave -noupdate /hdl_top/alu_in_bus/clk
add wave -noupdate /hdl_top/alu_in_bus/rst
add wave -noupdate /hdl_top/alu_in_bus/valid
add wave -noupdate /hdl_top/alu_in_bus/ready
add wave -noupdate /hdl_top/alu_in_bus/op
add wave -noupdate /hdl_top/alu_in_bus/a
add wave -noupdate /hdl_top/alu_in_bus/b
add wave -noupdate -divider ALU_OUT
add wave -noupdate sim:/uvm_root/uvm_test_top/environment/out_agent/out_agent_monitor/txn_stream
add wave -noupdate /hdl_top/alu_out_bus/clk
add wave -noupdate /hdl_top/alu_out_bus/rst
add wave -noupdate /hdl_top/alu_out_bus/done
add wave -noupdate /hdl_top/alu_out_bus/result
add wave -noupdate -divider ALU
add wave -noupdate /hdl_top/DUT/clk
add wave -noupdate /hdl_top/DUT/rst
add wave -noupdate /hdl_top/DUT/ready
add wave -noupdate /hdl_top/DUT/valid
add wave -noupdate /hdl_top/DUT/op
add wave -noupdate /hdl_top/DUT/a
add wave -noupdate /hdl_top/DUT/b
add wave -noupdate /hdl_top/DUT/done
add wave -noupdate /hdl_top/DUT/result
add wave -noupdate /hdl_top/DUT/ready_o
add wave -noupdate /hdl_top/DUT/done_o
add wave -noupdate /hdl_top/DUT/result_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {146 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 328
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
WaveRestoreZoom {36 ns} {526 ns}
