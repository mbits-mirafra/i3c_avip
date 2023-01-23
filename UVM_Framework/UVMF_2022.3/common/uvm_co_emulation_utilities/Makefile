################################### Clock ##################################
CO_EMULATION_CLOCK_PKG         = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/clock \
-F $(UVMF_HOME)/common/uvm_co_emulation_utilities/clock_filelist_hvl.f

CO_EMULATION_CLOCK_PKG_HDL         = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/clock \
-F $(UVMF_HOME)/common/uvm_co_emulation_utilities/clock_filelist_hdl.f

COMP_CO_EMULATION_CLOCK_PKG_TGT_0 = q_comp_co_emulation_clock_pkg
COMP_CO_EMULATION_CLOCK_PKG_TGT_1 = v_comp_co_emulation_clock_pkg
COMP_CO_EMULATION_CLOCK_PKG_TGT = $(COMP_CO_EMULATION_CLOCK_PKG_TGT_$(USE_VELOCE))

comp_co_emulation_clock_pkg: $(COMP_CO_EMULATION_CLOCK_PKG_TGT)
	$(HDL_COMP_CMD) $(CO_EMULATION_CLOCK_PKG_HDL)

q_comp_co_emulation_clock_pkg:
	$(HVL_COMP_CMD) $(CO_EMULATION_CLOCK_PKG)

v_comp_co_emulation_clock_pkg: q_comp_co_emulation_clock_pkg
	$(VELANALYZE_HVL_CMD) $(CO_EMULATION_CLOCK_PKG)


################################### Reset ##################################
CO_EMULATION_RESET_PKG         = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/reset \
-F $(UVMF_HOME)/common/uvm_co_emulation_utilities/reset_filelist_hvl.f

CO_EMULATION_RESET_PKG_HDL         = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/reset \
-F $(UVMF_HOME)/common/uvm_co_emulation_utilities/reset_filelist_hdl.f

COMP_CO_EMULATION_RESET_PKG_TGT_0 = q_comp_co_emulation_reset_pkg
COMP_CO_EMULATION_RESET_PKG_TGT_1 = v_comp_co_emulation_reset_pkg
COMP_CO_EMULATION_RESET_PKG_TGT = $(COMP_CO_EMULATION_RESET_PKG_TGT_$(USE_VELOCE))

comp_co_emulation_reset_pkg: $(COMP_CO_EMULATION_RESET_PKG_TGT)
	$(HDL_COMP_CMD) $(CO_EMULATION_RESET_PKG_HDL)

q_comp_co_emulation_reset_pkg:
	$(HVL_COMP_CMD) $(CO_EMULATION_RESET_PKG)

v_comp_co_emulation_reset_pkg: q_comp_co_emulation_reset_pkg
	$(VELANALYZE_HVL_CMD) $(CO_EMULATION_RESET_PKG)


################################## Mem Load #################################
CO_EMULATION_MEMLOAD_PKG = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/memload/ \
-F $(UVMF_HOME)/common/uvm_co_emulation_utilities/memload_filelist_hvl.f

#CO_EMULATION_MEMLOAD_PKG_HDL = \
#+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/memload \
#-F $(UVMF_HOME)/common/uvm_co_emulation_utilities/memload_filelist_hdl.f

CCFLAGS_0 = -DQUESTA
CCFLAGS_1 = -I${VELOCE_HOME}/runtime/include
CCFLAGS   = $(CCFLAGS_$(USE_VELOCE))

#velcomp creates the tbxbindings.h that is needed in Veloce mode
comp_co_emulation_memload_pkg: $(COMP_CO_EMULATION_MEMLOAD_PKG_TGT)
#	$(HDL_COMP_CMD) $(CO_EMULATION_MEMLOAD_PKG_HDL)

q_comp_co_emulation_memload_pkg:
	$(HVL_COMP_CMD) $(CO_EMULATION_MEMLOAD_PKG) \
    -ccflags "-FPIC -I${MTI_HOME}/include $(CCFLAGS)"

v_comp_co_emulation_memload_pkg: q_comp_co_emulation_memload_pkg
#	$(VELANALYZE_HVL_CMD) $(CO_EMULATION_MEMLOAD_PKG)


#comp_co_emulation_memload_pkg:
#	vlog $(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/memload/memload_pkg.sv $(UVMF_HOME)/common/uvm_co_emulation_utilities/uvm_co_emulation_utilities/utils/memload/src/memload.cc -dpiheader dpiheader.h -ccflags "-FPIC -I${MTI_HOME}/include $(CCFLAGS)"
