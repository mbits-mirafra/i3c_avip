DPI_LINK_PKG_HOME = $(UVMF_HOME)/common/dpi_link_pkg

DPI_LINK_PKG         = \
+incdir+$(DPI_LINK_PKG_HOME) \
$(DPI_LINK_PKG_HOME)/dpi_link_pkg.sv

COMP_DPI_LINK_PKG_TGT_0 = q_comp_dpi_link_pkg
COMP_DPI_LINK_PKG_TGT_1 = v_comp_dpi_link_pkg
COMP_DPI_LINK_PKG_TGT = $(COMP_DPI_LINK_PKG_TGT_$(USE_VELOCE))

comp_dpi_link_pkg: $(COMP_DPI_LINK_PKG_TGT) 
#	$(HDL_COMP_CMD) $(DPI_LINK_PKG)

q_comp_dpi_link_pkg:  dpi_link.o libs
	$(HVL_COMP_CMD) $(DPI_LINK_PKG)

v_comp_dpi_link_pkg: q_comp_dpi_link_pkg
	$(VELANALYZE_HVL_CMD) $(DPI_LINK_PKG)

# include $(UVMF_HOME)/common/dpi_link_pkg/dpi_link_o.mk

#comp_dpi_link_pkg: dpi_link.o libs
#	make_filelist.py $(DPI_LINK_PKG_HOME)/dpi_link_pkg.vinfo 
#	$(HVL_COMP_CMD) -f $(DPI_LINK_PKG_HOME)/dpi_link_pkg.vf

#comp_dpi_link_pkg: dpi_link.o libs
	$(HVL_COMP_CMD) +incdir+$(DPI_LINK_PKG_HOME)/dpi_link_pkg $(DPI_LINK_PKG_HOME)/dpi_link_pkg.sv

dpi_link.o: 
	${GPP} -I $(DPI_LINK_PKG_HOME) -I . -I${QUESTA_HOME}/include -fPIC \
	$(UVMF_HOME)/common/dpi_link_pkg/dpi_link.cpp -shared -o dpi_link.o 

uvmf_tc.o: dpiheader.h
	${GPP} -I $(UVMF_HOME)/common/dpi_link_pkg -I . -I${QUESTA_HOME}/include -fPIC \
	$(UVMF_HOME)/common/dpi_link_pkg/uvmf_tc.cpp -shared -o uvmf_tc.o 

