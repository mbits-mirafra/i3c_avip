# Package make targets
CO_EMULATION_CLOCK_PKG         = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/clock \
$(DASH_F_OPTION) $(UVMF_HOME)/common/uvm_co_emulation_utilities/clock/clock_filelist_hvl.f

CO_EMULATION_CLOCK_PKG_HDL         = \
+incdir+$(UVMF_HOME)/common/uvm_co_emulation_utilities/clock \
$(DASH_F_OPTION) $(UVMF_HOME)/common/uvm_co_emulation_utilities/clock/clock_filelist_hdl.f

COMP_CO_EMULATION_CLOCK_PKG_TGT_0 = q_comp_co_emulation_clock_pkg
COMP_CO_EMULATION_CLOCK_PKG_TGT_1 = v_comp_co_emulation_clock_pkg
COMP_CO_EMULATION_CLOCK_PKG_TGT = $(COMP_CO_EMULATION_CLOCK_PKG_TGT_$(USE_VELOCE))

comp_co_emulation_clock_pkg: $(COMP_CO_EMULATION_CLOCK_PKG_TGT)
	$(HDL_COMP_CMD) $(CO_EMULATION_CLOCK_PKG_HDL)

q_comp_co_emulation_clock_pkg:
	$(HVL_COMP_CMD) $(CO_EMULATION_CLOCK_PKG)

v_comp_co_emulation_clock_pkg: q_comp_co_emulation_clock_pkg
	$(VELANALYZE_HVL_CMD) $(CO_EMULATION_CLOCK_PKG)
