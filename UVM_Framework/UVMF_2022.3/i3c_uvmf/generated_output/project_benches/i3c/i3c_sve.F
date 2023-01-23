
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/i3c_m_pkg/i3c_m_pkg_sve.F
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/i3c_s_pkg/i3c_s_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/env_env_pkg/env_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/i3c_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/i3c_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/i3c_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

