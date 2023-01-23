FLI_PKG         = \
+incdir+$(UVMF_HOME)/common/fli_pkg \
$(UVMF_HOME)/common/fli_pkg/fli_pkg.sv

COMP_FLI_PKG_TGT_0 = q_comp_fli_pkg
COMP_FLI_PKG_TGT_1 = v_comp_fli_pkg
COMP_FLI_PKG_TGT = $(COMP_FLI_PKG_TGT_$(USE_VELOCE))

comp_fli_pkg: $(COMP_FLI_PKG_TGT)

q_comp_fli_pkg:
	$(HVL_COMP_CMD) $(FLI_PKG)

v_comp_fli_pkg: q_comp_fli_pkg
#	$(VELANALYZE_HVL_CMD) $(FLI_PKG)

