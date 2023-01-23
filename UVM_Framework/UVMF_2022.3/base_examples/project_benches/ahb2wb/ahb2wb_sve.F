
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/wb_pkg/wb_pkg_sve.F
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/ahb_pkg/ahb_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/ahb2wb_env_pkg/ahb2wb_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/ahb2wb_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/ahb2wb_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/ahb2wb_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

