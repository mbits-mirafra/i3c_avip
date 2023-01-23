# 
## Common Makefile - this is included in each of the project bench Makefiles in order to
## get access to common parameters and targets
.PHONY: all help clean libs vis link optimize cli_run debug_run cli debug build common wrappers comp_fli_pkg

# Generic debug switch for underlying commands
DEBUG ?= 0

# DASH_F_OPTION value for 3.6f generator output compatability with 3.6g core code
DASH_F_OPTION = -F

# Visualizer class debug switch
USE_VIS_UVM ?= 0
# Visualizer enable switch (forced on if USE_VIS_UVM==1)
ifeq ($(USE_VIS_UVM),1)
  USE_VIS = 1
else
  USE_VIS ?= 0
endif

# VRM Variables, used in the 'vrun' target
RMDB_PATH ?= $(UVMF_HOME)/scripts/default.rmdb
VRUN_ARGS ?= 
ifeq ($(VRUN_BCR),1)
  VRM_TESTLIST ?= bcr_testlist
  VRM_BCR_PARAM ?= -GUSE_BCR=1
else
	VRM_TESTLIST ?= testlist
	VRM_BCR_PARAM ?= 
endif
ifeq ($(VRUN_YAML_TESTLIST),1)
	VRM_TESTLIST := $(VRM_TESTLIST).yaml
endif
EXTRA_VRUN_ARGS ?= 
VRUN_RUNNABLE ?= 
VRUN_DISABLE_TIMEOUTS ?= 0
ifeq ($(VRUN_DISABLE_TIMEOUTS),1)
	VRUN_TIMEOUT ?= 0:0
else
	VRUN_TIMEOUT ?= 
endif
ifeq ($(VRUN_TIMEOUT),)
	VRUN_TIMEOUT_CMD =
else
	VRUN_TIMEOUT_CMD = -mintimeout $(VRUN_TIMEOUT)
endif
ifeq ($(DEBUG),1) 
	EXTRA_VRUN_ARGS += -GDEBUG=1 -debug
endif

# Control if we wish to use the multi-user coverage mode 
MULTIUSER ?= 0 #1

# Control whether or not to run at all in debug simulation
NO_RUN ?= 0

# Usage of Veloce, VTL etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_VTL             ?= 0
USE_QUESTA_PROFILER ?= 0
USE_VELOCE_PROFILER ?= 0

USE_VELOCE_OR_VTL_0 = $(USE_VTL)
USE_VELOCE_OR_VTL_1 = 1
USE_VELOCE_OR_VTL   = $(USE_VELOCE_OR_VTL_$(USE_VELOCE))

USE_VELOCE_AND_VTL_0 = 0
USE_VELOCE_AND_VTL_1 = $(USE_VTL)
USE_VELOCE_AND_VTL   = $(USE_VELOCE_AND_VTL_$(USE_VELOCE))

EN_BETA         ?= 0

BETA_VOPT_0 =
BETA_VOPT_1 = +keeplrmcompliantvhdlbracket
BETA_VOPT   = $(BETA_VOPT_$(EN_BETA))

BETA_VELHVL_0 =
BETA_VELHVL_1 = -vlog_opts "+define+VISUALIZER_DBG"
BETA_VELHVL   = $(BETA_VELHVL_$(EN_BETA))

# # Add to default compile/load/run arguments
GCC_ARG_0 =
GCC_ARG_1 = 
GCC_ARG   = $(GCC_ARG_$(USE_VELOCE_OR_VTL))

# Enable/disable transaction logging
ENABLE_TRLOG ?= 1

BATCH_VOPT_ARGS   += $(GCC_ARG) $(BETA_VOPT)
DEBUG_VOPT_ARGS   += $(GCC_ARG) $(BETA_VOPT)
COMMON_VSIM_ARGS  += $(GCC_ARG)
LINK_ARGS         += $(GCC_ARG) $(BETA_VELHVL)

# QVIP vs VTL flow
QVIP_HOME  = $(QUESTA_MVC_HOME)
VVIP_HOME  = $(VELOCE_XACTOR_HOME)/$(shell ls $(VELOCE_XACTOR_HOME) | grep 'QUESTA_x.*UVM')
VIP_HOME_0 = $(QVIP_HOME)
VIP_HOME_1 = $(VVIP_HOME)
VIP_HOME   = $(VIP_HOME_$(USE_VTL))

