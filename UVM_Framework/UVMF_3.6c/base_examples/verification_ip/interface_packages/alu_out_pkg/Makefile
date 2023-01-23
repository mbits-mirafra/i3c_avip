# Package make targets
ALU_OUT_PKG         = \
+incdir+$(UVMF_HOME)/base_examples/verification_ip/interface_packages/alu_out_pkg \
$(DASH_F_OPTION) $(UVMF_HOME)/base_examples/verification_ip/interface_packages/alu_out_pkg/alu_out_filelist_hvl.f 

ALU_OUT_PKG_HDL         = \
+incdir+$(UVMF_HOME)/base_examples/verification_ip/interface_packages/alu_out_pkg \
$(DASH_F_OPTION) $(UVMF_HOME)/base_examples/verification_ip/interface_packages/alu_out_pkg/alu_out_filelist_hdl.f 

COMP_ALU_OUT_PKG_TGT_0 = q_comp_alu_out_pkg
COMP_ALU_OUT_PKG_TGT_1 = v_comp_alu_out_pkg
COMP_ALU_OUT_PKG_TGT = $(COMP_ALU_OUT_PKG_TGT_$(USE_VELOCE))

comp_alu_out_pkg: $(COMP_ALU_OUT_PKG_TGT)
	$(HDL_COMP_CMD) $(ALU_OUT_PKG_HDL)

q_comp_alu_out_pkg:
	$(HVL_COMP_CMD) $(ALU_OUT_PKG)

v_comp_alu_out_pkg: q_comp_alu_out_pkg
	$(VELANALYZE_HVL_CMD) $(ALU_OUT_PKG)

