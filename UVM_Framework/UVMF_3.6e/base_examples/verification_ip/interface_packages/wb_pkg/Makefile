# Package make targets
WB_PKG         = \
+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg \
$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_hvl.f 

WB_PKG_HDL         = \
+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg \
$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_hdl.f 

COMP_WB_PKG_TGT_0 = q_comp_wb_pkg
COMP_WB_PKG_TGT_1 = v_comp_wb_pkg
COMP_WB_PKG_TGT = $(COMP_WB_PKG_TGT_$(USE_VELOCE))

comp_wb_pkg: $(COMP_WB_PKG_TGT)
	$(HDL_COMP_CMD) $(WB_PKG_HDL)

q_comp_wb_pkg:
	$(HVL_COMP_CMD) $(WB_PKG)

v_comp_wb_pkg: q_comp_wb_pkg
	$(VELANALYZE_HVL_CMD) $(WB_PKG)

