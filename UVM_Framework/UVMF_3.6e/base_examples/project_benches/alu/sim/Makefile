# *********************************************************************************************
# UVMF library directory:
# This variable points to the UVMF release where uvmf_base_pkg directory resides.
# This variable points to release code that is not user modified.
# This variable allows for UVMF release directories to reside independent of project related verification_ip and project_benches directories.
# This code below looks "upward" for directory starting with UVMF_* and returns first match for use with the release examples.
UVMF_HOME ?= $(firstword $(wildcard $(addsuffix /UVMF_*,. .. ../.. ../../.. ../../../.. ../../../../..)))

# Project(s) specific verification_ip library:
# Directory where reusable verification packages for interfaces, environments, utilities, etc. reside.
# This variable allows for verification_ip to reside independent of project bench and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/verification_ip
export UVMF_VIP_LIBRARY_HOME ?= ../../../verification_ip

# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification_ip and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
export UVMF_PROJECT_DIR ?= ../../../project_benches/alu

# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = alu_random_test
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Usage of Veloce, etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_LEGACY_TBX_FLOW ?= 0

# Set project Variables
TEST_PLAN_NAME       = alu_TestPlan
REPORTING_DO_FILE    = alu_reports_script

# Include Makefile that includes targets for UVM Framework packages
include $(UVMF_HOME)/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_out_pkg/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/alu_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS            += 
VLOG_ARGS            +=
VELANALYZE_ARGS      +=
VELANALYZE_HVL_ARGS  +=

BATCH_VOPT_ARGS      +=
DEBUG_VOPT_ARGS      +=

COMMON_VSIM_ARGS     +=
BATCH_VSIM_ARGS      += 
DEBUG_VSIM_ARGS      += 

# Do commands
DEBUG_DO_COMMANDS =     -do " \
                        set NoQuitOnFinish 1; \
	                onbreak {resume}; \
                        run 0; \
			do wave.do; \
			set PrefSource(OpenOnBreak) 0; \
			radix hex showbase;  \
			"
#			run -all; \

# Project bench package source
ALU_PARAMETERS_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
$(UVMF_PROJECT_DIR)/tb/parameters/alu_parameters_pkg.sv

ALU_SEQUENCES_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
$(UVMF_PROJECT_DIR)/tb/sequences/alu_sequences_pkg.sv

ALU_TEST_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
$(UVMF_PROJECT_DIR)/tb/tests/alu_test_pkg.sv

ALU_DUT =\
$(UVMF_PROJECT_DIR)/rtl/verilog/alu.v

.NOTPARALLEL:

# Project bench package targets
COMP_ALU_PARAMETERS_PKG_TGT_0 = q_comp_alu_parameters_pkg
COMP_ALU_PARAMETERS_PKG_TGT_1 = v_comp_alu_parameters_pkg
COMP_ALU_PARAMETERS_PKG_TGT = $(COMP_ALU_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_alu_parameters_pkg: $(COMP_ALU_PARAMETERS_PKG_TGT)

q_comp_alu_parameters_pkg:
	        $(HVL_COMP_CMD) $(ALU_PARAMETERS_PKG)

v_comp_alu_parameters_pkg: q_comp_alu_parameters_pkg
	        $(HDL_COMP_CMD) $(ALU_PARAMETERS_PKG)

comp_alu_sequence_pkg:
	        $(HVL_COMP_CMD) $(ALU_SEQUENCES_PKG)

comp_alu_test_pkg:
	        $(HVL_COMP_CMD) $(ALU_TEST_PKG)

comp_alu_dut:
	        $(HDL_COMP_CMD) $(ALU_DUT)

build: comp_uvm_pkg comp_fli_pkg comp_uvmf_base_pkg comp_alu_in_pkg comp_alu_out_pkg comp_alu_env_pkg comp_alu_parameters_pkg comp_alu_sequence_pkg comp_alu_test_pkg comp_alu_dut comp_test_bench