# Veloce SW used to identify tbx or os3
VEL_SW   = OS3

# Simulator vs emulator compile commands for verilog
SIM_COMP_CMD = $(PRE_VLOG_SETENV) vlog $(VLOG_ARGS) $(EXTRA_VLOG_ARGS)
EMU_COMP_CMD = $(VELANALYZE_CMD)

# Veloce analyze command as determined by OS3
VELANALYZE_CMD     = velanalyze $(VELANALYZE_ARGS) $(EXTRA_VELANALYZE_ARGS)
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


# Veloce analyze command as determined by OS3
VELANALYZE_ARGS_VHDL = -hdl vhdl 
VELANALYZE_CMD_VHDL  = velanalyze $(VELANALYZE_ARGS_VHDL) $(EXTRA_VELANALYZE_ARGS_VHDL)

# Simulator vs emulator compile commands for verilog
SIM_COMP_CMD_VHDL = $(PRE_VCOM_SETENV) vcom $(VCOM_ARGS) $(EXTRA_VCOM_ARGS)
EMU_COMP_CMD_VHDL = $(VELANALYZE_CMD_VHDL)

HDL_COMP_CMD_VHDL_0 = $(SIM_COMP_CMD_VHDL)
HDL_COMP_CMD_VHDL_1 = $(EMU_COMP_CMD_VHDL)
HDL_COMP_CMD_VHDL   = $(HDL_COMP_CMD_VHDL_$(USE_VELOCE))

# Veloce compile command as determined by OS3
VELCOMP_CMD   = velcomp -top $(TOP_HDL) $(VELCOMP_ARGS) $(EXTRA_VELCOMP_ARGS)

# Link command as determined by puresim vs Veloce and OS3
EXTRA_VELHVL_ARGS ?= 
LINK_CMD_0 = velhvl -sim puresim
LINK_CMD_1 = velhvl -sim veloce
LINK_CMD     = $(LINK_CMD_$(USE_VELOCE)) $(EXTRA_VELHVL_ARGS) $(LINK_ARGS)

# Library platform as implied by 32 vs 64 bit MTI_VCO_MODE
# Default assumption is 32-bit (if MTI_VCO_MODE isn't set)
# VTL release  4.8.0.0 requires the following LIB_PLATOFORM values for puresim mode.
# LIB_PLATFORM_32BIT = linux_el30_gnu450
# LIB_PLATFORM_64BIT = linux_el30_gnu450_x86_64
# VTL release 4.9.0.0 requires the following LIB_PLATOFORM values for puresim mode.
LIB_PLATFORM_32BIT = linux_el30_gnu53
LIB_PLATFORM_64BIT = linux64_el30_gnu53
LIB_PLATFORM = $(LIB_PLATFORM_32BIT)
ifeq ($(MTI_VCO_MODE), 64)
  LIB_PLATFORM = $(LIB_PLATFORM_64BIT)
endif

ifeq ($(MULTIUSER),1)
	MULTIUSER_ARG = -covermultiuserenv
endif

# Default compile arguments
VCOM_ARGS = $(MULTIUSER_ARG)

VLOG_ARGS_0 = -sv -suppress 2223 -suppress 2286 $(MULTIUSER_ARG)
VLOG_ARGS_1 = $(VLOG_ARGS_0) \
              +define+XRTL +define+XMVC +define+USE_VTL
VLOG_ARGS   = $(VLOG_ARGS_$(USE_VELOCE_OR_VTL)) 

VELANALYZE_ARGS     = -sv -suppress 2223 -suppress 2286 \
                      +define+XRTL +define+XMVC +define+USE_VTL
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

VIS_DEBUG_VOPT_ARGS ?= -debug
QIS_VOPT_ARGS ?= 
BATCH_VOPT_ARGS_0 = 
BATCH_VOPT_ARGS_1 = $(QIS_VOPT_ARGS) $(VIS_DEBUG_VOPT_ARGS) -designfile design.bin
BATCH_VOPT_ARGS += $(BATCH_VOPT_ARGS_$(USE_VIS))

