# Tcl do file for compile of FPU_out interface


vlog -sv -timescale 1ps/1ps -suppress 2223,2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_out_pkg \
  -F $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_out_pkg/FPU_out_filelist_hvl.f

vlog -sv -timescale 1ps/1ps -suppress 2223,2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_out_pkg \
  -F $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_out_pkg/FPU_out_filelist_hdl.f
