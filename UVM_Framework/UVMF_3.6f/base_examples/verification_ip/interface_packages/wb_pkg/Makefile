# wb interface packages source
wb_PKG         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_hvl.f 

wb_PKG_HDL         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_hdl.f 

COMP_wb_PKG_TGT_0 = q_comp_wb_pkg
COMP_wb_PKG_TGT_1 = v_comp_wb_pkg
COMP_wb_PKG_TGT = $(COMP_wb_PKG_TGT_$(USE_VELOCE))

comp_wb_pkg: $(COMP_wb_PKG_TGT)
	$(HDL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg $(wb_PKG_HDL)

q_comp_wb_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg $(wb_PKG)

v_comp_wb_pkg: q_comp_wb_pkg
	$(VELANALYZE_HVL_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg $(wb_PKG)