DEBUG_VOPT_ARGS += +acc 

# Common simulate arguments such as random seed, UVM testname, etc
COMMON_VSIM_ARGS_0 = 
COMMON_VSIM_ARGS_1 = -autoprofile
COMMON_VSIM_ARGS   += -sv_seed $(TEST_SEED) +UVM_TESTNAME=$(TEST_NAME) \
                      $(UVM_CLI_ARGS) \
                      -permit_unmatched_virtual_intf \
                      +notimingchecks -suppress 8887 \
                      -solvefaildebug -solvefailtestcase \
                      $(COMMON_VSIM_ARGS_$(USE_QUESTA_PROFILER))

# Default Visualizer dumping for RTL and Testbench
VISWAVE_TRLOG_0 =
VISWAVE_TRLOG_1 = +transaction
VISWAVE_TRLOG = $(VISWAVE_TRLOG_$(ENABLE_TRLOG))
VIS_MEM_SIZE ?= 1024
VIS_DUMP_RTL ?= +signal+report+memory=$(VIS_MEM_SIZE)$(VISWAVE_TRLOG)
VIS_DUMP_TB_0 = 
VIS_DUMP_TB_1 = +class+uvm_schematic+msg+assertion
VIS_DUMP_TB  ?= $(VIS_DUMP_TB_$(USE_VIS_UVM))
VIS_DUMP_OPTIONS ?= $(VIS_DUMP_RTL)$(VIS_DUMP_TB)

EN_TRLOG_CFG_0 =
EN_TRLOG_CFG_1 = +uvm_set_config_int=*,enable_transaction_viewing,1
EN_TRLOG_CFG = $(EN_TRLOG_CFG_$(ENABLE_TRLOG))

# Batch simulation arguments minimizes debug capabilities
VIS_VSIM_ARGS = -qwavedb=$(VIS_DUMP_OPTIONS)

BATCH_UVMCTRL_0 = -uvmcontrol=none
BATCH_UVMCTRL_1 = -uvmcontrol=disable
BATCH_UVMCTRL = $(BATCH_UVMCTRL_$(NO_QUESTA_DEBUG_PKG))

BATCH_VSIM_ARGS_0 = $(COMMON_VSIM_ARGS) $(BATCH_UVMCTRL)
BATCH_VSIM_ARGS_1 = $(COMMON_VSIM_ARGS) $(BATCH_UVMCTRL) $(VIS_VSIM_ARGS) $(EN_TRLOG_CFG)
BATCH_VSIM_ARGS = $(BATCH_VSIM_ARGS_$(USE_VIS)) 
BATCH_VSIM_ARGS += -printsimstats

## No transaction viewing, classic debugger
DBG_VSIM_TRLOG_0_0 = -uvmcontrol=all,-trlog
## Transaction viewing, classic debugger
DBG_VSIM_TRLOG_0_1 = -uvmcontrol=all +uvm_set_config_int=*,enable_transaction_viewing,1
## No transaction viewing, Visualizer debugger
DBG_VSIM_TRLOG_1_0 = 
## Transaction viewing, Visualizer debugger
DBG_VSIM_TRLOG_1_1 = +uvm_set_config_int=*,enable_transaction_viewing,1

DBG_VSIM_TRLOG = $(DBG_VSIM_TRLOG_$(USE_VIS)_$(ENABLE_TRLOG))

DBG_VSIM_VIS_0 = -classdebug -title $(TEST_NAME) -msgmode tran 
DBG_VSIM_VIS_1 = $(VIS_VSIM_ARGS)
DBG_VSIM_VIS = $(DBG_VSIM_VIS_$(USE_VIS))

# Debug simulation arguments turns on class debug, assertion debug, UVM debug, and custom transaction recording 
DEBUG_VSIM_ARGS += $(COMMON_VSIM_ARGS) -assertdebug $(DBG_VSIM_TRLOG) $(DBG_VSIM_VIS) 

# Pick the wavefile name depending on debug environment. Format is slightly
# different between Questa Classic and Visualizer
WAVE_FILE_0 = wave.do
WAVE_FILE_1 = viswave.do
WAVE_FILE ?= $(WAVE_FILE_$(USE_VIS))

