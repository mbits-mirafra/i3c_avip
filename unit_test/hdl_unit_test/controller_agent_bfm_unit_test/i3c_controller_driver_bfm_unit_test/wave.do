onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/clk
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/activeLowReset
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/pclk
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/areset
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/scl_i
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/scl_o
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/scl_oen
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/sda_i
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/sda_o
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/sda_oen
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/state
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/ack
add wave -noupdate /testrunner/__ts/i3c_controller_driver_bfm_ut/bfmInterface/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {24 ns}
