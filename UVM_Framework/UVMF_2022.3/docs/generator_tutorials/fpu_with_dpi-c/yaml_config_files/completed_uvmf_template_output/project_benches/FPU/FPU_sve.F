
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/FPU_in_pkg/FPU_in_pkg_sve.F
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/FPU_out_pkg/FPU_out_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/FPU_env_pkg/FPU_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/FPU_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/FPU_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/FPU_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

