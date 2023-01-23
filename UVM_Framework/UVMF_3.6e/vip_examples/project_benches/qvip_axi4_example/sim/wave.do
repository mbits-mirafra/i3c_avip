onerror {resume}

radix define axi4_size {
    "0" "AXI4_BYTES_1",
    "1" "AXI4_BYTES_2",
    "2" "AXI4_BYTES_4",
    "3" "AXI4_BYTES_8",
    "4" "AXI4_BYTES_16",
    "5" "AXI4_BYTES_32",
    "6" "AXI4_BYTES_64",
    "7" "AXI4_BYTES_128",
    -default default
}

radix define axi4_burst {
    "0" "AXI4_FIXED",
    "1" "AXI4_INCR",
    "2" "AXI4_WRAP",
    "3" "AXI4_RESERVED",
    -default default
}

radix define axi4_lock {
    "0" "AXI4_NORMAL",
    "1" "AXI4_EXCLUSIVE",
    -default default
}

radix define axi4_response {
    "0" "AXI4_OKAY",
    "1" "AXI4_EXOKAY",
    "2" "AXI4_SLVERR",
    "3" "AXI4_DECERR",
    -default default
}

radix define axi4_prot {
    "0" "AXI4_NORM_SEC_DATA",
    "1" "AXI4_PRIV_SEC_DATA",
    "2" "AXI4_NORM_NONSEC_DATA",
    "3" "AXI4_PRIV_NONSEC_DATA",
    "4" "AXI4_NORM_SEC_INST",
    "5" "AXI4_PRIV_SEC_INST",
    "6" "AXI4_NORM_NONSEC_INST",
    "7" "AXI4_PRIV_NONSEC_INST",
    -default default
}

quietly WaveActivateNextPane {} 0
add wave -noupdate -height 136 /hdl_top/master/axi4_if/rw_transaction
add wave -noupdate -height 136 /hdl_top/master/axi4_if/write
add wave -noupdate /hdl_top/master/axi4_if/read
add wave -noupdate /hdl_top/master/axi4_if/write_channel_phase
add wave -noupdate /hdl_top/master/axi4_if/write_channel_cycle
add wave -noupdate /hdl_top/master/axi4_if/write_addr_channel_phase
add wave -noupdate /hdl_top/master/axi4_if/write_addr_channel_cycle
add wave -noupdate /hdl_top/master/axi4_if/write_resp_channel_phase
add wave -noupdate /hdl_top/master/axi4_if/write_resp_channel_cycle
add wave -noupdate /hdl_top/master/axi4_if/write_data_burst
add wave -noupdate /hdl_top/master/axi4_if/read_addr_channel_phase
add wave -noupdate /hdl_top/master/axi4_if/read_addr_channel_cycle
add wave -noupdate /hdl_top/master/axi4_if/read_channel_phase
add wave -noupdate /hdl_top/master/axi4_if/read_channel_cycle
add wave -noupdate /hdl_top/ACLK
add wave -noupdate /hdl_top/ARESETn
add wave -noupdate /hdl_top/master/axi4_if/AWVALID
add wave -noupdate /hdl_top/master/axi4_if/AWADDR
add wave -noupdate -radix axi4_prot /hdl_top/master/axi4_if/AWPROT
add wave -noupdate /hdl_top/master/axi4_if/AWREGION
add wave -noupdate /hdl_top/master/axi4_if/AWLEN
add wave -noupdate -radix axi4_size /hdl_top/master/axi4_if/AWSIZE
add wave -noupdate -radix axi4_burst /hdl_top/master/axi4_if/AWBURST
add wave -noupdate -radix axi4_lock /hdl_top/master/axi4_if/AWLOCK
add wave -noupdate /hdl_top/master/axi4_if/AWCACHE
add wave -noupdate /hdl_top/master/axi4_if/AWQOS
add wave -noupdate /hdl_top/master/axi4_if/AWID
add wave -noupdate /hdl_top/master/axi4_if/AWREADY
add wave -noupdate /hdl_top/master/axi4_if/WVALID
add wave -noupdate /hdl_top/master/axi4_if/WDATA
add wave -noupdate /hdl_top/master/axi4_if/WSTRB
add wave -noupdate /hdl_top/master/axi4_if/WLAST
add wave -noupdate /hdl_top/master/axi4_if/WREADY
add wave -noupdate /hdl_top/master/axi4_if/BVALID
add wave -noupdate -radix axi4_response /hdl_top/master/axi4_if/BRESP
add wave -noupdate /hdl_top/master/axi4_if/BID
add wave -noupdate /hdl_top/master/axi4_if/BREADY
add wave -noupdate /hdl_top/master/axi4_if/RVALID
add wave -noupdate /hdl_top/master/axi4_if/ARVALID
add wave -noupdate /hdl_top/master/axi4_if/ARADDR
add wave -noupdate -radix axi4_prot /hdl_top/master/axi4_if/ARPROT
add wave -noupdate /hdl_top/master/axi4_if/ARREGION
add wave -noupdate /hdl_top/master/axi4_if/ARLEN
add wave -noupdate -radix axi4_size /hdl_top/master/axi4_if/ARSIZE
add wave -noupdate -radix axi4_burst /hdl_top/master/axi4_if/ARBURST
add wave -noupdate -radix axi4_lock /hdl_top/master/axi4_if/ARLOCK
add wave -noupdate /hdl_top/master/axi4_if/ARCACHE
add wave -noupdate /hdl_top/master/axi4_if/ARQOS
add wave -noupdate /hdl_top/master/axi4_if/ARID
add wave -noupdate /hdl_top/master/axi4_if/ARREADY
add wave -noupdate /hdl_top/master/axi4_if/RDATA
add wave -noupdate -radix axi4_response /hdl_top/master/axi4_if/RRESP
add wave -noupdate /hdl_top/master/axi4_if/RLAST
add wave -noupdate /hdl_top/master/axi4_if/RID
add wave -noupdate /hdl_top/master/axi4_if/RREADY
add wave -noupdate /hdl_top/master/axi4_if/status_num_writes_waiting_for_response
add wave -noupdate /hdl_top/master/axi4_if/total_num_waddr_outstanding
add wave -noupdate /hdl_top/master/axi4_if/total_num_wdata_outstanding
add wave -noupdate /hdl_top/master/axi4_if/status_num_reads_waiting_for_resp
add wave -noupdate /hdl_top/master/axi4_if/reordering_depth_of_last_read_transaction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 497
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
WaveRestoreZoom {0 ns} {10500 ns}