## Test to see if the wavefile exists
ifneq ("$(wildcard $(WAVE_FILE))","")
  WAVE_FILE_EXISTS = 1
else
  WAVE_FILE_EXISTS = 0
endif
WAVE_FILE_CMD_0 = 
WAVE_FILE_CMD_1 = do $(WAVE_FILE)
WAVE_FILE_CMD = $(WAVE_FILE_CMD_$(WAVE_FILE_EXISTS))

# VWAVES_CMD, XWAVE_CMD, VSIM_VIS, VSIM_VIS_DO for use with Visualizer only when USE_VELOCE=1
# Controlled by USE_AUTOUP and USE_XWAVE
USE_AUTOUP      ?= 0
USE_XWAVE       ?= 0
# Add Veloce lint switches when USE_VELOCE=1 & USE_VELOCE_LINT=1
USE_VELOCE_LINT ?= 0

VELLINT_VLOG_ARG_0  =
VELLINT_VLOG_ARG_1  = -tbxhvllint+ignorepkgs=uvm_pkg
VELLINT_VLOG_ARG    = $(VELLINT_VLOG_ARG_$(USE_VELOCE_LINT))
VLOG_ARGS          += $(VELLINT_VLOG_ARG)

VELLINT_VOPT_ARG_0  =
VELLINT_VOPT_ARG_1  = -reporthrefs+hdl_top 
VELLINT_VOPT_ARG    = $(VELLINT_VOPT_ARG_$(USE_VELOCE_LINT))

VELLINT_VSIM_ARG_0  =
VELLINT_VSIM_ARG_1  = -tbxhvllint
VELLINT_VSIM_ARG    = $(VELLINT_VSIM_ARG_$(USE_VELOCE_LINT))
BATCH_VSIM_ARGS    += $(VELLINT_VSIM_ARG)

VWAVES_CMD_1_1 = velocecmd \"hwtrace autoupload on -tracedir waves -gen crd -crd_options \\\"-o waves.crd -siglist xwaves.sigs\\\" \";
VWAVES_CMD   = $(VWAVES_CMD_$(USE_VELOCE)_$(USE_AUTOUP))

XWAVE_CMD_1_1 = +velrun+xwave_on +velrun+xwave_select_all_groups "+velrun+xwave_dump waves"
XWAVE_CMD   = $(XWAVE_CMD_$(USE_VELOCE)_$(USE_XWAVE))
BATCH_VSIM_ARGS += $(XWAVE_CMD)

BATCH_VSIM_ARGS += $(EXTRA_VIS_QWAVEDB_ARGS)

all: info
info:
	@echo "The following make targets are available:"
	@echo "  clean:      Removes proceduraly created files"
	@echo "  debug:      Runs the simulation in GUI mode.  Not valid for Veloce use"
	@echo "  cli:        Runs the simulation in command line mode. Valid for Questa or Veloce"
	@echo "  vis:        Opens a single visualizer session for Questa only use"
	@echo "  vis_veloce: When running with Veloce, 2 Visualizer invocations are opened"
	@echo ""
	@echo "Control Variables:"
	@echo " Control variables are available to enable/disable functionality (USE_VELOCE=1)"
	@echo "  USE_VELOCE      - 0 (default) for pure sim.  1 to run on Veloce"
	@echo "  TEST_NAME       - Change which test is run. Default is test_top"
	@echo "  USE_AUTOUP      - 0 (default) disabled.  When USE_VELOCE=1, 1 to use the "
	@echo "                  - Veloce trace buffers to capture all signals"
	@echo "  USE_XWAVE       - 0 (default) disabled.  When USE_VELOCE=1, 1 to use "
	@echo "                  - xwave (live stream) wave form capture. Requires signal list"
	@echo "                  - added in veloce.config (rtlc -xwave_siglist xwaves.sigs)"

# Dofile commands - debug only does a run 0, adds everything to waves. 
# Will run 1ns into sim for Visualizer in order to add waves.
DBG_RUN_0 = run 0;
DBG_RUN_1 = run 0;
DBG_RUN = $(DBG_RUN_$(USE_VIS))
RUN_CMD_0 = $(DBG_RUN)
RUN_CMD_1 =
RUN_CMD = $(RUN_CMD_$(NO_RUN))

