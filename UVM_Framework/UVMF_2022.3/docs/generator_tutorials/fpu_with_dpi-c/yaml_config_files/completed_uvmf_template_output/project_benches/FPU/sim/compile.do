

quietly set ::env(UVMF_VIP_LIBRARY_HOME) ../../../verification_ip
quietly set ::env(UVMF_PROJECT_DIR) ../../../project_benches/FPU
## Using VRM means that the build is occuring several more directories deeper underneath
## the sim directory, need to prepend some more '..'
if {[info exists ::env(VRM_BUILD)]} {
  quietly set ::env(UVMF_VIP_LIBRARY_HOME) "../../../../../$::env(UVMF_VIP_LIBRARY_HOME)"
  quietly set ::env(UVMF_PROJECT_DIR) "../../../../../$::env(UVMF_PROJECT_DIR)"
}
quietly set ::env(UVMF_VIP_LIBRARY_HOME) [file normalize $::env(UVMF_VIP_LIBRARY_HOME)]
quietly set ::env(UVMF_PROJECT_DIR) [file normalize $::env(UVMF_PROJECT_DIR)]
quietly echo "UVMF_VIP_LIBRARY_HOME = $::env(UVMF_VIP_LIBRARY_HOME)"
quietly echo "UVMF_PROJECT_DIR = $::env(UVMF_PROJECT_DIR)"
file delete -force *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf covhtmlreport VRMDATA
file delete -force design.bin qwave.db dpiheader.h visualizer*.ses
file delete -force veloce.med veloce.wave veloce.map tbxbindings.h edsenv velrunopts.ini
file delete -force sv_connect.*
vlib work 
vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/common/fli_pkg $env(UVMF_HOME)/common/fli_pkg/fli_pkg.sv
vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/uvmf_base_pkg -F $env(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/uvmf_base_pkg -F $env(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f


do $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_in_pkg/compile.do
do $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_out_pkg/compile.do

do $env(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg/compile.do

vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/parameters $env(UVMF_PROJECT_DIR)/tb/parameters/FPU_parameters_pkg.sv
vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/sequences $env(UVMF_PROJECT_DIR)/tb/sequences/FPU_sequences_pkg.sv
vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/tests $env(UVMF_PROJECT_DIR)/tb/tests/FPU_tests_pkg.sv

# Compile DUT in seperate lib
vlib dut_lib
vmap dut_lib work

# Compile the DUT design
vcom -work dut_lib ../../../../../rtl_src/fpupack.vhd
vcom -work dut_lib ../../../../../rtl_src/pre_norm_addsub.vhd
vcom -work dut_lib ../../../../../rtl_src/addsub_28.vhd
vcom -work dut_lib ../../../../../rtl_src/post_norm_addsub.vhd
vcom -work dut_lib ../../../../../rtl_src/pre_norm_mul.vhd
vcom -work dut_lib ../../../../../rtl_src/mul_24.vhd
vcom -work dut_lib ../../../../../rtl_src/serial_mul.vhd
vcom -work dut_lib ../../../../../rtl_src/post_norm_mul.vhd
vcom -work dut_lib ../../../../../rtl_src/pre_norm_div.vhd
vcom -work dut_lib ../../../../../rtl_src/serial_div.vhd
vcom -work dut_lib ../../../../../rtl_src/post_norm_div.vhd
vcom -work dut_lib ../../../../../rtl_src/pre_norm_sqrt.vhd
vcom -work dut_lib ../../../../../rtl_src/sqrt.vhd
vcom -work dut_lib ../../../../../rtl_src/post_norm_sqrt.vhd
vcom -work dut_lib ../../../../../rtl_src/comppack.vhd
vcom -work dut_lib ../../../../../rtl_src/psl_vunit_pkg.vhd
vcom -work dut_lib ../../../../../rtl_src/fpu.vhd

vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286  +incdir+$env(UVMF_PROJECT_DIR)/tb/testbench -F $env(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hvl.f
vlog -sv -timescale 1ps/1ps -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/testbench -F $env(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hdl.f
vopt          hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc    hvl_top hdl_top   -o optimized_debug_top_tb
