# Tcl do file for compile of alu interface

# pragma uvmf custom additional begin
# pragma uvmf custom additional end



quietly set cmd [format "vlog -timescale 1ps/1ps +incdir+%s/environment_packages/alu_env_pkg" $env(UVMF_VIP_LIBRARY_HOME)]
quietly set cmd [format "%s %s/environment_packages/alu_env_pkg/registers/alu_reg_pkg.sv" $cmd $env(UVMF_VIP_LIBRARY_HOME)]
quietly set cmd [format "%s %s/environment_packages/alu_env_pkg/alu_env_pkg.sv" $cmd $env(UVMF_VIP_LIBRARY_HOME)]
eval $cmd