DEBUG_DO_COMMANDS_0 = -do " \
                    set NoQuitOnFinish 1; \
                    $(RUN_CMD) $(WAVE_FILE_CMD) $(EXTRA_DO_CMD)" 
DEBUG_DO_COMMANDS_1 = -do " \
                    $(RUN_CMD) $(WAVE_FILE_CMD) $(EXTRA_DO_CMD)" 
DEBUG_DO_COMMANDS = $(DEBUG_DO_COMMANDS_$(USE_VIS))

# Batch dofile commands - run each test to completion
BATCH_DO_COMMANDS = -do " \
	 	    coverage save -onexit $(TEST_NAME).ucdb; \
                    set IterationLimit 140000; \
                    set NoQuitOnFinish 1; \
                    $(VWAVES_CMD) \
                    $(EXTRA_DO_CMD) \
                    run -all; \
                    quit -f;" 

# Standard test bench modules; these are split into two top-levels for the purposes of emulation
TOP_HVL ?= hvl_top
TOP_HDL ?= hdl_top 

TOP_TB_0 = $(TOP_HVL) $(TOP_HDL) 
TOP_TB_1 = $(TOP_HVL) $(TOP_HDL) TbxSvManager
TOP_TB   = $(TOP_TB_$(USE_VELOCE_OR_VTL)) $(EXTRA_VOPT_TOPS)

