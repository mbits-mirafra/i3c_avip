# Package make targets
ALU_IN_PKG         = \
+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg \
$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg/alu_in_filelist_hvl.f 

ALU_IN_PKG_HDL         = \
+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg \
$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg/alu_in_filelist_hdl.f 

COMP_ALU_IN_PKG_TGT_0 = q_comp_alu_in_pkg
COMP_ALU_IN_PKG_TGT_1 = v_comp_alu_in_pkg
COMP_ALU_IN_PKG_TGT = $(COMP_ALU_IN_PKG_TGT_$(USE_VELOCE))

comp_alu_in_pkg: $(COMP_ALU_IN_PKG_TGT)
	$(HDL_COMP_CMD) $(ALU_IN_PKG_HDL)

q_comp_alu_in_pkg:
	$(HVL_COMP_CMD) $(ALU_IN_PKG)

v_comp_alu_in_pkg: q_comp_alu_in_pkg
	$(VELANALYZE_HVL_CMD) $(ALU_IN_PKG)

