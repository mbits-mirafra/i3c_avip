# SystemVerilog-VHDL Assistant Version: 2020.3 Built on 8 Jul 2020 at 11:49:52 
# QuestaSim auto generated Makefile

unexport MGLS_HOME

PROJ_DIR = ./..

QUESTA_ROOT := $(QUESTA_ROOT)

VISUALIZER_BIN_DIR := $(VISUALIZER_BIN_DIR)

QUESTA_BIN_DIR := $(QUESTA_ROOT)

ECHO = echo

QUESTA_INI_FILE = modelsim.ini

QUESTA_POST_VSIM_OPTIONS = -batch -uvmcontrol=certe -do 'run -all ; quit -f'

QUESTA_VCOM_OPTIONS = -reportprogress 300

QUESTA_VIS_LOG_OPTIONS = -l transcript_vis.txt

QUESTA_VLOG_OPTIONS = -incr -suppress 2167,2263 -nologo

QUESTA_VOPT_DEBUG_OPTIONS = -nologo -nowarn 13 -debug

QUESTA_VOPT_OPTIONS = -nologo -nowarn 13 +acc

QUESTA_VSIM_OPT_OPTIONS = -l transcript_opt.txt -i

QUESTA_VSIM_OPTIONS = -l transcript.txt -i -voptargs=+acc -sv_seed random +UVM_VERBOSITY=UVM_HIGH -permit_unmatched_virtual_intf +notimingchecks -suppress 8887 -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 work.hvl_top

QUESTA_VSIM_VIS_OPTIONS = +signal+memory=all+class

RM = rm

SVASSIST_DEBUG = -do 'set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; set PrefSource(OpenOnBreak) 0; radix hex showbase;'

TIME_RES = -t ns

VCOM = $(QUESTA_BIN_DIR)/vcom

VDEL = $(QUESTA_BIN_DIR)/vdel

VISUALIZER = $(VISUALIZER_BIN_DIR)/visualizer

VLIB = $(QUESTA_BIN_DIR)/vlib

VLOG = $(QUESTA_BIN_DIR)/vlog

VMAP = $(QUESTA_BIN_DIR)/vmap

VOPT = $(QUESTA_BIN_DIR)/vopt

VSIM = $(QUESTA_BIN_DIR)/vsim

MY_PROJ_TOP := ./..

SVASSISTANT_HOME := $(SVASSISTANT_HOME)


PATH := $(VISUALIZER_BIN_DIR):$(PATH)

export PATH


dut_lib_addsub_28_vhd : 
	@echo "Compiling unit dut_lib.addsub_28 ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/addsub_28.vhd


dut_lib_comppack_vhd : 
	@echo "Compiling unit dut_lib.comppack ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/comppack.vhd


dut_lib_fpu_vhd : 
	@echo "Compiling unit dut_lib.fpu ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/addsub_28.vhd \
  $(MY_PROJ_TOP)/rtl_src/comppack.vhd \
  $(MY_PROJ_TOP)/rtl_src/mul_24.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_addsub.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_addsub.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/fpu.vhd


dut_lib_fpupack_vhd : 
	@echo "Compiling unit dut_lib.fpupack ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd


dut_lib_mul_24_vhd : 
	@echo "Compiling unit dut_lib.mul_24 ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/mul_24.vhd


dut_lib_post_norm_addsub_vhd : 
	@echo "Compiling unit dut_lib.post_norm_addsub ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_addsub.vhd


dut_lib_post_norm_div_vhd : 
	@echo "Compiling unit dut_lib.post_norm_div ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_div.vhd


dut_lib_post_norm_mul_vhd : 
	@echo "Compiling unit dut_lib.post_norm_mul ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_mul.vhd


dut_lib_post_norm_sqrt_vhd : 
	@echo "Compiling unit dut_lib.post_norm_sqrt ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_sqrt.vhd


dut_lib_pre_norm_addsub_vhd : 
	@echo "Compiling unit dut_lib.pre_norm_addsub ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_addsub.vhd


dut_lib_pre_norm_div_vhd : 
	@echo "Compiling unit dut_lib.pre_norm_div ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_div.vhd


dut_lib_pre_norm_mul_vhd : 
	@echo "Compiling unit dut_lib.pre_norm_mul ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_mul.vhd


dut_lib_pre_norm_sqrt_vhd : 
	@echo "Compiling unit dut_lib.pre_norm_sqrt ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_sqrt.vhd


dut_lib_serial_div_vhd : 
	@echo "Compiling unit dut_lib.serial_div ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_div.vhd


