
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/gpio_pkg/gpio_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/gpio_example_env_pkg/gpio_example_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/gpio_example_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/gpio_example_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/gpio_example_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

