####################
# Common Setup.

INCDIRS = +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv \
          +incdir+${UVMF_HOME}/uvmf_base_pkg \
          +incdir+../config_policies

HVL_SV_SOURCE = hvl_qvip_agents.sv
HDL_SV_SOURCE = hdl_qvip_agents.sv

UVM_OPTIONS = +UVM_TESTNAME=qvip_agents_test_base +SEQ=qvip_agents_vseq_base

export QVIP_AGENTS_DIR_NAME ?= $(shell pwd)

####################
# Questa support.

all: work sv opt sim

sv: hvl_sv hdl_sv

work:
	vlib work

hvl_sv:
	vlog -f qvip_agents_test_filelist.f $(INCDIRS) $(HVL_SV_SOURCE)

hdl_sv:
	vlog -f qvip_agents_test_filelist.f $(INCDIRS) $(HDL_SV_SOURCE)

opt:
	vopt hdl_qvip_agents hvl_qvip_agents -o top_opt

sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1ns -c -do "run -all; quit"

gui:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1ns

####################
# Cleanup.

clean:
	rm -rf work transcript vsim.wlf

.PHONY: all sv hvl_sv hdl_sv opt sim gui
