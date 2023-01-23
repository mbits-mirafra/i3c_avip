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
export UVMF_PROJECT_DIR ?= ../../../project_benches/vip_axi4_example

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Usage of Veloce, VTL etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_VTL             ?= $(USE_VELOCE)
USE_64BIT_PLATFORM  ?= 1

PROTOCOL = axi4

# Set project Variables
TEST_PLAN_NAME       = vip_axi4_bench_TestPlan
REPORTING_DO_FILE    = vip_axi4_bench_reports_script

# Include Makefile that includes targets for UVM Framework packages
include ${UVMF_HOME}/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/vip_axi4_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS             += 
VLOG_ARGS_1           += +define+QVIP_PRE_10_4_BACKWARD_COMPATIBLE +define+USE_CACHE_PKG
VLOG_ARGS             += #-tbxhvllint
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS      += #-mvchome $(VIP_HOME) -suppress 8259 supported as vopt option for later Questa releases, like 10.5+
DEBUG_VOPT_ARGS      += #-mvchome $(VIP_HOME) -suppress 8259 supported as vopt option for later Questa releases, like 10.5+
COMMON_VSIM_ARGS     += -mvchome $(VIP_HOME) -suppress 8259 #-tbxhvllint
BATCH_VSIM_ARGS      +=
DEBUG_VSIM_ARGS      +=
LINK_ARGS            +=

VELOCE_XACTOR_LIBS = $(VELOCE_XACTOR_HOME)/$(PROTOCOL)/lib/$(LIB_PLATFORM)/lib$(PROTOCOL)_IN_XRTL_MTI_full.so #lib$(PROTOCOL)_IN_SystemVerilog_MTI_full.so

# Do commands
DEBUG_DO_COMMANDS =     -do "set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase;   			"
#			run -all;  
# Project bench package source
vip_axi4_bench_PARAMETERS_PKG = \
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
${UVMF_PROJECT_DIR}/tb/parameters/vip_axi4_bench_parameters_pkg.sv

vip_axi4_bench_SEQUENCES_PKG = \
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
${UVMF_PROJECT_DIR}/tb/sequences/vip_axi4_bench_sequences_pkg.sv

vip_axi4_bench_TEST_PKG = \
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
${UVMF_PROJECT_DIR}/tb/tests/vip_axi4_bench_test_pkg.sv

# vip_axi4_bench_DUT = # ${UVMF_PROJECT_DIR}/rtl/verilog/vip_axi4_bench.v

VIP_AXI4_QVIP =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/mgc_$(PROTOCOL)_v1_0_pkg.sv \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_master.sv \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_slave.sv \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_monitor.sv

VIP_AXI4_VVIP_HVL =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/mgc_$(PROTOCOL)_v1_0_pkg.sv

VIP_AXI4_VVIP_HDL =\
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL) \
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_IN_XRTL.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_master_XRTL_module.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_slave_XRTL_module.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)__monitor_XRTL_module.sv
#Hans: below files are idential copies - which is the recommended location?
#+incdir+$(VIP_HOME)/questa_mvc_src/sv \
#+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
#+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules \
#$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_master_XRTL_module.sv \
#$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_slave_XRTL_module.sv \
#$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)__monitor_XRTL_module.sv

VIP_AXI4_TB_HVL =\
+incdir+$(UVMF_HOME)/common/mgc_vip \
+incdir+$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL) \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_master_hvl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_slave_hvl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_monitor_hvl.sv

VIP_AXI4_TB_HDL =\
+incdir+$(UVMF_HOME)/common/mgc_vip \
+incdir+$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL) \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_signal_if.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_master_hdl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_slave_hdl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_monitor_hdl.sv

.PHONY: all build common wrappers test run clean 

# Project bench package targets
COMP_vip_axi4_bench_PARAMETERS_PKG_TGT_0 = q_comp_vip_axi4_bench_parameters_pkg
COMP_vip_axi4_bench_PARAMETERS_PKG_TGT_1 = v_comp_vip_axi4_bench_parameters_pkg
COMP_vip_axi4_bench_PARAMETERS_PKG_TGT   = $(COMP_vip_axi4_bench_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_vip_axi4_bench_parameters_pkg: $(COMP_vip_axi4_bench_PARAMETERS_PKG_TGT)

q_comp_vip_axi4_bench_parameters_pkg:
	$(HVL_COMP_CMD) $(vip_axi4_bench_PARAMETERS_PKG)

v_comp_vip_axi4_bench_parameters_pkg: q_comp_vip_axi4_bench_parameters_pkg
	$(HDL_COMP_CMD) $(vip_axi4_bench_PARAMETERS_PKG)

comp_vip_axi4_bench_sequence_pkg:
	$(HVL_COMP_CMD) $(vip_axi4_bench_SEQUENCES_PKG)

comp_vip_axi4_bench_test_pkg:
	$(HVL_COMP_CMD) $(vip_axi4_bench_TEST_PKG)

# comp_vip_axi4_bench_dut:
#	vlog ${VLOG_ARGS} $(vip_axi4_bench_DUT)

COMP_vip_axi4_TGT_0 = comp_vip_axi4_qvip
COMP_vip_axi4_TGT_1 = comp_vip_axi4_vvip
COMP_vip_axi4_TGT   = $(COMP_vip_axi4_TGT_$(USE_VTL))

comp_vip_axi4: $(COMP_vip_axi4_TGT)
	$(HVL_COMP_CMD) $(VIP_AXI4_TB_HVL)
	$(HDL_COMP_CMD) $(VIP_AXI4_TB_HDL)

comp_vip_axi4_qvip: comp_vip_base_pkg
	$(HVL_COMP_CMD) $(VIP_AXI4_QVIP)

comp_vip_axi4_vvip: comp_vip_base_pkg comp_vtl_base_pkgF
	$(HVL_COMP_CMD) $(VIP_AXI4_VVIP_HVL)
	$(HDL_COMP_CMD) $(VIP_AXI4_VVIP_HDL)

build: comp_vip_axi4 comp_uvm_pkg comp_uvmf_base_pkg comp_vip_axi4_env_pkg comp_vip_axi4_bench_parameters_pkg comp_vip_axi4_bench_sequence_pkg comp_vip_axi4_bench_test_pkg comp_test_bench