TEST_BENCH = \
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(UVMF_PROJECT_DIR)/tb/testbench \
-F $(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hvl.f

TEST_BENCH_HDL = \
+incdir+$(UVMF_PROJECT_DIR)/tb/testbench \
-F $(UVMF_PROJECT_DIR)/tb/testbench/top_filelist_hdl.f

# UVM package source (not built-in so still needed for Veloce flow)
VELOCE_UVM_PKG = \
+define+QUESTA \
+incdir+$(QUESTA_HOME)/verilog_src/uvm-1.1d/src \
$(QUESTA_HOME)/verilog_src/uvm-1.1d/src/uvm_pkg.sv

# Control over UVM file name & line number output. By default this is suppressed but can put it back
# in by setting UVM_DISABLE_FILE_LINE=0 on command-line or in top-level make file
UVM_DISABLE_FILE_LINE ?= 1
UVM_DISABLE_FILE_LINE_0 = 
UVM_DISABLE_FILE_LINE_1 = +define+UVM_REPORT_DISABLE_FILE_LINE
UVM_DISABLE_FILE_LINE_CMD = $(UVM_DISABLE_FILE_LINE_$(UVM_DISABLE_FILE_LINE))
VLOG_ARGS += $(UVM_DISABLE_FILE_LINE_CMD)

# UVM package source - Compile external UVM package - use this if defined, otherwise
# the default built-in UVM package with Questa will be used
UVMF_EXT_UVM_PKG ?=
NO_QUESTA_DEBUG_PKG ?= 0
ifeq ($(UVMF_EXT_UVM_PKG),)
	## No external source provided. Use the built-in pre-compiled UVM library by leaving this command empty
	QUESTA_COMP_UVM_CMD =
	UVM_INCDIR = 
else
	UVM_INCDIR = +incdir+$(UVMF_EXT_UVM_PKG)/src
	VLOG_ARGS += $(UVM_INCDIR)
	QUESTA_COMP_UVM_CMD = \
	  vlog -ccflags "-DQUESTA -w" $(UVMF_EXT_UVM_PKG)/src/dpi/uvm_dpi.cc; \
	  vlog $(UVM_INCDIR) $(UVM_DISABLE_FILE_LINE_CMD) $(UVMF_EXT_UVM_PKG)/src/uvm_pkg.sv;
ifeq ($(NO_QUESTA_DEBUG_PKG),0)
	  QUESTA_COMP_UVM_CMD += \
	    vlog $(UVM_INCDIR) $(UVM_DISABLE_FILE_LINE_CMD) +incdir+$(QUESTA_UVM_PKG_DIR) $(QUESTA_UVM_PKG_DIR)/questa_uvm_pkg.sv;
endif    	    
endif

QUESTA_UVM_PKG_DIR ?= $(QUESTA_HOME)/verilog_src/questa_uvm_pkg-1.2/src
QUESTA_UVM_PKG  = +incdir+$(QUESTA_UVM_PKG_DIR) $(QUESTA_UVM_PKG_DIR)/questa_uvm_pkg.sv

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
+incdir+$(VELOCE_HOME)/tbx/res_arbitrator_sim/hdl \
$(VELOCE_HOME)/tbx/res_arbitrator_sim/hdl/ResArbitratorIntf.sv

# Common targets
help:
	@echo "The following make targets are available:"
	@echo "   clean:              Delete work library, generated files, log files, etc."
	@echo "   debug or gui:       Build and run the default test in the GUI"
	@echo "   cli:                Build and run the default test in command-line mode"
	@echo "   gui_run or run_gui: Run the default test in the GUI without recompilation"
	@echo "   cli_run or run_cli: Run the default test in batch mode without recompilation"
	@echo "   vrun:               Invoke a regression using VRM and test list as guide"
	@echo "   The following switches can be added to the above commands:"
	@echo "      TEST_NAME=<testname> to run a different test than the default, which is test_top"
	@echo "      TEST_SEED=<seed> to run a test using a different seed than the default, which is 'random'"
	@echo "      USE_VIS=1 to use Visualizer debug environment in either command line or GUI mode"
	@echo "      USE_VIS_UVM=1 to use Visualizer debug environment, including advanced UVM and class debug capabilities, in either command line or GUI mode"
	@echo "More details regarding available targets and variables can be found in the Makefiles section of UVM_Framework_Users_Guide.pdf"

clean::
	@-rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
	@-rm -rfv design.bin qwave.db dpiheader.h visualizer*.ses vrmhtmlreport
	@-rm -rfv veloce.med veloce.wave tbxbindings.h edsenv
	@-rm -rfv sv_connect.*
	@-rm -rfv *.o *.so
	@-rm -rfv covercheck_results
	@-rm -rfv qrun.out *.qf *.vf

realclean:: clean
	@-rm -rfv modelsim.ini

libs:
	test -e work || vlib work 

# Visualizer target arfguments
VIS_ARGS_0 =
VIS_ARGS_1 = -do $(WAVE_FILE)
VIS_ARGS = $(VIS_ARGS_$(WAVE_FILE_EXISTS))

VIS_VEL_ARGS_0 =
VIS_VEL_ARGS_1 = -tracedir veloce.wave/waves.stw -comodel
VIS_VEL_ARGS   = $(VIS_VEL_ARGS_$(USE_VELOCE))

DEBUG_VOPT_TOP_0 = optimized_debug_top_tb
DEBUG_VOPT_TOP_1 = optimized_batch_top_tb
DEBUG_VOPT_TOP = $(DEBUG_VOPT_TOP_$(USE_VIS))

DEBUG_SWITCH_0 = -i
DEBUG_SWITCH_1 = -visualizer
DEBUG_SWITCH = $(DEBUG_SWITCH_$(USE_VIS))

vis: USE_VIS = 1
vis:
	visualizer -designfile design.bin -wavefile qwave.db $(VIS_ARGS) $(VIS_VEL_ARGS)

vis_veloce:
	visualizer -tracedir veloce.wave/waves.stw &
	visualizer -designfile design.bin -wavefile qwave.db &

# Top Test Bench Modules
hvl_comp_testbench:
	$(HVL_COMP_CMD) $(TEST_BENCH)

hdl_comp_testbench:
	$(HDL_COMP_CMD) $(TEST_BENCH_HDL)
	$(VEL_COMP)

comp_test_bench: hvl_comp_testbench hdl_comp_testbench

VEL_COMP_0 =
VEL_COMP_1 = $(VELCOMP_CMD)
VEL_COMP  = $(VEL_COMP_$(USE_VELOCE))

# Code coverage enabled by setting CODE_COVERAGE_ENABLE to 1 (default 0)
CODE_COVERAGE_ENABLE ?= 0
CODE_COVERAGE_TYPES ?= bsf
CODE_COVERAGE_TARGET ?= /hdl_top/DUT.
VOPT_CODE_COV_ARGS_0 = 
VOPT_CODE_COV_ARGS_1 = +cover=$(CODE_COVERAGE_TYPES)+$(CODE_COVERAGE_TARGET)
VOPT_CODE_COV_ARGS ?= $(VOPT_CODE_COV_ARGS_$(CODE_COVERAGE_ENABLE))
VSIM_CODE_COV_ARGS_0 =
VSIM_CODE_COV_ARGS_1 = -coverage
VSIM_CODE_COV_ARGS ?= $(VSIM_CODE_COV_ARGS_$(CODE_COVERAGE_ENABLE))

# UVM Base class targets
COMP_UVM_PKG_TGT_0 = q_comp_uvm_pkg
COMP_UVM_PKG_TGT_1 = v_comp_uvm_pkg
COMP_UVM_PKG_TGT = $(COMP_UVM_PKG_TGT_$(USE_VELOCE))

comp_uvm_pkg: $(COMP_UVM_PKG_TGT)

q_comp_uvm_pkg:
	$(QUESTA_COMP_UVM_CMD)

v_comp_uvm_pkg: q_comp_uvm_pkg
	$(VELANALYZE_HVL_CMD) $(VELOCE_UVM_PKG)

# UVMF Base class targets
include $(UVMF_HOME)/uvmf_base_pkg/Makefile

# VIP common targets
comp_vip_base_pkg:
	$(HVL_COMP_CMD) $(VIP_BASE_PKG)

comp_vtl_base_pkg:
	$(HVL_COMP_CMD) $(VTL_BASE_PKG_HVL)
	$(HDL_COMP_CMD) $(VTL_BASE_PKG_HDL)

VINFO_TGT_0 = q_vinfo_comp
VINFO_TGT_1 = v_vinfo_comp
VINFO_TGT = $(VINFO_TGT_$(USE_VELOCE))

q_vinfo_comp:
	$(HVL_COMP_CMD) -F hvl.vf

v_vinfo_comp: comp_uvm_pkg q_vinfo_comp
	$(VELANALYZE_HVL_CMD) -F hvl.vf

build_hdl_vinfo:
	$(MFLIST) hdl.vinfo -o ./hdl.vf

build_hvl_vinfo:
	$(MFLIST) hvl.vinfo -o ./hvl.vf

BUILD_TGT_0 = make_build
BUILD_TGT_1 = vinfo_build
BUILD_TGT = $(BUILD_TGT_$(USE_VINFO))

# Link target (Veloce)
link:
	$(LINK)

LINK_0 =
LINK_1 = $(LINK_CMD)
LINK = $(LINK_$(USE_VELOCE_OR_VTL))

# Optimize target - For Classic run vopt twice.. one for batch mode (high performance, low visibility) and
#   one for debug mode (full visibility).  Doing it twice here allows the gui_run and cli_run
#   targets to be run at the user's convenience later on without reoptimizing.  Also utilized
#   by VRM's rerun capabilities
#   For Visualizer, only run vopt once (always with -debug)
optimize:
ifeq ($(USE_VELOCE_LINT), 1)
	$(PRE_VOPT_CLI_CMD)
	$(PRE_VOPT_CLI_SETENV) vopt $(VOPT_CODE_COV_ARGS) $(BATCH_VOPT_ARGS) $(VELLINT_VOPT_ARG) $(EXTRA_VOPT_ARGS) $(TOP_TB) -o optimized_batch_top_tb
endif
	$(PRE_VOPT_CLI_CMD)
	$(PRE_VOPT_CLI_SETENV) vopt $(VOPT_CODE_COV_ARGS) $(BATCH_VOPT_ARGS) $(EXTRA_VOPT_ARGS) $(TOP_TB) -o optimized_batch_top_tb
ifeq ($(USE_VIS),0)
	$(PRE_VOPT_GUI_CMD) 
	$(PRE_VOPT_GUI_SETENV) vopt $(VOPT_CODE_COV_ARGS) $(DEBUG_VOPT_ARGS) $(EXTRA_VOPT_ARGS) $(TOP_TB) -o optimized_debug_top_tb
endif


# Invoke a GUI mode simulation
gui_run: 
	$(PRE_VSIM_GUI_CMD) 
	$(PRE_VSIM_GUI_SETENV) vsim $(DEBUG_SWITCH) $(VSIM_CODE_COV_ARGS) $(EXTRA_VSIM_ARGS) $(DEBUG_VSIM_ARGS) $(DEBUG_DO_COMMANDS) $(DEBUG_VOPT_TOP) $(EXTRA_VSIM_TOPS)

# Invoke a batch mode simulation
cli_run: 
	$(PRE_VSIM_CLI_CMD) 
	$(PRE_VSIM_CLI_SETENV) vsim -c $(VSIM_CODE_COV_ARGS) $(EXTRA_VSIM_ARGS) $(BATCH_VSIM_ARGS) $(BATCH_DO_COMMANDS) optimized_batch_top_tb  $(EXTRA_VSIM_TOPS)

## Because sometimes we forget what these are called. :)
run_cli: cli_run
run_gui: gui_run

cli: libs build link optimize cli_run
debug gui: libs build link optimize gui_run

vrun:
	vrun $(VRUN_ARGS) $(VRUN_RUNNABLE) -rmdb $(RMDB_PATH) $(VRUN_TIMEOUT_CMD) -GTESTLIST_NAME=$(VRM_TESTLIST) $(VRM_BCR_PARAM) $(EXTRA_VRUN_ARGS)
	vrun -status -html -rmdb $(RMDB_PATH) 

## This target runs covercheck verify using an existing work library and UCDB
COVERCHECK_TOP ?= verilog_dut
COVERCHECK_UCDB ?= test_top.ucdb
COVERCHECK_TIMEOUT ?= 15m
COVERCHECK_BUILD_DIR ?= .
COVERCHECK_DIRECTIVES_FILE ?=
COVERCHECK_INIT_FILE ?=
EXTRA_COVERCHECK_COMPILE_ARGS ?= 
EXTRA_COVERCHECK_VERIFY_ARGS ?=

COVERCHECK_DIRECTIVES_CMD_0 =
COVERCHECK_DIRECTIVES_CMD_1 = do $(COVERCHECK_DIRECTIVES_FILE);
ifeq ($(COVERCHECK_DIRECTIVES_FILE),)
  USE_COVERCHECK_DIRECTIVES = 0
else
  USE_COVERCHECK_DIRECTIVES = 1
endif
COVERCHECK_DIRECTIVES_CMD = $(COVERCHECK_DIRECTIVES_CMD_$(USE_COVERCHECK_DIRECTIVES))

COVERCHECK_INIT_CMD_0 =
COVERCHECK_INIT_CMD_1 = -init $(COVERCHECK_INIT_FILE)
ifeq ($(COVERCHECK_INIT_FILE),)
  USE_COVERCHECK_INIT = 0
else
  USE_COVERCHECK_INIT = 1
endif
COVERCHECK_INIT_CMD = $(COVERCHECK_INIT_CMD_$(USE_COVERCHECK_INIT))

COVERCHECK_MODELSIMINI_CMD_0 = 
COVERCHECK_MODELSIMINI_CMD_1 = -modelsimini $(COVERCHECK_BUILD_DIR)/modelsim.ini
ifneq ("$(wildcard $(COVERCHECK_BUILD_DIR)/modelsim.ini)","")
  USE_COVERCHECK_MODELSIMINI = 1
else
  USE_COVERCHECK_MODELSIMINI = 0
endif
COVERCHECK_MODELSIMINI_CMD = $(COVERCHECK_MODELSIMINI_CMD_$(USE_COVERCHECK_MODELSIMINI))

covercheck:
	qverify -c -od covercheck_results -do " \
	  $(COVERCHECK_DIRECTIVES_CMD) \
	  covercheck compile -work $(COVERCHECK_BUILD_DIR)/work $(COVERCHECK_MODELSIMINI_CMD) -d $(COVERCHECK_TOP) $(EXTRA_COVERCHECK_COMPILE_ARGS); \
	  covercheck load ucdb $(COVERCHECK_UCDB); \
	  covercheck verify -timeout $(COVERCHECK_TIMEOUT) $(COVERCHECK_INIT_CMD) $(EXTRA_COVERCHECK_VERIFY_ARGS); \
	  covercheck generate exclude covercheck_exclude.do; \
	  exit"
