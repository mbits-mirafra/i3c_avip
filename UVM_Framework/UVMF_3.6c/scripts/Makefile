# 
## Common Makefile - this is included in each of the project bench Makefiles in order to
## get access to common parameters and targets

# Tarball version
TAR_VERSION ?= 3.5b

# Visualizer enable switch
USE_VIS ?= 0
# Visualizer class debug switch
USE_VIS_UVM ?= 0

# Usage of Veloce, VTL etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_VTL             ?= 0
USE_LEGACY_TBX_FLOW ?= 0
USE_QUESTA_PROFILER ?= 0
USE_VELOCE_PROFILER ?= 0

USE_VELOCE_OR_VTL_0 = $(USE_VTL)
USE_VELOCE_OR_VTL_1 = 1
USE_VELOCE_OR_VTL   = $(USE_VELOCE_OR_VTL_$(USE_VELOCE))

USE_VELOCE_AND_VTL_0 = 0
USE_VELOCE_AND_VTL_1 = $(USE_VTL)
USE_VELOCE_AND_VTL   = $(USE_VELOCE_AND_VTL_$(USE_VELOCE))

# -F vs -f, since former is not currently supported for Veloce
DASH_F_OPTION_0 = -F
DASH_F_OPTION_1 = -f
DASH_F_OPTION   = $(DASH_F_OPTION_$(USE_VELOCE))

# # Add to default compile/load/run arguments
#GCC_ARG_0 = -cppinstall 4.3.3
GCC_ARG_0 =
GCC_ARG_1 = -cppinstall 4.5.0 # Required to run with Questa 10.4; With Questa 10.3b the default 4.3.3 yields a vopt error/bug
GCC_ARG   = $(GCC_ARG_$(USE_VELOCE_OR_VTL))
#GCC_ARG = -cppinstall 4.5.0

BATCH_VOPT_ARGS   += $(GCC_ARG)
DEBUG_VOPT_ARGS   += $(GCC_ARG)
COMMON_VSIM_ARGS  += $(GCC_ARG)
LINK_ARGS         += $(GCC_ARG)

# QVIP vs VTL flow
QVIP_HOME  = $(QUESTA_MVC_HOME)
VVIP_HOME  = $(VELOCE_XACTOR_HOME)/$(shell ls $(VELOCE_XACTOR_HOME) | grep 'QUESTA_x.*UVM')
VIP_HOME_0 = $(QVIP_HOME)
VIP_HOME_1 = $(VVIP_HOME)
VIP_HOME   = $(VIP_HOME_$(USE_VTL))

# Veloce SW used to identify tbx or os3
VEL_SW_0 = OS3
VEL_SW_1 = TBX
VEL_SW   = $(VEL_SW_$(USE_LEGACY_TBX_FLOW))

# Simulator vs emulator compile commands
SIM_COMP_CMD = vlog $(VLOG_ARGS)
EMU_COMP_CMD = $(VELANALYZE_CMD)

# Veloce analyze command as determined by OS3 vs legacy TBX usage
VELANALYZE_CMD_0   = velanalyze
VELANALYZE_CMD_1   = veanalyze
VELANALYZE_CMD     = $(VELANALYZE_CMD_$(USE_LEGACY_TBX_FLOW)) $(VELANALYZE_ARGS)
VELANALYZE_HVL_CMD = $(VELANALYZE_CMD) -extract_hvl_info $(VELANALYZE_HVL_ARGS)

# Compile command as determined by simulator vs emulator usage
# - HDL files are subject to either simulator or emulator compile (but not both), 
#   dependent on puresim vs Veloce mode respectively
# - HVL files are subject to simulator compile irrespective of mode, 
#   and may be additionally to special -extract_hvl_info analysis in Veloce mode
# - Shared files are subject to simulator compile irrespective of mode, 
#   and additionally to emulator compile in Veloce mode
HVL_COMP_CMD   = $(SIM_COMP_CMD)
HDL_COMP_CMD_0 = $(SIM_COMP_CMD)
HDL_COMP_CMD_1 = $(EMU_COMP_CMD)
HDL_COMP_CMD   = $(HDL_COMP_CMD_$(USE_VELOCE))

# Veloce compile command as determined by OS3 vs legacy TBX usage
VELCOMP_CMD_0 = velcomp
VELCOMP_CMD_1 = tbxcomp
VELCOMP_CMD   = $(VELCOMP_CMD_$(USE_LEGACY_TBX_FLOW)) -top $(TOP_HDL)

