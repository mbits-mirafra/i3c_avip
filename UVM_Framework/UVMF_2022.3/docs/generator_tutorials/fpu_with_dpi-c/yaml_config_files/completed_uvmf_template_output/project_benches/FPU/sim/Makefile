
#
#----------------------------------------------------------------------
# Project         : FPU Simulation Bench 
# Unit            : Bench makefile
# File            : Makefile
#----------------------------------------------------------------------
#                                          
# DESCRIPTION: This makefile includes the shared makefile and contains
#   bench level make targets.
#


# *********************************************************************************************
# UVMF library directory:
# This variable points to the UVMF release where uvmf_base_pkg directory resides.
# This variable points to release code that is not user modified.
# This variable allows for UVMF release directories to reside independent of project related verification_ip and project_benches directories.
# This code below looks "upward" for directory starting with UVMF_* and returns first match for use with the release examples.
UVMF_HOME ?= ___PLEASE_SET_AN_ENVIRONMENT_VARIABLE_NAMED_UVMF_HOME_TO_POINT_TO_THE_UVMF_INSTALLATION___

#
# Project(s) specific verification_ip library:
# Directory where reusable verification packages for interfaces, environments, utilities, etc. reside.
# This variable allows for verification_ip to reside independent of project bench and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/verification_ip
# export UVMF_VIP_LIBRARY_HOME ?= ../../../verification_ip
export UVMF_VIP_LIBRARY_HOME ?= $(PWD)/../../../verification_ip
#
# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification_ip and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
# export UVMF_PROJECT_DIR ?= ../../../project_benches/FPU
export UVMF_PROJECT_DIR ?= $(PWD)/..
#
#
# *********************************************************************************************

## Check PATH for required vinfo scripts
PVAL := $(shell command -v make_filelist.py 2> /dev/null)
ifndef PVAL
  MFLIST = $(UVMF_HOME)/scripts/make_filelist.py
else
  MFLIST = make_filelist.py
endif

# Set test case specific Variables
TEST_NAME            ?= test_top

TEST_SEED            ?= random
UVM_CLI_ARGS         = 

# Usage of Veloce, etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0

# Usage of vinfo flow for generating file list
USE_VINFO           ?= 0

# Usage of Veloce and Questa profilers
USE_VELOCE_PROFILER ?= 0
USE_QUESTA_PROFILER ?= 0


# Set project Variables
TEST_PLAN_NAME       = FPU_TestPlan
REPORTING_DO_FILE    = FPU_reports_script

# Include makefile that includes targets for UVM_VIP_Library packages
include $(UVMF_HOME)/scripts/Makefile


# Include all requisite interface package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_in_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/FPU_out_pkg/Makefile

# Include all requisite environment package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg/Makefile



# Add to default compile/load/run arguments
VCOM_ARGS             += 

# Note: vsim-3009 error can be eliminated by adding -timescale 1ps/1ps to VLOG_ARGS
VLOG_ARGS             += +define+UVM_REPORT_DISABLE_FILE_LINE
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=
EXTRA_VOPT_TOPS       +=

COMMON_VSIM_ARGS      +=  
COMMON_VSIM_ARGS      +=   # -sv_lib FPUEnvPkg_CFunctions   


BATCH_VSIM_ARGS       += #-uvmcontrol=none
DEBUG_VSIM_ARGS       += 
EXTRA_VSIM_TOPS       += 

# Project bench package source
FPU_PARAMETERS_PKG =\
$(UVMF_PROJECT_DIR)/tb/parameters/FPU_parameters_pkg.sv


FPU_SEQUENCES_PKG =\
$(UVMF_PROJECT_DIR)/tb/sequences/FPU_sequences_pkg.sv

FPU_TEST_PKG =\
$(UVMF_PROJECT_DIR)/tb/tests/FPU_tests_pkg.sv

# UVMF_CHANGE_ME : Reference Verilog DUT source.
FPU_VERILOG_DUT =\
$(UVMF_PROJECT_DIR)/rtl/verilog/verilog_dut.v

# UVMF_CHANGE_ME : Reference VHDL DUT source.
FPU_VHDL_DUT =\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/fpupack.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/pre_norm_addsub.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/addsub_28.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/post_norm_addsub.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/pre_norm_mul.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/mul_24.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/serial_mul.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/post_norm_mul.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/pre_norm_div.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/serial_div.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/post_norm_div.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/pre_norm_sqrt.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/sqrt.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/post_norm_sqrt.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/comppack.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/psl_vunit_pkg.vhd\
$(UVMF_PROJECT_DIR)/../../../../rtl_src/fpu.vhd

# Project bench package targets
COMP_FPU_PARAMETERS_PKG_TGT_0 = q_comp_FPU_parameters_pkg
COMP_FPU_PARAMETERS_PKG_TGT_1 = v_comp_FPU_parameters_pkg
COMP_FPU_PARAMETERS_PKG_TGT = $(COMP_FPU_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_FPU_parameters_pkg: $(COMP_FPU_PARAMETERS_PKG_TGT)

q_comp_FPU_parameters_pkg:
	        $(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/parameters $(FPU_PARAMETERS_PKG)

v_comp_FPU_parameters_pkg: q_comp_FPU_parameters_pkg
	$(HDL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/parameters $(FPU_PARAMETERS_PKG)
 

comp_FPU_sequence_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/sequences $(FPU_SEQUENCES_PKG)

comp_FPU_tests_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/tests $(FPU_TEST_PKG)

# UVMF_CHANGE_ME : Add make target to compile your verilog dut here
comp_FPU_verilog_dut: 
	echo "Compile your verilog DUT here"
	$(HDL_COMP_CMD) $(FPU_VERILOG_DUT)

# UVMF_CHANGE_ME : Add make target to compile your vhdl dut here
comp_FPU_vhdl_dut: 
	echo "Compile your vhdl DUT here"
	vlib dut_lib
	vmap dut_lib work
	$(HDL_COMP_CMD_VHDL) $(FPU_VHDL_DUT)

# UVMF_CHANGE_ME : Add make target to compile your dut here
comp_FPU_dut: comp_FPU_verilog_dut comp_FPU_vhdl_dut


BUILD_TGT_0 = make_build
BUILD_TGT_1 = vinfo_build
BUILD_TGT = $(BUILD_TGT_$(USE_VINFO))


comp_hvl : comp_hvl_core


comp_hvl_core :   \
	 comp_FPU_in_pkg  comp_FPU_out_pkg  \
	comp_FPU_env_pkg \
	comp_FPU_parameters_pkg comp_FPU_sequence_pkg comp_FPU_tests_pkg 

comp_uvmf_core : comp_uvm_pkg comp_fli_pkg comp_uvmf_base_pkg 

make_build: comp_FPU_dut comp_uvmf_core comp_hvl comp_test_bench  

vinfo_build: comp_FPU_vhdl_dut  comp_FPU_env_pkg_c_files  build_hdl_vinfo build_hvl_vinfo $(VINFO_TGT)

	$(HDL_COMP_CMD) -F hdl.vf
	$(VEL_COMP)

build: $(BUILD_TGT)



