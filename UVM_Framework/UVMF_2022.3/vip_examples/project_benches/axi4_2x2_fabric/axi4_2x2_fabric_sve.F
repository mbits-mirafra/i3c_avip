
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/axi4_2x2_fabric_env_pkg/axi4_2x2_fabric_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/axi4_2x2_fabric_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/axi4_2x2_fabric_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/axi4_2x2_fabric_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