dut_lib_serial_mul_vhd : 
	@echo "Compiling unit dut_lib.serial_mul ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_mul.vhd


dut_lib_sqrt_vhd : 
	@echo "Compiling unit dut_lib.sqrt ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/sqrt.vhd


work_@f@p@u_env_pkg_sv : 
	@echo "Compiling unit work.FPU_env_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg/FPU_env_pkg.sv


work_@f@p@u_in_driver_bfm_sv : 
	@echo "Compiling unit work.FPU_in_driver_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_driver_bfm.sv


work_@f@p@u_in_if_sv : 
	@echo "Compiling unit work.FPU_in_if ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_if.sv


work_@f@p@u_in_monitor_bfm_sv : 
	@echo "Compiling unit work.FPU_in_monitor_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_monitor_bfm.sv


work_@f@p@u_in_pkg_hdl_sv : 
	@echo "Compiling unit work.FPU_in_pkg_hdl ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv


work_@f@p@u_in_pkg_sv : 
	@echo "Compiling unit work.FPU_in_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv


work_@f@p@u_out_driver_bfm_sv : 
	@echo "Compiling unit work.FPU_out_driver_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_driver_bfm.sv


work_@f@p@u_out_if_sv : 
	@echo "Compiling unit work.FPU_out_if ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_if.sv


work_@f@p@u_out_monitor_bfm_sv : 
	@echo "Compiling unit work.FPU_out_monitor_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_monitor_bfm.sv


work_@f@p@u_out_pkg_hdl_sv : 
	@echo "Compiling unit work.FPU_out_pkg_hdl ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv


work_@f@p@u_out_pkg_sv : 
	@echo "Compiling unit work.FPU_out_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv


work_@f@p@u_parameters_pkg_sv : 
	@echo "Compiling unit work.FPU_parameters_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/parameters/FPU_parameters_pkg.sv


work_@f@p@u_sequences_pkg_sv : 
	@echo "Compiling unit work.FPU_sequences_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg/FPU_env_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/parameters/FPU_parameters_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences/FPU_sequences_pkg.sv


work_@f@p@u_tests_pkg_sv : 
	@echo "Compiling unit work.FPU_tests_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg/FPU_env_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/parameters/FPU_parameters_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences/FPU_sequences_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests/FPU_tests_pkg.sv


work_async_reset_bfm_sv : 
	@echo "Compiling unit work.async_reset_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset/reset_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset/async_reset_bfm.sv


work_clock_bfm_sv : 
	@echo "Compiling unit work.clock_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock/clock_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock/clock_bfm.sv


work_clock_pkg_sv : 
	@echo "Compiling unit work.clock_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock/clock_pkg.sv


work_fli_pkg_sv : 
	@echo "Compiling unit work.fli_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv


work_hdl_top_sv : 
	@echo "Compiling unit work.hdl_top ... "
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/addsub_28.vhd \
  $(MY_PROJ_TOP)/rtl_src/comppack.vhd \
  $(MY_PROJ_TOP)/rtl_src/mul_24.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_addsub.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_addsub.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/fpu.vhd
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_driver_bfm.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_if.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_monitor_bfm.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_if.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_monitor_bfm.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/parameters/FPU_parameters_pkg.sv
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg -L dut_lib -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/testbench/hdl_top.sv


work_hvl_top_sv : 
	@echo "Compiling unit work.hvl_top ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg/FPU_env_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/parameters/FPU_parameters_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences/FPU_sequences_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests/FPU_tests_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/testbench/hvl_top.sv


work_memload_pkg_sv : 
	@echo "Compiling unit work.memload_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/memload/memload_pkg.sv


work_print_uvm_reg_acc_pkg_sv : 
	@echo "Compiling unit work.print_uvm_reg_acc_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reg_access_file/print_uvm_reg_acc_pkg.sv


work_qvip_utils_pkg_sv : 
	@echo "Compiling unit work.qvip_utils_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/utility_packages/qvip_utils_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/utility_packages/qvip_utils_pkg/qvip_utils_pkg.sv


work_reset_pkg_sv : 
	@echo "Compiling unit work.reset_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset/reset_pkg.sv


work_svdpi_sv : 
	@echo "Compiling unit work.svdpi ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/sv_connect/hvl/svdpi.sv


work_sync_reset_bfm_sv : 
	@echo "Compiling unit work.sync_reset_bfm ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset/reset_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/reset/sync_reset_bfm.sv


