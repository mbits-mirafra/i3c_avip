# spi interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

spi_PKG         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg/spi_filelist_hvl.f 

spi_PKG_HDL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg/spi_filelist_hdl.f 

spi_PKG_XRTL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg/spi_filelist_xrtl.f 

COMP_spi_PKG_TGT_0 = q_comp_spi_pkg
COMP_spi_PKG_TGT_1 = v_comp_spi_pkg
COMP_spi_PKG_TGT = $(COMP_spi_PKG_TGT_$(USE_VELOCE))

comp_spi_pkg: $(COMP_spi_PKG_TGT) 

q_comp_spi_pkg:
	$(HDL_COMP_CMD) $(spi_PKG_HDL)
	$(HVL_COMP_CMD) $(spi_PKG)
	$(HDL_COMP_CMD) $(spi_PKG_XRTL) 

v_comp_spi_pkg:
	$(HVL_COMP_CMD) $(spi_PKG_HDL)
	$(HVL_COMP_CMD) $(spi_PKG)
	$(VELANALYZE_HVL_CMD) $(spi_PKG_HDL) 
	$(VELANALYZE_HVL_CMD) $(spi_PKG) 
	$(HDL_COMP_CMD) $(spi_PKG_XRTL)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_spi_pkg	= \

O_FILE_COMPILE_LIST_spi_pkg = $(notdir $(C_FILE_COMPILE_LIST_spi_pkg:.c=.o))

GCC_COMP_ARGS_spi_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/interface_packages/spi_pkg/dpi \
	-fPIC 

GCC_LINK_ARGS_spi_pkg	+= \
	 \
 	-o .so

comp_spi_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_spi_pkg) $(C_FILE_COMPILE_LIST_spi_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_spi_pkg) $(O_FILE_COMPILE_LIST_spi_pkg)
	@echo "--------------------------------"