# Link command as determined by puresim vs Veloce and OS3 vs legacy TBX usage
LINK_CMD_0_0 = velhvl -sim puresim
LINK_CMD_0_1 = tbxsvlink -puresim
LINK_CMD_1_0 = velhvl -sim veloce
LINK_CMD_1_1 = tbxsvlink -veloce
LINK_CMD     = $(LINK_CMD_$(USE_VELOCE)_$(USE_LEGACY_TBX_FLOW)) $(LINK_ARGS)

# Library platform as implied by 32 vs 64 bit MTI_VCO_MODE
# Default assumption is 32-bit (if MTI_VCO_MODE isn't set)
LIB_PLATFORM_32BIT = linux_el30_gnu450
LIB_PLATFORM_64BIT = linux_el30_gnu450_x86_64
LIB_PLATFORM = $(LIB_PLATFORM_32BIT)
ifeq ($(MTI_VCO_MODE), 64)
  LIB_PLATFORM = $(LIB_PLATFORM_64BIT)
endif

# Default compile arguments
VCOM_ARGS = 

VLOG_ARGS_0 = -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps
VLOG_ARGS_1 = $(VLOG_ARGS_0) \
              +define+XRTL +define+XMVC
VLOG_ARGS   = $(VLOG_ARGS_$(USE_VELOCE_OR_VTL)) $(VISTA_VLOG_ARGS)

VELANALYZE_ARGS     = -sv -suppress 2223 -suppress 2286 \
                      +define+XRTL +define+XMVC
VELANALYZE_HVL_ARGS = $(VELANALYZE_ARGS) +incdir+$(QUESTA_HOME)/verilog_src/uvm-1.1d/src

LINK_ARGS_32BIT = 
LINK_ARGS_64BIT = -64bit_runtime
LINK_ARGS += -g $(LINK_ARGS_$(MTI_VCO_MODE)BIT)
LINK_ARGS += -ldflags "-Wl,--whole-archive $(VELOCE_XACTOR_LIBS) -Wl,--no-whole-archive"
LINK_ARGS_0 =
LINK_ARGS_1 = -enable_profile_report
LINK_ARGS += $(LINK_ARGS_$(USE_VELOCE_PROFILER))

# one for debug (full visibility).  If Visualizer is enabled then use
# -debug switch (QFD flow) for batch mode
BATCH_VOPT_ARGS_0_0 = +cover=sbcef+/hdl_top/DUT
BATCH_VOPT_ARGS_0_1 = -debug,viseffort=full +designfile
BATCH_VOPT_ARGS_1_0 = -debug +designfile
BATCH_VOPT_ARGS_1_1 = -debug +designfile
BATCH_VOPT_ARGS += $(BATCH_VOPT_ARGS_$(USE_VIS)_$(USE_VIS_UVM))

DEBUG_VOPT_ARGS += +acc 

# Common simulate arguments such as random seed, UVM testname, etc
COMMON_VSIM_ARGS_0 = 
COMMON_VSIM_ARGS_1 = -autoprofile
COMMON_VSIM_ARGS   += -sv_seed $(TEST_SEED) +UVM_TESTNAME=$(TEST_NAME) \
                      +UVM_VERBOSITY=$(TEST_VERBOSITY) $(UVM_CLI_ARGS) \
                      -t 1ns -coverage \
                      +notimingchecks -suppress 8887 \
                      $(COMMON_VSIM_ARGS_$(USE_QUESTA_PROFILER))

# Batch simulation arguments minimizes debug capabilities
VIS_VSIM_ARGS_0 = -qwavedb=+signal+report+memory=65536
VIS_VSIM_ARGS_1 = $(VIS_VSIM_ARGS_0) \
                  +class+transactions+uvm_schematic -classdebug \
                  +uvm_set_config_int=*,enable_transaction_viewing,1
VIS_VSIM_ARGS += $(VIS_VSIM_ARGS_$(USE_VIS_UVM))

BATCH_VSIM_ARGS_0 = $(COMMON_VSIM_ARGS) -uvmcontrol=msglog,trlog
BATCH_VSIM_ARGS_1 = $(COMMON_VSIM_ARGS) -uvmcontrol=all $(VIS_VSIM_ARGS)
BATCH_VSIM_ARGS += $(BATCH_VSIM_ARGS_$(USE_VIS))

