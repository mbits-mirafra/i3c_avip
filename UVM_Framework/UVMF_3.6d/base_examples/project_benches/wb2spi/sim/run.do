rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/wb_pkg -F /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/wb_pkg/wb_filelist_hvl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/wb_pkg -F /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/wb_pkg/wb_filelist_hdl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/spi_pkg -F /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/spi_pkg/spi_filelist_hvl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/spi_pkg -F /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/interface_packages/spi_pkg/spi_filelist_hdl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/environment_packages/wb2spi_env_pkg /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/environment_packages/wb2spi_env_pkg/registers/wb2spi_reg_pkg.sv /mnt/hgfs/vmware/UVMF_Q/base_examples/verification_ip/environment_packages/wb2spi_env_pkg/wb2spi_env_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/parameters /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/parameters/wb2spi_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/sequences /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/sequences/wb2spi_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/tests /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/tests/wb2spi_test_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/rtl/verilog/wb2spi.v
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/base_examples/project_benches/wb2spi/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc   hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887  -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1  -do "run 0; do wave.do; set PrefSource(OpenOnBreak) 0; radix hex showbase; run -all" optimized_debug_top_tb  &
