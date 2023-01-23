# Tcl do file for compile of FPU_in interface


vlog -sv -timescale 1ps/1ps -suppress 2223,2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_in_pkg \
  -F $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_in_pkg/FPU_in_filelist_hvl.f

vlog -sv -timescale 1ps/1ps -suppress 2223,2286 +incdir+$env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_in_pkg \
  -F $env(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_in_pkg/FPU_in_filelist_hdl.f
