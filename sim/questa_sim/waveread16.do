onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdl_top/intf_controller/pclk
add wave -noupdate /hdl_top/intf_controller/areset
add wave -noupdate /hdl_top/intf_controller/SCL
add wave -noupdate /hdl_top/intf_controller/SDA
add wave -noupdate /hdl_top/i3c_controller_agent_bfm_h/i3c_controller_drv_bfm_h/state
add wave -noupdate /hdl_top/intf_controller/scl_i
add wave -noupdate /hdl_top/intf_controller/scl_o
add wave -noupdate /hdl_top/intf_controller/scl_oen
add wave -noupdate /hdl_top/intf_controller/sda_i
add wave -noupdate /hdl_top/intf_controller/sda_o
add wave -noupdate /hdl_top/intf_controller/sda_oen
add wave -noupdate /hdl_top/intf_target/pclk
add wave -noupdate /hdl_top/intf_target/areset
add wave -noupdate /hdl_top/intf_target/SCL
add wave -noupdate /hdl_top/intf_target/SDA
add wave -noupdate /hdl_top/i3c_target_agent_bfm_h/i3c_target_drv_bfm_h/state
add wave -noupdate /hdl_top/intf_target/scl_i
add wave -noupdate /hdl_top/intf_target/scl_o
add wave -noupdate /hdl_top/intf_target/scl_oen
add wave -noupdate /hdl_top/intf_target/sda_i
add wave -noupdate /hdl_top/intf_target/sda_o
add wave -noupdate /hdl_top/intf_target/sda_oen
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {530 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 105
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {1106 ns}
