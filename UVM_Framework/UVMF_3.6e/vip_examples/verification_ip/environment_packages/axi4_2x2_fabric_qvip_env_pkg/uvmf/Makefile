####################
# Common Setup.

INCDIRS = +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv \
          +incdir+${UVMF_HOME}/uvmf_base_pkg \
          +incdir+../config_policies

SV_SOURCE = hdl_axi4_2x2_fabric_qvip.sv \
            hvl_axi4_2x2_fabric_qvip.sv

UVM_OPTIONS = +UVM_TESTNAME=axi4_2x2_fabric_qvip_test_base +SEQ=axi4_2x2_fabric_qvip_vseq_base

export AXI4_2X2_FABRIC_QVIP_DIR_NAME ?= $(shell pwd)

####################
# Questa support.

all: work sv opt sim

work:
	vlib work

sv:
	vlog  -f axi4_2x2_fabric_qvip_filelist.f $(INCDIRS) $(SV_SOURCE)

opt:
	vopt hdl_axi4_2x2_fabric_qvip hvl_axi4_2x2_fabric_qvip -o top_opt

sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -c -do "run -all; quit"

gui:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE

####################
# Cleanup.

clean:
	rm -rf work transcript vsim.wlf

.PHONY: all sv opt sim gui ius32 ius64 vcs32 vcs64 clean
