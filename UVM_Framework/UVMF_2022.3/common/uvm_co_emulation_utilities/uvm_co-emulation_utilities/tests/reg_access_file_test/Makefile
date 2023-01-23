# Makefile for uvm_regs_rsp_react
UTIL_HOME       = ../../utils/reg_access_file/
UTIL_FILES      = $(UTIL_HOME)/print_uvm_reg_acc_pkg.sv
REG_MODEL_HOME  = ./register_files
REG_MODEL_FILES = $(REG_MODEL_HOME)/quirky_regs_pkg.sv \
                  $(REG_MODEL_HOME)/dut_registers_pkg.sv


run: create_acc_file

compile_util_pkg :
	test -e work || vlib work
	vlog -incr \
        +incdir+$(UTIL_HOME) \
        $(UTIL_FILES)

compile_reg_model_pkg : compile_util_pkg
	test -e work || vlib work
	vlog -incr \
        +incdir+$(REG_MODEL_HOME) \
        $(REG_MODEL_FILES)

create_acc_file: compile_reg_model_pkg
	vlog create_access_file.sv
	vsim -c create_access_file -do "run -a; exit -f"


clean:
	rm -rf  *.tmp  *.log  log transcript work *.wlf vsim.fcdb *.dbg *stacktrace* *.ucdb covhtmlreport SCRATCH vrunhtmlreport certe_dump.xml reg_acc.f forcesetget_nets.sigs vis_regs.tcl
	find ../.. -name "*~" -delete
	find ../.. -name "*.bak" -delete
