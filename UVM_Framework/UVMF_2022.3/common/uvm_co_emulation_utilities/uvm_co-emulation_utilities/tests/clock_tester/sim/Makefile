#Basic variables
EXAMPLE_NAME = clock_tester
HVL_TOP_NAME = hvl_top
HDL_TOP_NAME = hdl_top

#Control Variables.  Set them from the command line (i.e.  USE_VELOCE=1)
USE_VELOCE      ?= 0
UVM_HOME        ?= $(QUESTA_HOME)/verilog_src/uvm-1.1d
TESTNAME        ?= reset_test
VIS_INTERACTIVE ?= 0
USE_AUTOUP      ?= 0
USE_XWAVE       ?= 0

EN_BETA         ?= 0

BETA_VOPT_0 = 
BETA_VOPT_1 = +keeplrmcompliantvhdlbracket
BETA_VOPT   = $(BETA_VOPT_$(EN_BETA))

BETA_VELHVL_0 = 
BETA_VELHVL_1 = -vlog_opts “+define+VISUALIZER_DBG”
BETA_VELHVL   = $(BETA_VELHVL_$(EN_BETA))

# # Add to default compile/load/run arguments
GCC_ARG_0 =
GCC_ARG_1 = # -cppinstall 4.5.0 # Required to run with Questa 10.4; With Questa 10.3b the default 4.3.3 yields a vopt error/bug)
GCC_ARG   = $(GCC_ARG_$(USE_VELOCE))


VLOG_FILES_1 = -f ./shared_files.f -f ./hvl_files.f #-f ./c_files.f
VLOG_FILES_0 = $(VLOG_FILES_1) -f ./hdl_files.f
VLOG_FILES   = $(VLOG_FILES_$(USE_VELOCE))

VOPT_TOPS_0 = $(HVL_TOP_NAME) $(HDL_TOP_NAME)
VOPT_TOPS_1 = $(VOPT_TOPS_0) TbxSvManager
VOPT_TOPS   = $(VOPT_TOPS_$(USE_VELOCE))

VEL_ANALYZE_SHARED_0 = 
VEL_ANALYZE_SHARED_1 = velanalyze -f shared_files.f
VEL_ANALYZE_SHARED   = $(VEL_ANALYZE_SHARED_$(USE_VELOCE))

VEL_ANALYZE_HVL_0 = 
VEL_ANALYZE_HVL_1 = velanalyze -extract_hvl_info +incdir+$(UVM_HOME)/src \
	$(UVM_HOME)/src/uvm_pkg.sv \
	-f hvl_files.f 
VEL_ANALYZE_HVL   = $(VEL_ANALYZE_HVL_$(USE_VELOCE))

VEL_ANALYZE_HDL_0 = 
VEL_ANALYZE_HDL_1 = velanalyze -sv -f hdl_files.f
VEL_ANALYZE_HDL   = $(VEL_ANALYZE_HDL_$(USE_VELOCE))

VEL_COMP_0 = 
VEL_COMP_1 = velcomp -top $(HDL_TOP_NAME)
VEL_COMP   = $(VEL_COMP_$(USE_VELOCE))

VEL_HVL_0   = 
VEL_HVL_1   = velhvl -sim veloce -g -enable_profile_report $(GCC_ARG) $(BETA_VELHVL)
VEL_HVL     = $(VEL_HVL_$(USE_VELOCE))

VWAVES_CMD_0 = 
#VWAVES_CMD_1 = velocecmd \"upload -tracedir waves\"; exit -f;
#VWAVES_CMD_1 = # velocecmd \"hwtrace autoupload on -tracedir waves\"
VWAVES_CMD_1 = velocecmd \"hwtrace autoupload on -tracedir waves -gen crd -crd_options \\\"-o waves.crd -siglist xwaves.sigs\\\" \"
VWAVES_CMD   = $(VWAVES_CMD_$(USE_AUTOUP))

XWAVE_CMD_0 = 
XWAVE_CMD_1 = +velrun+xwave_on +velrun+xwave_select_all_groups "+velrun+xwave_dump waves"
XWAVE_CMD   = $(XWAVE_CMD_$(USE_XWAVE))

