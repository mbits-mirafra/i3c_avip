@rem Portable Project VersionSVN 4.0.0 Beta2
@rem    -------------------------------
@rem    this file contains the tools paths used by all PP scripts
@set   HDS_ROOT=/fpga_apps/hds_2016.1/bin
@set HDS=%HDS_ROOT%\hdldesigner.exe
@set   MODELSIM_ROOT=/fpga_apps/questasim_10.5c/questasim/linux_x86_64
@set   QUESTA_ROOT=/fpga_apps/questasim_10.5c/questasim/linux_x86_64
@set   QUESTA_MVC_HOME=/fpga_apps/Questa_VIP_10_5b_1_20160905/bin
@set   UVMF_HOME=/fpga_apps/questasim_10.5c/questasim/examples/UVM_Framework/UVMF_3.6d
@set   PRECISION_ROOT=/fpga_apps/precision_synthesis_2016.1/Mgc_home/bin
@set   JAVA_PATH=java
@set   PATH="null";%PATH%
@set   PATH=/opt/csvn/bin;%PATH%
@rem   Call the Xilinx env settings
call /fpga_apps/vivado_2016.1/Vivado/2016.1/settings64.sh
