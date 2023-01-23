
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/ccs_pkg/ccs_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/scatter_gather_dma_env_pkg/scatter_gather_dma_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/scatter_gather_dma_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/scatter_gather_dma_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/scatter_gather_dma_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

