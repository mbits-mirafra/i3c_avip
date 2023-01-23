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
export UVMF_PROJECT_DIR ?= ../../../project_benches/qvip_axi4_example

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Set project Variables
TEST_PLAN_NAME       = qvip_axi4_bench_TestPlan
REPORTING_DO_FILE    = qvip_axi4_bench_reports_script

# Include Makefile that includes targets for UVM Framework packages
include ${UVMF_HOME}/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/vip_axi4_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS             += 
VLOG_ARGS             +=
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=
BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=
BATCH_VSIM_ARGS       += -mvchome $(QUESTA_MVC_HOME) -suppress 8259
DEBUG_VSIM_ARGS       += -mvchome $(QUESTA_MVC_HOME) -suppress 8259

# Do commands
DEBUG_DO_COMMANDS =     -do "set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase;   			"
#			run -all;  
# Project bench package source
qvip_axi4_bench_PARAMETERS_PKG = \
+incdir+${UVMF_PROJECT_DIR}/tb/parameters \
${UVMF_PROJECT_DIR}/tb/parameters/qvip_axi4_bench_parameters_pkg.sv

qvip_axi4_bench_SEQUENCES_PKG = \
+incdir+${UVMF_PROJECT_DIR}/tb/sequences \
${UVMF_PROJECT_DIR}/tb/sequences/qvip_axi4_bench_sequences_pkg.sv

qvip_axi4_bench_TEST_PKG = \
+incdir+${UVMF_PROJECT_DIR}/tb/tests \
${UVMF_PROJECT_DIR}/tb/tests/qvip_axi4_bench_test_pkg.sv

.PHONY: all build common wrappers test run clean 

# Project bench package targets
comp_qvip_axi4_bench_parameters_pkg:
	vlog ${VLOG_ARGS} $(qvip_axi4_bench_PARAMETERS_PKG)

comp_qvip_axi4_bench_sequence_pkg:
	vlog ${VLOG_ARGS} $(qvip_axi4_bench_SEQUENCES_PKG)

comp_qvip_axi4_bench_test_pkg:
	vlog ${VLOG_ARGS} $(qvip_axi4_bench_TEST_PKG)

comp_qvip_infrastructure:
	echo "Compiling infrastructure files"
	vlog -sv $(QUESTA_MVC_HOME)/include/questa_mvc_svapi.svh
	vlog  +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv ${VLOG_ARGS} $(QUESTA_MVC_HOME)/questa_mvc_src/sv/mvc_pkg.sv

comp_qvip_axi4_protocol:
	echo "Compiling protocol package"
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi4 ${VLOG_ARGS} $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv

comp_axi4_modules:
	echo "Compiling testbench"
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv  $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi4/modules/axi4_master.sv
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv  $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi4/modules/axi4_slave.sv
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv  $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi4/modules/axi4_monitor.sv

build_mvc: comp_qvip_infrastructure comp_qvip_axi4_protocol comp_axi4_modules

build: comp_uvm_pkg build_mvc comp_uvmf_base_pkg  comp_vip_axi4_env_pkg comp_qvip_axi4_bench_parameters_pkg comp_qvip_axi4_bench_sequence_pkg comp_qvip_axi4_bench_test_pkg comp_test_bench


