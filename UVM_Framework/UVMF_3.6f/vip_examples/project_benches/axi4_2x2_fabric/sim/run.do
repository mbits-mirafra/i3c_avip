

set ::env(UVMF_VIP_LIBRARY_HOME) ../../../verification_ip
set ::env(UVMF_PROJECT_DIR) ../../../project_benches/axi4_2x2_fabric

file delete -force *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
file delete -force design.bin qwave.db dpiheader.h visualizer*.ses
file delete -force veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
file delete -force sv_connect.*
vlib work 
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/common/fli_pkg $env(UVMF_HOME)/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/uvmf_base_pkg -F $env(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/uvmf_base_pkg -F $env(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f


vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/environment_packages/axi4_2x2_fabric_env_pkg $env(UVMF_VIP_LIBRARY_HOME)/environment_packages/axi4_2x2_fabric_env_pkg/axi4_2x2_fabric_env_pkg.sv

vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/parameters $env(UVMF_PROJECT_DIR)/tb/parameters/axi4_2x2_fabric_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/sequences $env(UVMF_PROJECT_DIR)/tb/sequences/axi4_2x2_fabric_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/tests $env(UVMF_PROJECT_DIR)/tb/tests/axi4_2x2_fabric_test_pkg.sv
echo "Compile your DUT here"
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/testbench -F $env(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/testbench -F $env(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hdl.f
vopt -32          hvl_top hdl_top   -o optimized_batch_top_tb
vopt -32  +acc    hvl_top hdl_top   -o optimized_debug_top_tb
vsim -i  -32  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -permit_unmatched_virtual_intf +notimingchecks -suppress 8887   -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1  -do " set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase; " optimized_debug_top_tb