# Debug simulation arguments turns on class debug, assertion debug, UVM debug, and custom transaction recording and
# use Visualizer interactive if USE_VIS is enabled
INTERACTIVE_MODE_0 = -i
INTERACTIVE_MODE_1 = -visualizer
INTERACTIVE_MODE = $(INTERACTIVE_MODE_$(USE_VIS))
DEBUG_VSIM_ARGS += $(COMMON_VSIM_ARGS) $(INTERACTIVE_MODE) -uvmcontrol=all -msgmode both -classdebug -assertdebug \
                   +uvm_set_config_int=*,enable_transaction_viewing,1
WAVE_FILE_0 = ; do wave.do
WAVE_FILE_1 =
WAVE_FILE = $(WAVE_FILE_$(USE_VIS))

# Dofile commands - debug only does a run 0, adds everything to waves
DEBUG_DO_COMMANDS = -do " \
                    set NoQuitOnFinish 1; \
                    onbreak {resume}; \
                    run 0 $(WAVE_FILE)" 

# Batch dofile commands - run each test to completion
BATCH_DO_COMMANDS = -do " \
                    set IterationLimit 140000; \
                    set NoQuitOnFinish 1; \
                    onbreak {resume}; \
                    run -all; \
                    quit -f;" 

# Standard test bench modules; these are split into two top-levels for the purposes of emulation
TOP_HVL = hvl_top
TOP_HDL = hdl_top 

TOP_TB_0 = $(TOP_HVL) $(TOP_HDL) 
TOP_TB_1 = $(TOP_HVL) $(TOP_HDL) TbxSvManager
TOP_TB   = $(TOP_TB_$(USE_VELOCE_OR_VTL)) $(VISTA_FABRICSERVER_TOP)

