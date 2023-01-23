
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/ALU_in_pkg/ALU_in_pkg_sve.F
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/ALU_out_pkg/ALU_out_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/ALU_env_pkg/ALU_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/ALU_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/ALU_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/ALU_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

