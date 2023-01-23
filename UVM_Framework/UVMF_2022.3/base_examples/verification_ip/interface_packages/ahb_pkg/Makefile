# ahb interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

ahb_PKG         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg/ahb_filelist_hvl.f 

ahb_PKG_HDL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg/ahb_filelist_hdl.f 

ahb_PKG_XRTL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg/ahb_filelist_xrtl.f 

COMP_ahb_PKG_TGT_0 = q_comp_ahb_pkg
COMP_ahb_PKG_TGT_1 = v_comp_ahb_pkg
COMP_ahb_PKG_TGT = $(COMP_ahb_PKG_TGT_$(USE_VELOCE))

comp_ahb_pkg: $(COMP_ahb_PKG_TGT) 

q_comp_ahb_pkg:
	$(HDL_COMP_CMD) $(ahb_PKG_HDL)
	$(HVL_COMP_CMD) $(ahb_PKG)
	$(HDL_COMP_CMD) $(ahb_PKG_XRTL) 

v_comp_ahb_pkg:
	$(HVL_COMP_CMD) $(ahb_PKG_HDL)
	$(HVL_COMP_CMD) $(ahb_PKG)
	$(VELANALYZE_HVL_CMD) $(ahb_PKG_HDL) 
	$(VELANALYZE_HVL_CMD) $(ahb_PKG) 
	$(HDL_COMP_CMD) $(ahb_PKG_XRTL)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_ahb_pkg	= \

O_FILE_COMPILE_LIST_ahb_pkg = $(notdir $(C_FILE_COMPILE_LIST_ahb_pkg:.c=.o))

GCC_COMP_ARGS_ahb_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg/dpi \
	-fPIC 

GCC_LINK_ARGS_ahb_pkg	+= \
	 \
 	-o .so

comp_ahb_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_ahb_pkg) $(C_FILE_COMPILE_LIST_ahb_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_ahb_pkg) $(O_FILE_COMPILE_LIST_ahb_pkg)
	@echo "--------------------------------"