TEST_BENCH = \
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(UVMF_PROJECT_DIR)/tb/testbench \
-F $(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hvl.f

TEST_BENCH_HDL = \
+incdir+$(UVMF_PROJECT_DIR)/tb/testbench \
$(DASH_F_OPTION) $(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hdl.f

# UVM package source (not built-in so still needed for Veloce flow)
UVM_PKG = \
+define+QUESTA \
+incdir+$(QUESTA_HOME)/verilog_src/uvm-1.1d/src \
$(QUESTA_HOME)/verilog_src/uvm-1.1d/src/uvm_pkg.sv

QUESTA_UVM_PKG  = \
+incdir+$(QUESTA_HOME)/verilog_src/questa_uvm_pkg-1.2/src \
$(QUESTA_HOME)/verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv

# VIP common source
VIP_BASE_PKG =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
$(VIP_HOME)/include/questa_mvc_svapi.svh \
$(VIP_HOME)/questa_mvc_src/sv/mvc_pkg.sv

VTL_BASE_PKG_HVL =\
+incdir+$(VELOCE_XACTOR_HOME)/common/sysvlog \
$(VELOCE_XACTOR_HOME)/common/sysvlog/TBXSemaphores.sv \
-F $(TBX_HOME)/questa/hdl/xtlm_files.f

VTL_BASE_PKG_HDL =\
+incdir+$(VELOCE_XACTOR_HOME)/common/hdl \
$(VELOCE_XACTOR_HOME)/common/hdl/*.sv \
+incdir+$(VMW_HOME)/tbx/res_arbitrator_sim/hdl \
$(VMW_HOME)/tbx/res_arbitrator_sim/hdl/ResArbitratorIntf.sv

# Common targets
help:
	@echo "make debug : Invoke a build and run default test in the GUI"
	@echo "make cli: Invoke build and run default test in command-line mode"
	@echo "  can specify TEST_NAME=<testname> to run a different test"
	@echo "make clean: Delete work library, generated files, log files, etc."

clean:
	@-rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
	@-rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
	@-rm -rfv sv_connect.*

libs:
	test -e work || vlib work 

# Visualizer target
vis:
	visualizer +designfile +wavefile

# Tarball generation
tarball:
	scrub_library
	cd ../../..; tar zcvf uvm_framework_$(TAR_VERSION).tgz \
	--exclude .git \
	--exclude .gitignore \
	--exclude git.README \
	--exclude .visualizer \
	--exclude crazy_queue \
	--exclude templates \
	framework

# Top Test Bench Modules
comp_test_bench:
	$(HVL_COMP_CMD) $(TEST_BENCH)
	$(HDL_COMP_CMD) $(TEST_BENCH_HDL)
	$(VEL_COMP)

VEL_COMP_0 =
VEL_COMP_1 = $(VELCOMP_CMD)
VEL_COMP  = $(VEL_COMP_$(USE_VELOCE))

# FLI package
include $(UVMF_HOME)/common/fli_pkg/Makefile


# UVM Base class targets
COMP_UVM_PKG_TGT_0 = q_comp_uvm_pkg
COMP_UVM_PKG_TGT_1 = v_comp_uvm_pkg
COMP_UVM_PKG_TGT = $(COMP_UVM_PKG_TGT_$(USE_VELOCE))

comp_uvm_pkg: $(COMP_UVM_PKG_TGT)

q_comp_uvm_pkg:

v_comp_uvm_pkg: q_comp_uvm_pkg
	$(VELANALYZE_HVL_CMD) $(UVM_PKG)
	$(VELANALYZE_HVL_CMD) $(QUESTA_UVM_PKG)

# UVMF Base class targets
include $(UVMF_HOME)/uvmf_base_pkg/Makefile

# Utility packages
include $(UVMF_HOME)/common/utility_packages/qvip_utils_pkg/Makefile

# VIP common targets
comp_vip_base_pkg:
	$(HVL_COMP_CMD) $(VIP_BASE_PKG)

comp_vtl_base_pkg:
	$(HVL_COMP_CMD) $(VTL_BASE_PKG_HVL)
	$(HDL_COMP_CMD) $(VTL_BASE_PKG_HDL)

# Link target (Veloce)
link:
	$(LINK)

LINK_0 =
LINK_1 = $(LINK_CMD)
LINK = $(LINK_$(USE_VELOCE_OR_VTL))

# Optimize target - run vopt twice.. one for batch mode (high performance, low visibility) and
#   one for debug mode (full visibility).  Doing it twice here allows the gui_run and cli_run
#   targets to be run at the user's convenience later on without reoptimizing.  Also utilized
#   by VRM's rerun capabilities
optimize:
	        vopt $(BATCH_VOPT_ARGS) $(TOP_TB) -o optimized_batch_top_tb
	        vopt $(DEBUG_VOPT_ARGS) $(TOP_TB) -o optimized_debug_top_tb

# Invoke debug simulation
vista_gui_run: 
	$(USE_VISTA_GUI_CMD) $(SLEEP_VISTA_QUESTA_GUI)
	$(VISTA_VIQ_RENV) $(VISTA_VSIM_CMD) -i $(DEBUG_VSIM_ARGS) $(DEBUG_DO_COMMANDS) optimized_debug_top_tb $(VISTA_VIQ_RUN_ARGS) &

gui_run: 
	$(USE_VISTA_CLI_CMD) $(SLEEP_VISTA_QUESTA_GUI)
	$(VISTA_VIQ_RENV) vsim $(DEBUG_VSIM_ARGS) $(DEBUG_DO_COMMANDS) optimized_debug_top_tb $(VISTA_VIQ_RUN_ARGS) &

# Invoke a batch mode simulation
cli_run: 
	$(USE_VISTA_CLI_CMD) $(SLEEP_VISTA)
	$(VISTA_VIQ_RENV) vsim -c $(BATCH_VSIM_ARGS) $(BATCH_DO_COMMANDS) optimized_batch_top_tb $(VISTA_VIQ_RUN_ARGS)

cli: libs build link optimize cli_run
debug: clean libs build link optimize gui_run

# Test plan targets
import_test_plan:
	xml2ucdb -format Excel $(TEST_PLAN_NAME).xml testplan.ucdb

merge_all_ucdb:
	vcover merge regression.merged.ucdb *.ucdb

rank_all_ucdb:
	vcover ranktest -log regression.ranked.txt *.ucdb

create_html_report:
	vcover report -html -htmldir coverage_html_report -threshL 50 -threshH 90 regression.merged.ucdb

create_verbose_html_report:
	vcover report -html -htmldir coverage_verbose_html_report -verbose -threshL 50 -threshH 90 regression.merged.ucdb

generate_assignment_reports:
	vsim -viewcov regression.merged.ucdb -c -do $(REPORTING_DO_FILE).do

finalize_regression: import_test_plan merge_all_ucdb generate_assignment_reports create_html_report 

