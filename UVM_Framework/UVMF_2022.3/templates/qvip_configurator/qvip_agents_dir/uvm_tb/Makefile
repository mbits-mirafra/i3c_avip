####################
# Common Setup.

INCDIRS = +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv \
          +incdir+../config_policies

HVL_SV_SOURCE = ${QUESTA_MVC_HOME}/include/questa_mvc_svapi.sv \
            +define+MAP_PROT_ATTR ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie ${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie/mgc_pcie_v2_0_pkg.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3/mgc_apb3_v1_0_pkg.sv \
            ../config_policies/qvip_agents_params_pkg.sv \
            qvip_agents_pkg.sv \
            hvl_qvip_agents.sv
HDL_SV_SOURCE = \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie/modules/pcie_ep_serial.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_master.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_slave.sv \
            +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3/modules/apb_master.sv \
            default_clk_gen.sv \
            default_reset_gen.sv \
            hdl_qvip_agents.sv

UVM_OPTIONS = +UVM_TESTNAME=qvip_agents_test_base +SEQ=qvip_agents_vseq_base

####################
# Questa support.

all: work sv opt sim

sv: hvl_sv hdl_sv

vis: work sv vis_opt vis_sim

work:
	vlib work

hvl_sv:
	vlog $(INCDIRS) $(HVL_SV_SOURCE)

hdl_sv:
	vlog $(INCDIRS) $(HDL_SV_SOURCE)

opt:
	vopt hdl_qvip_agents hvl_qvip_agents -o top_opt

vis_opt:
	vopt hdl_qvip_agents hvl_qvip_agents -o top_opt -debug -designfile design.bin

sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1fs -c -do "run -all; quit"

vis_sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1fs -c -do "run -all; quit" -qwavedb=+signal+transaction+class+uvm_schematic
	visualizer -designfile design.bin -wavefile qwave.db

gui:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1fs

####################
# Incisive support.

ius32:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/:${IUS_HOME}/tools/cdsgcc/gcc//install/lib:${LD_LIBRARY_PATH} \
         xrun -sv -uvm -quiet -access +rwc -timescale 1fs/1fs $(INCDIRS) $(HVL_SV_SOURCE) $(HDL_SV_SOURCE) \
         -sv_root ${QUESTA_MVC_HOME}/questa_mvc_core/ \
         -sv_lib libpcie_IN_SystemVerilog_IUS_full \
         -sv_lib libapb3_IN_SystemVerilog_IUS_full \
         -sv_lib libaxi4_IN_SystemVerilog_IUS_full \
         $(UVM_OPTIONS)

ius64:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/:${IUS_HOME}/tools/cdsgcc/gcc//install/lib64:${LD_LIBRARY_PATH} \
         xrun -sv -uvm -quiet -access +rwc -64bit -timescale 1fs/1fs $(INCDIRS) $(HVL_SV_SOURCE) $(HDL_SV_SOURCE) \
         -sv_root ${QUESTA_MVC_HOME}/questa_mvc_core/ \
         -sv_lib libpcie_IN_SystemVerilog_IUS_full \
         -sv_lib libapb3_IN_SystemVerilog_IUS_full \
         -sv_lib libaxi4_IN_SystemVerilog_IUS_full \
         $(UVM_OPTIONS)

####################
# VCS support.

vcs32:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/:${VCS_HOME}/gnu/linux/gcc-/lib:${LD_LIBRARY_PATH} \
        vcs -sverilog -ntb_opts uvm -debug_access+w -quiet  -timescale=1fs/1fs \
        -ld ${VCS_HOME}/gnu/linux/gcc-/xbin/g++ \
        $(INCDIRS) $(HVL_SV_SOURCE) $(HDL_SV_SOURCE)                     \
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core//libpcie_IN_SystemVerilog_VCS_full.so\
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core//libapb3_IN_SystemVerilog_VCS_full.so\
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core//libaxi4_IN_SystemVerilog_VCS_full.so
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/:${VCS_HOME}/gnu/linux/gcc-/lib:${LD_LIBRARY_PATH} \
        ./simv $(UVM_OPTIONS)

vcs64:
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/:${VCS_HOME}/gnu/linux/gcc-/lib64:${LD_LIBRARY_PATH} \
        vcs -sverilog -ntb_opts uvm -debug_access+w -quiet  -full64 -timescale=1fs/1fs \
        -ld ${VCS_HOME}/gnu/linux/gcc-/xbin/g++ \
        $(INCDIRS) $(HVL_SV_SOURCE) $(HDL_SV_SOURCE)                     \
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core//libpcie_IN_SystemVerilog_VCS_full.so\
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core//libapb3_IN_SystemVerilog_VCS_full.so\
        -syslib ${QUESTA_MVC_HOME}/questa_mvc_core//libaxi4_IN_SystemVerilog_VCS_full.so
	env LD_LIBRARY_PATH=${QUESTA_MVC_HOME}/questa_mvc_core/:${VCS_HOME}/gnu/linux/gcc-/lib64:${LD_LIBRARY_PATH} \
        ./simv $(UVM_OPTIONS)

####################
# Cleanup.

clean:
	rm -rf work transcript vsim.wlf
	rm -rf csrc simv* ucli.key vc_hdrs.h
	rm -rf INCA_libs xrun.log xrun.history

.PHONY: all sv hvl_sv hdl_sv opt sim gui ius32 ius64 vcs32 vcs64

.PHONY: vis vis_opt vis_sim
