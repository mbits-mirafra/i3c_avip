

file delete -force *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf covhtmlreport VRMDATA
file delete -force design.bin qwave.db dpiheader.h visualizer*.ses
file delete -force veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
file delete -force sv_connect.*
vlib work 
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/common/fli_pkg $env(UVMF_HOME)/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/uvmf_base_pkg -F $env(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_HOME)/uvmf_base_pkg -F $env(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f

vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg -F $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg/gpio_filelist_hvl.f 
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg -F $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg/gpio_filelist_hdl.f 

vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/environment_packages/gpio_example_env_pkg $env(UVMF_VIP_LIBRARY_HOME)/environment_packages/gpio_example_env_pkg/gpio_example_env_pkg.sv

vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/parameters $env(UVMF_PROJECT_DIR)/tb/parameters/gpio_example_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/sequences $env(UVMF_PROJECT_DIR)/tb/sequences/gpio_example_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/tests $env(UVMF_PROJECT_DIR)/tb/tests/gpio_example_test_pkg.sv
echo "Compile your DUT here"
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/testbench -F $env(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(UVMF_PROJECT_DIR)/tb/testbench -F $env(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hdl.f
vopt -32          hvl_top hdl_top   -o optimized_batch_top_tb
vopt -32  +acc    hvl_top hdl_top   -o optimized_debug_top_tb
vsim -i  -32  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -permit_unmatched_virtual_intf +notimingchecks -suppress 8887   -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1  -do " set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; set PrefSource(OpenOnBreak) 0; radix hex showbase; " optimized_debug_top_tb
