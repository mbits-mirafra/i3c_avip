
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// Sub-Environments
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/ahb2wb_env_pkg/ahb2wb_env_pkg_sve.F
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/wb2spi_env_pkg/wb2spi_env_pkg_sve.F

+incdir+.
./ahb2spi_env_pkg.sv
