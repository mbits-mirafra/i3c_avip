SVDPI_PKG         = \
+incdir+$(UVMF_HOME)/common/sv_connect/hvl \
$(UVMF_HOME)/common/sv_connect/hvl/svdpi.sv

COMP_SVDPI_PKG_TGT_0 = q_comp_svdpi_pkg
COMP_SVDPI_PKG_TGT_1 = v_comp_svdpi_pkg
COMP_SVDPI_PKG_TGT = $(COMP_SVDPI_PKG_TGT_$(USE_VELOCE))

comp_svdpi_pkg: $(COMP_SVDPI_PKG_TGT)

q_comp_svdpi_pkg:
	$(HVL_COMP_CMD) $(SVDPI_PKG)

v_comp_svdpi_pkg: q_comp_svdpi_pkg
	$(VELANALYZE_HVL_CMD) $(SVDPI_PKG)

SVC_SO = $(UVMF_HOME)/common/sv_connect/lib/$(LIB_PLATFORM)/sv_connect_vpi.so
SVC_OPTS = +svc_make_so +svc_prefix+svc_

	        #vsim -voptargs="+acc" -permit_unmatched_virtual_intf -pli $(SVC_SO) $(SVC_OPTS) -suppress 3770 $(TOP_HVL) -c -do "quit -f" | tee sv_connect.log
svc_autogenerate:
	        vsim $(GCC_ARG_1) -permit_unmatched_virtual_intf -pli $(SVC_SO) $(SVC_OPTS) -suppress 3770 $(TOP_HVL) -c -do "quit -f" | tee sv_connect.log
