ifneq ($(DPI_LINK_DEFINED),dpi_link_defined)
DPI_LINK_DEFINED=dpi_link_defined


dpi_link.o: $(UVMF_HOME)/common/dpi_link_pkg/dpi_link.cpp $(UVMF_HOME)/common/dpi_link_pkg/*.h 
	${GPP} -I $(UVMF_HOME)/common/dpi_link_pkg -I . -I${QUESTA_HOME}/include -fPIC $(UVMF_HOME)/common/dpi_link_pkg/dpi_link.cpp -shared -o dpi_link.o 

endif
