####################
# Common Setup.

INCDIRS = +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv \
          +incdir+../config_policies

SV_SOURCE = ${QUESTA_MVC_HOME}/include/questa_mvc_svapi.svh \
            +define+MAP_PROT_ATTR ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv \
            ../config_policies/axi4_2x2_fabric_qvip_params_pkg.sv \
            axi4_2x2_fabric_qvip_pkg.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_master.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_slave.sv \
            DUT.sv \
            default_clk_gen.sv \
            default_reset_gen.sv \
            hdl_axi4_2x2_fabric_qvip.sv \
            hvl_axi4_2x2_fabric_qvip.sv

UVM_OPTIONS = +UVM_TESTNAME=axi4_2x2_fabric_qvip_test_base +SEQ=axi4_2x2_fabric_qvip_vseq_base

####################
# Questa support.

all: work sv opt sim

work:
	vlib work

sv:
	vlog $(INCDIRS) $(SV_SOURCE)

opt:
	vopt hdl_axi4_2x2_fabric_qvip hvl_axi4_2x2_fabric_qvip -o top_opt

sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -c -do "run -all; quit"

gui:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE

####################
# Incisive support.

ius32:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/linux_gcc-4.4_ius:${IUS_HOME}/tools/cdsgcc/gcc/4.4/install/lib:${LD_LIBRARY_PATH} \
         irun -sv -uvm -quiet -access +rwc -timescale 1ns/1ns $(INCDIRS) $(SV_SOURCE) \
         -sv_root ${QUESTA_MVC_HOME}/questa_mvc_core/linux_gcc-4.4_ius \
         -sv_lib libaxi4_IN_SystemVerilog_IUS_full \
         $(UVM_OPTIONS)

ius64:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/linux_x86_64_gcc-4.4_ius:${IUS_HOME}/tools/cdsgcc/gcc/4.4/install/lib64:${LD_LIBRARY_PATH} \
         irun -sv -uvm -quiet -access +rwc -64bit -timescale 1ns/1ns $(INCDIRS) $(SV_SOURCE) \
         -sv_root ${QUESTA_MVC_HOME}/questa_mvc_core/linux_x86_64_gcc-4.4_ius \
         -sv_lib libaxi4_IN_SystemVerilog_IUS_full \
         $(UVM_OPTIONS)

####################
# VCS support.

vcs32:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/linux_gcc-4.7.2_vcs:${VCS_HOME}/gnu/linux/gcc-4.7.2/lib:${LD_LIBRARY_PATH} \
        vcs -sverilog -ntb_opts uvm +vpi +acc -quiet  -timescale=1ns/1ns \
        -ld ${VCS_HOME}/gnu/linux/gcc-4.7.2/bin/g++ \
        $(INCDIRS) $(SV_SOURCE)                     \
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core/linux_gcc-4.7.2_vcs/libaxi4_IN_SystemVerilog_VCS_full.so
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/linux_gcc-4.7.2_vcs:${VCS_HOME}/gnu/linux/gcc-4.7.2/lib:${LD_LIBRARY_PATH} \
        ./simv $(UVM_OPTIONS)

vcs64:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs:${VCS_HOME}/gnu/linux/gcc-4.7.2/lib64:${LD_LIBRARY_PATH} \
        vcs -sverilog -ntb_opts uvm +vpi +acc -quiet  -full64 -timescale=1ns/1ns \
        -ld ${VCS_HOME}/gnu/linux/gcc-4.7.2/bin/g++ \
        $(INCDIRS) $(SV_SOURCE)                     \
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs/libaxi4_IN_SystemVerilog_VCS_full.so
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/linux_x86_64_gcc-4.7.2_vcs:${VCS_HOME}/gnu/linux/gcc-4.7.2/lib64:${LD_LIBRARY_PATH} \
        ./simv $(UVM_OPTIONS)

####################
# Cleanup.

clean:
	rm -rf work transcript vsim.wlf
	rm -rf csrc simv* ucli.key vc_hdrs.h
	rm -rf INCA_libs irun.log irun.history

.PHONY: all sv opt sim gui ius32 ius64 vcs32 vcs64 clean