VSIM_VIS_0 = -c 
VSIM_VIS_1 = -visualizer
VSIM_VIS   = $(VSIM_VIS_$(VIS_INTERACTIVE))

VSIM_VIS_DO_0 = -do " $(VWAVES_CMD); do vsim.do;"
VSIM_VIS_DO_1 = 
VSIM_VIS_DO   = $(VSIM_VIS_DO_$(VIS_INTERACTIVE))


info:
	@echo "The following make targets are available:"
	@echo "  clean:    Removes proceduraly created files"
	@echo "  build:    Builds the design and testbench"
	@echo "  run:      Runs the simulation.  A build is required before run"
	@echo "  vis:      Opens a single visualizer session"
	@echo "  2vis:     When running with Veloce, 2 Visualizer invocations are opened"
	@echo "  tar:      Creates a tgz file"
	@echo ""
	@echo "Control Variables:"
	@echo " Control variables are available to enable/disable functionality (USE_VELOCE=1)"
	@echo "  USE_VELOCE      - 0 (default) for pure sim.  1 to run on Veloce"
	@echo "  TESTNAME        - Change which test is run"
	@echo "  VIS_INTERACTIVE - 0 (default) to run in batch mode.  1 for interactive"
	@echo "                  - Visualizer GUI"
	@echo "  USE_AUTOUP      - 0 (default) disabled.  When USE_VELOCE=1, 1 to use the "
	@echo "                  - Veloce trace buffers to capture all signals"
	@echo "  USE_XWAVE       - 0 (default) disabled.  When USE_VELOCE=1, 1 to use "
	@echo "                  - xwave (live stream) wave form capture. Requires signal list"
	@echo "                  - added in veloce.config (rtlc -xwave_siglist xwaves.sigs)"

clean:
	rm -rf work comp.log sim.log opt.log visualizer.log .visualizer* .qwave* *.wlf qwave.db design.bin visualizer*.ses*.vstf certe_dump.xml veloce.log veloce.map veloce.med veloce.wave qsim.log transcript waves.crd reset_test.log hdloffice.log clock_test.log manual_reset_test.log
	find .. -name "*~" -delete

build:
	vlib work
	vlog -sv -l comp.log +libext+.v+.sv \
    -permissive -suppress 2583 $(VLOG_FILES)
	$(VEL_ANALYZE_SHARED)
	$(VEL_ANALYZE_HVL)
	$(VEL_ANALYZE_HDL)
	$(VEL_COMP)
	$(VEL_HVL)
	vopt +acc +designfile -suppress 3053 -l opt.log $(GCC_ARG) \
    $(VOPT_TOPS) -o tops_opt $(BETA_VOPT)

run:
	vsim $(VSIM_VIS) \
    -stats=perf,verbose \
    $(XWAVE_CMD) \
    -l $(TESTNAME).log -suppress 3764 -fatal 8520 -solvefaildebug $(GCC_ARG) \
    -qwavedb=signal+memory=5000+transaction+class+report+assertion \
    -onfinish stop $(VSIM_VIS_DO) tops_opt \
    -permit_unmatched_virtual_intf \
    +UVM_TESTNAME=$(TESTNAME) -uvmcontrol=msglog -suppress 8887

VIS_ARGS_0 = 
VIS_ARGS_1 = -tracedir veloce.wave/waves.stw -comodel
VIS_ARGS   = $(VIS_ARGS_$(USE_VELOCE))

vis:
	visualizer -designfile design.bin -wavefile qwave.db $(VIS_ARGS)

2vis:
	visualizer -tracedir veloce.wave/waves.stw &
	visualizer -designfile design.bin -wavefile qwave.db &


TAR_VERSION  ?= 1.0

tar: clean
	cd ../..; tar zcvfh $(EXAMPLE_NAME)-$(TAR_VERSION).tgz --exclude .git --exclude .gitignore $(EXAMPLE_NAME)
	cp ../../$(EXAMPLE_NAME)-$(TAR_VERSION).tgz ~/Shared/Customer/.
