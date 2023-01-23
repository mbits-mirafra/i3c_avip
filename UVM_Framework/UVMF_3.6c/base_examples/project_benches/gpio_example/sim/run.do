rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/gpio_pkg -F /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/gpio_pkg/gpio_filelist_hvl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/gpio_pkg -F /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/gpio_pkg/gpio_filelist_hdl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/environment_packages/gpio_example_env_pkg /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/environment_packages/gpio_example_env_pkg/gpio_example_env_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/parameters /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/parameters/gpio_example_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/sequences /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/sequences/gpio_example_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/tests /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/tests/gpio_example_test_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/gpio_example/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc  hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887  -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 -permit_unmatched_virtual_intf -do "run 0; do wave.do; run -all" optimized_debug_top_tb  &
