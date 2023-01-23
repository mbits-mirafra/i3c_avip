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
export UVMF_VIP_LIBRARY_HOME ?= $(UVMF_HOME)/base_examples/verification_ip

# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification_ip and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
export UVMF_PROJECT_DIR ?= $(UVMF_HOME)/base_examples/project_benches/ahb2wb

# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Usage of Veloce, etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_LEGACY_TBX_FLOW ?= 0

# Set project Variables
TEST_PLAN_NAME       = ahb2wb_TestPlan
REPORTING_DO_FILE    = ahb2wb_reports_script

# Include Makefile that includes targets for UVM Framework packages
include $(UVMF_HOME)/scripts/Makefile

# Include Makefiles that includes targets required for this bench
include $(UVMF_HOME)/base_examples/verification_ip/interface_packages/ahb_pkg/Makefile
include $(UVMF_HOME)/base_examples/verification_ip/interface_packages/wb_pkg/Makefile
include $(UVMF_HOME)/base_examples/verification_ip/environment_packages/ahb2wb_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS             += 
VLOG_ARGS             +=
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=

COMMON_VSIM_ARGS      +=
BATCH_VSIM_ARGS       += 
DEBUG_VSIM_ARGS       += 

# Do commands
DEBUG_DO_COMMANDS =     -do " \
                        set NoQuitOnFinish 1; \
	                onbreak {resume}; \
                        run 0; \
			do wave.do; \
			add wave /hdl_top/ahb_bus/assert__ahb_hready_follows_hsel; \
			add wave /hdl_top/ahb_bus/assert__ahb_address_stable_throughout_transfer; \
			add wave /hdl_top/ahb_bus/assert__ahb_wdata_stable_throughout_write;  \
			atv log -asserts -enable /hdl_top/ahb_bus/assert__ahb_hready_follows_hsel; \
			atv log -asserts -enable /hdl_top/ahb_bus/assert__ahb_address_stable_throughout_transfer; \
			atv log -asserts -enable /hdl_top/ahb_bus/assert__ahb_wdata_stable_throughout_write;  \
			set PrefSource(OpenOnBreak) 0; \
			radix hex showbase;  \
			"
#			run -all; \

# Project bench package source
AHB2WB_PARAMETERS_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
$(UVMF_PROJECT_DIR)/tb/parameters/ahb2wb_parameters_pkg.sv

AHB2WB_SEQUENCES_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
$(UVMF_PROJECT_DIR)/tb/sequences/ahb2wb_sequences_pkg.sv

AHB2WB_TEST_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
$(UVMF_PROJECT_DIR)/tb/tests/ahb2wb_test_pkg.sv

AHB2WB_DUT =\
$(UVMF_PROJECT_DIR)/rtl/verilog/ahb2wb.v

.PHONY: all build common wrappers test run clean 

# Project bench package targets
COMP_AHB2WB_PARAMETERS_PKG_TGT_0 = q_comp_ahb2wb_parameters_pkg
COMP_AHB2WB_PARAMETERS_PKG_TGT_1 = v_comp_ahb2wb_parameters_pkg
COMP_AHB2WB_PARAMETERS_PKG_TGT = $(COMP_AHB2WB_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_ahb2wb_parameters_pkg: $(COMP_AHB2WB_PARAMETERS_PKG_TGT)

q_comp_ahb2wb_parameters_pkg:
	        $(HVL_COMP_CMD) $(AHB2WB_PARAMETERS_PKG)

v_comp_ahb2wb_parameters_pkg: q_comp_ahb2wb_parameters_pkg
	        $(HDL_COMP_CMD) $(AHB2WB_PARAMETERS_PKG)

comp_ahb2wb_sequence_pkg:
	        $(HVL_COMP_CMD) $(AHB2WB_SEQUENCES_PKG)

comp_ahb2wb_test_pkg:
	        $(HVL_COMP_CMD) $(AHB2WB_TEST_PKG)

comp_ahb2wb_dut:
	        $(HDL_COMP_CMD) $(AHB2WB_DUT)

build: comp_uvm_pkg comp_fli_pkg comp_uvmf_base_pkg comp_wb_pkg comp_ahb_pkg comp_ahb2wb_env_pkg comp_ahb2wb_parameters_pkg comp_ahb2wb_sequence_pkg comp_ahb2wb_test_pkg comp_ahb2wb_dut comp_test_bench
