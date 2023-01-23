# Tcl do file for compile of ahb2spi interface

# pragma uvmf custom additional begin
# pragma uvmf custom additional end


# Include build for sub-environment ahb2wb
quietly set cmd [format "source %s/environment_packages/ahb2wb_env_pkg/compile.do" $env(UVMF_VIP_LIBRARY_HOME)]
eval $cmd
# Include build for sub-environment wb2spi
quietly set cmd [format "source %s/environment_packages/wb2spi_env_pkg/compile.do" $env(UVMF_VIP_LIBRARY_HOME)]
eval $cmd

quietly set cmd [format "vlog -timescale 1ps/1ps +incdir+%s/environment_packages/ahb2spi_env_pkg" $env(UVMF_VIP_LIBRARY_HOME)]
quietly set cmd [format "%s %s/environment_packages/ahb2spi_env_pkg/registers/ahb2spi_reg_pkg.sv" $cmd $env(UVMF_VIP_LIBRARY_HOME)]
quietly set cmd [format "%s %s/environment_packages/ahb2spi_env_pkg/ahb2spi_env_pkg.sv" $cmd $env(UVMF_VIP_LIBRARY_HOME)]
eval $cmd


