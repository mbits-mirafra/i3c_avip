# wb interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

wb_PKG         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_hvl.f 

wb_PKG_HDL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_hdl.f 

wb_PKG_XRTL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/wb_filelist_xrtl.f 

COMP_wb_PKG_TGT_0 = q_comp_wb_pkg
COMP_wb_PKG_TGT_1 = v_comp_wb_pkg
COMP_wb_PKG_TGT = $(COMP_wb_PKG_TGT_$(USE_VELOCE))

comp_wb_pkg: $(COMP_wb_PKG_TGT) 

q_comp_wb_pkg:
	$(HDL_COMP_CMD) $(wb_PKG_HDL)
	$(HVL_COMP_CMD) $(wb_PKG)
	$(HDL_COMP_CMD) $(wb_PKG_XRTL) 

v_comp_wb_pkg:
	$(HVL_COMP_CMD) $(wb_PKG_HDL)
	$(HVL_COMP_CMD) $(wb_PKG)
	$(VELANALYZE_HVL_CMD) $(wb_PKG_HDL) 
	$(VELANALYZE_HVL_CMD) $(wb_PKG) 
	$(HDL_COMP_CMD) $(wb_PKG_XRTL)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_wb_pkg	= \

O_FILE_COMPILE_LIST_wb_pkg = $(notdir $(C_FILE_COMPILE_LIST_wb_pkg:.c=.o))

GCC_COMP_ARGS_wb_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/interface_packages/wb_pkg/dpi \
	-fPIC 

GCC_LINK_ARGS_wb_pkg	+= \
	 \
 	-o .so

comp_wb_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_wb_pkg) $(C_FILE_COMPILE_LIST_wb_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_wb_pkg) $(O_FILE_COMPILE_LIST_wb_pkg)
	@echo "--------------------------------"

