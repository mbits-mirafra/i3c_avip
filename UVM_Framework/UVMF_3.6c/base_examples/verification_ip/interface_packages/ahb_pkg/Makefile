# Package make targets
AHB_PKG         = \
+incdir+$(UVMF_HOME)/base_examples/verification_ip/interface_packages/ahb_pkg \
$(DASH_F_OPTION) $(UVMF_HOME)/base_examples/verification_ip/interface_packages/ahb_pkg/ahb_filelist_hvl.f

AHB_PKG_HDL         = \
+incdir+$(UVMF_HOME)/base_examples/verification_ip/interface_packages/ahb_pkg \
$(DASH_F_OPTION) $(UVMF_HOME)/base_examples/verification_ip/interface_packages/ahb_pkg/ahb_filelist_hdl.f

COMP_AHB_PKG_TGT_0 = q_comp_ahb_pkg
COMP_AHB_PKG_TGT_1 = v_comp_ahb_pkg
COMP_AHB_PKG_TGT = $(COMP_AHB_PKG_TGT_$(USE_VELOCE))

comp_ahb_pkg: $(COMP_AHB_PKG_TGT)
	$(HDL_COMP_CMD) $(AHB_PKG_HDL)

q_comp_ahb_pkg:
	$(HVL_COMP_CMD) $(AHB_PKG)

v_comp_ahb_pkg: q_comp_ahb_pkg
	$(VELANALYZE_HVL_CMD) $(AHB_PKG)

