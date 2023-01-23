UVMF_BASE_PKG     = \
	+incdir+$(UVMF_HOME)/uvmf_base_pkg \
	-F $(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f

UVMF_BASE_PKG_HDL = \
	+incdir+$(UVMF_HOME)/uvmf_base_pkg \
	-F $(UVMF_HOME)/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f

COMP_UVMF_BASE_PKG_TGT_0 = q_comp_uvmf_base_pkg
COMP_UVMF_BASE_PKG_TGT_1 = v_comp_uvmf_base_pkg
COMP_UVMF_BASE_PKG_TGT = $(COMP_UVMF_BASE_PKG_TGT_$(USE_VELOCE))

comp_uvmf_base_pkg: $(COMP_UVMF_BASE_PKG_TGT)

q_comp_uvmf_base_pkg:
	$(HDL_COMP_CMD) $(UVM_INCDIR) $(UVMF_BASE_PKG_HDL)
	$(HVL_COMP_CMD) $(UVM_INCDIR) $(UVMF_BASE_PKG)

v_comp_uvmf_base_pkg: 
	$(HVL_COMP_CMD)               $(UVMF_BASE_PKG_HDL)
	$(HVL_COMP_CMD) $(UVM_INCDIR) $(UVMF_BASE_PKG)
	$(HDL_COMP_CMD) $(UVMF_BASE_PKG_HDL)
	$(VELANALYZE_HVL_CMD) $(UVMF_BASE_PKG)
