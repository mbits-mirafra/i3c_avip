# Portable Project VersionSVN 4.0.0 Beta2
#    -------------------------------
#    this file contains the tools paths used by all PP scripts
export   HDS_ROOT=/fpga_apps/hds_2016.1/bin
export HDS=$HDS_ROOT/hdldesigner.exe
export   MODELSIM_ROOT=/fpga_apps/questasim_10.5c/questasim/linux_x86_64
export   QUESTA_ROOT=/fpga_apps/questasim_10.5c/questasim/linux_x86_64
export   QUESTA_MVC_HOME=/fpga_apps/Questa_VIP_10_5b_1_20160905
export   UVMF_HOME=/fpga_apps/questasim_10.5c/questasim/examples/UVM_Framework/UVMF_3.6d
export   PRECISION_ROOT=/fpga_apps/precision_synthesis_2016.1/Mgc_home/bin
export   JAVA_PATH=java
export   PATH="null":$PATH
export   PATH=/opt/csvn/bin:$PATH
#   Call the Xilinx env settings
call /fpga_apps/vivado_2016.1/Vivado/2016.1/settings64.sh
