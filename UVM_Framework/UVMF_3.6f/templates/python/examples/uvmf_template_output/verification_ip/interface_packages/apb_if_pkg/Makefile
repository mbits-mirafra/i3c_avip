# apb_if interface packages source
apb_if_PKG         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_pkg/apb_if_filelist_hvl.f 

apb_if_PKG_HDL         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_pkg/apb_if_filelist_hdl.f 

COMP_apb_if_PKG_TGT_0 = q_comp_apb_if_pkg
COMP_apb_if_PKG_TGT_1 = v_comp_apb_if_pkg
COMP_apb_if_PKG_TGT = $(COMP_apb_if_PKG_TGT_$(USE_VELOCE))

comp_apb_if_pkg: $(COMP_apb_if_PKG_TGT)
	$(HDL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_pkg $(apb_if_PKG_HDL)

q_comp_apb_if_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_pkg $(apb_if_PKG)  +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_infact_proj/apb_if_infact_sequence 
v_comp_apb_if_pkg: q_comp_apb_if_pkg
	$(VELANALYZE_HVL_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_pkg $(apb_if_PKG)  +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/apb_if_infact_proj/apb_if_infact_sequence 