work_uvmf_base_pkg_hdl_sv : 
	@echo "Compiling unit work.uvmf_base_pkg_hdl ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv


work_uvmf_base_pkg_sv : 
	@echo "Compiling unit work.uvmf_base_pkg ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv


work_verilog_dut_v : 
	@echo "Compiling unit work.verilog_dut ... "
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/rtl/verilog/verilog_dut.v


work_vhdl_dut_vhd : 
	@echo "Compiling unit work.vhdl_dut ... "
	$(VCOM) -work work $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/rtl/vhdl/vhdl_dut.vhd


compile_all : 
	$(VCOM) -work dut_lib $(QUESTA_VCOM_OPTIONS) $(MY_PROJ_TOP)/rtl_src/fpupack.vhd \
  $(MY_PROJ_TOP)/rtl_src/addsub_28.vhd \
  $(MY_PROJ_TOP)/rtl_src/comppack.vhd \
  $(MY_PROJ_TOP)/rtl_src/mul_24.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_addsub.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/post_norm_sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_addsub.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/pre_norm_sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_div.vhd \
  $(MY_PROJ_TOP)/rtl_src/serial_mul.vhd \
  $(MY_PROJ_TOP)/rtl_src/sqrt.vhd \
  $(MY_PROJ_TOP)/rtl_src/fpu.vhd
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg \
 +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences \
 +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests \
 +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock \
 -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg_hdl.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg/fli_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg/uvmf_base_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/FPU_in_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg_hdl.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/FPU_out_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg/FPU_env_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_driver_bfm.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_if.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg/src/FPU_in_monitor_bfm.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_if.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg/src/FPU_out_monitor_bfm.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/parameters/FPU_parameters_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences/FPU_sequences_pkg.sv \
 $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests/FPU_tests_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock/clock_pkg.sv \
 $(MY_PROJ_TOP)/../UVMF_3.6h/common/uvm_co_emulation_utilities/uvm_co-emulation_utilities/utils/clock/clock_bfm.sv
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg -L dut_lib -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/testbench/hdl_top.sv
	$(VLOG) -work work $(QUESTA_VLOG_OPTIONS) +incdir+$(PROJ_DIR) +incdir+$(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/common/fli_pkg +incdir+$(MY_PROJ_TOP)/../UVMF_3.6h/uvmf_base_pkg +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_in_pkg +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/interface_packages/FPU_out_pkg +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/verification_ip/environment_packages/FPU_env_pkg +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/sequences +incdir+$(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/tests -L work +define+MODEL_TECH -sv $(MY_PROJ_TOP)/yaml_config_files/uvmf_template_output/project_benches/FPU/tb/testbench/hvl_top.sv


clean_all :  delete_libs
	@echo "Cleaning project. Attempting to delete files from the make directory: *.wlf *.fcdb *.ucdb *.old transcript* wlft* *.vstf *.log *.xml *.bin *.db ..."
	@if [ -f transcript* ]; then $(RM) transcript*; fi;\
 if [ -f wlft* ]; then $(RM) wlft*; fi;\
 if [ -f *.log ]; then $(RM) *.log; fi;\
 if [ -f *.xml ]; then $(RM) *.xml; fi;\
 if [ -f *.wlf ]; then $(RM) *.wlf; fi;\
 if [ -f *.fcdb ]; then $(RM) *.fcdb; fi;\
 if [ -f *.ucdb ]; then $(RM) *.ucdb; fi;\
 if [ -f *.old ]; then $(RM) *.old; fi;\
 if [ -f *.vstf ]; then $(RM) *.vstf; fi;\
 if [ -f *.bin ]; then $(RM) *.bin; fi;\
 if [ -f *.db ]; then $(RM) *.db; fi;


create_ini : 
	@echo "Creating modelsim.ini ..."
	@if [ -f $(QUESTA_INI_FILE) ]; then $(RM) -f $(QUESTA_INI_FILE); fi
	$(VMAP) -c


force_recompile_all :  delete_libs create_libs compile_all
	@echo "Recompiling all units ..."
	@echo "Force Recompile completed."


live_sim_dut_lib_fpu_vhd :  dut_lib_fpu_vhd_opt_debug
	@echo "Simulating optimized unit dut_lib.fpu_opt (live-sim) ... "
	$(VSIM) -qwavedb=+wavefile=fpu.db=$(QUESTA_VSIM_VIS_OPTIONS) dut_lib.fpu_opt $(SVASSIST_DEBUG) -visualizer=fpu.bin $(SVASSISTANT_SIM_OPTIONS)$(QUESTA_VIS_LOG_OPTIONS) $(TIME_RES)


live_sim_work_hdl_top_sv :  work_hdl_top_sv_opt_debug
	@echo "Simulating optimized unit work.hdl_top_opt (live-sim) ... "
	$(VSIM) -qwavedb=+wavefile=hdl_top.db=$(QUESTA_VSIM_VIS_OPTIONS) work.hdl_top_opt $(SVASSIST_DEBUG) -visualizer=hdl_top.bin $(SVASSISTANT_SIM_OPTIONS)$(QUESTA_VIS_LOG_OPTIONS) $(TIME_RES)


live_sim_work_hvl_top_sv :  work_hvl_top_sv_opt_debug
	@echo "Simulating optimized unit work.hvl_top_opt (live-sim) ... "
	$(VSIM) -qwavedb=+wavefile=hvl_top.db=$(QUESTA_VSIM_VIS_OPTIONS) work.hvl_top_opt $(SVASSIST_DEBUG) -visualizer=hvl_top.bin $(SVASSISTANT_SIM_OPTIONS)$(QUESTA_VIS_LOG_OPTIONS) $(TIME_RES)


live_sim :  live_sim_work_hdl_top_sv
	


dut_lib_fpu_vhd_opt :  dut_lib_fpu_vhd
	@echo "Optimizing design dut_lib.fpu ... "
	$(VOPT) -o fpu_opt fpu -work dut_lib $(QUESTA_VOPT_OPTIONS) -L dut_lib 


work_hdl_top_sv_opt :  work_hdl_top_sv
	@echo "Optimizing design work.hdl_top ... "
	$(VOPT) -o hdl_top_opt hdl_top -work work $(QUESTA_VOPT_OPTIONS) -L dut_lib -L work 


work_hvl_top_sv_opt :  work_hvl_top_sv
	@echo "Optimizing design work.hvl_top ... "
	$(VOPT) -o hvl_top_opt hvl_top -work work $(QUESTA_VOPT_OPTIONS) -L work 


optimize_design :  work_hdl_top_sv_opt
	


post_sim_dut_lib_fpu_vhd :  dut_lib_fpu_vhd_opt_debug
	@echo "Simulating optimized unit dut_lib.fpu_opt (post-sim) ... "
	$(VSIM) -qwavedb=+wavefile=fpu.db$(QUESTA_VSIM_VIS_OPTIONS) dut_lib.fpu_opt $(QUESTA_POST_VSIM_OPTIONS) $(SVASSISTANT_SIM_OPTIONS) $(QUESTA_VIS_LOG_OPTIONS) $(TIME_RES)


post_sim_work_hdl_top_sv :  work_hdl_top_sv_opt_debug
	@echo "Simulating optimized unit work.hdl_top_opt (post-sim) ... "
	$(VSIM) -qwavedb=+wavefile=hdl_top.db$(QUESTA_VSIM_VIS_OPTIONS) work.hdl_top_opt $(QUESTA_POST_VSIM_OPTIONS) $(SVASSISTANT_SIM_OPTIONS) $(QUESTA_VIS_LOG_OPTIONS) $(TIME_RES)


post_sim_work_hvl_top_sv :  work_hvl_top_sv_opt_debug
	@echo "Simulating optimized unit work.hvl_top_opt (post-sim) ... "
	$(VSIM) -qwavedb=+wavefile=hvl_top.db$(QUESTA_VSIM_VIS_OPTIONS) work.hvl_top_opt $(QUESTA_POST_VSIM_OPTIONS) $(SVASSISTANT_SIM_OPTIONS) $(QUESTA_VIS_LOG_OPTIONS) $(TIME_RES)


post_sim :  post_sim_work_hdl_top_sv
	


sim_dut_lib_fpu_vhd :  dut_lib_fpu_vhd
	@echo "Simulating unit dut_lib.fpu ... "
	$(VSIM) -L dut_lib $(QUESTA_VSIM_OPTIONS) $(SVASSIST_DEBUG) dut_lib.fpu $(SVASSISTANT_SIM_OPTIONS) $(TIME_RES) 


sim_work_hdl_top_sv :  work_hdl_top_sv
	@echo "Simulating unit work.hdl_top ... "
	$(VSIM) -L dut_lib -L work $(QUESTA_VSIM_OPTIONS) $(SVASSIST_DEBUG) work.hdl_top $(SVASSISTANT_SIM_OPTIONS) $(TIME_RES) 


sim_work_hvl_top_sv :  work_hvl_top_sv
	@echo "Simulating unit work.hvl_top ... "
	$(VSIM) -L work $(QUESTA_VSIM_OPTIONS) $(SVASSIST_DEBUG) work.hvl_top $(SVASSISTANT_SIM_OPTIONS) $(TIME_RES) 


sim :  sim_work_hdl_top_sv
	


sim_opt_dut_lib_fpu_vhd :  dut_lib_fpu_vhd_opt
	@echo "Simulating optimized unit dut_lib.fpu_opt ... "
	$(VSIM) dut_lib.fpu_opt $(SVASSIST_DEBUG) $(QUESTA_VSIM_OPT_OPTIONS) $(SVASSISTANT_SIM_OPTIONS) $(TIME_RES)


sim_opt_work_hdl_top_sv :  work_hdl_top_sv_opt
	@echo "Simulating optimized unit work.hdl_top_opt ... "
	$(VSIM) work.hdl_top_opt $(SVASSIST_DEBUG) $(QUESTA_VSIM_OPT_OPTIONS) $(SVASSISTANT_SIM_OPTIONS) $(TIME_RES)


sim_opt_work_hvl_top_sv :  work_hvl_top_sv_opt
	@echo "Simulating optimized unit work.hvl_top_opt ... "
	$(VSIM) work.hvl_top_opt $(SVASSIST_DEBUG) $(QUESTA_VSIM_OPT_OPTIONS) $(SVASSISTANT_SIM_OPTIONS) $(TIME_RES)


sim_opt :  sim_opt_work_hdl_top_sv
	


visualizer_dut_lib_fpu_vhd : 
	@echo "Debugging simulation of unit dut_lib.fpu_opt ... "
	$(VISUALIZER) -designfile fpu.bin -wavefile fpu.db


visualizer_work_hdl_top_sv : 
	@echo "Debugging simulation of unit work.hdl_top_opt ... "
	$(VISUALIZER) -designfile hdl_top.bin -wavefile hdl_top.db


visualizer_work_hvl_top_sv : 
	@echo "Debugging simulation of unit work.hvl_top_opt ... "
	$(VISUALIZER) -designfile hvl_top.bin -wavefile hvl_top.db


visualizer :  visualizer_work_hdl_top_sv
	


dut_lib_fpu_vhd_opt_debug :  dut_lib_fpu_vhd
	@echo "Optimizing design dut_lib.fpu ... "
	$(VOPT) -o fpu_opt -designfile fpu.bin fpu -work dut_lib $(QUESTA_VOPT_DEBUG_OPTIONS) -L dut_lib


work_hdl_top_sv_opt_debug :  work_hdl_top_sv
	@echo "Optimizing design work.hdl_top ... "
	$(VOPT) -o hdl_top_opt -designfile hdl_top.bin hdl_top -work work $(QUESTA_VOPT_DEBUG_OPTIONS) -L dut_lib -L work


work_hvl_top_sv_opt_debug :  work_hvl_top_sv
	@echo "Optimizing design work.hvl_top ... "
	$(VOPT) -o hvl_top_opt -designfile hvl_top.bin hvl_top -work work $(QUESTA_VOPT_DEBUG_OPTIONS) -L work


vopt_debug :  work_hdl_top_sv_opt_debug
	


delete_libs : 
	@echo "Deleting library dut_lib ..."
	@if [ -d $(MY_PROJ_TOP)/build/dut_build ]; then '$(VDEL)' -all -lib $(MY_PROJ_TOP)/build/dut_build; fi;
	@echo "Deleting library work ..."
	@if [ -d $(PROJ_DIR)/libraries/work ]; then '$(VDEL)' -all -lib $(PROJ_DIR)/libraries/work; fi;


prepare_libs :  create_ini
	@echo "Preparing library mapping location $(MY_PROJ_TOP)/build/dut_build ..."
	@if [[ ! -d $(MY_PROJ_TOP)/build/dut_build ]]; then $(VLIB) $(MY_PROJ_TOP)/build/dut_build; fi
	@echo "Preparing library mapping location $(PROJ_DIR)/libraries/work ..."
	@if [[ ! -d $(PROJ_DIR)/libraries/work ]]; then $(VLIB) $(PROJ_DIR)/libraries/work; fi


create_libs :  prepare_libs
	@echo "Creating library dut_lib ..."
	$(VMAP) dut_lib $(MY_PROJ_TOP)/build/dut_build
	@echo "Creating library work ..."
	$(VMAP) work $(PROJ_DIR)/libraries/work


