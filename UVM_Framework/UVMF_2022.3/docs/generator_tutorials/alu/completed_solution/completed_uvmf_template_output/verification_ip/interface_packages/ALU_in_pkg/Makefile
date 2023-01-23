# ALU_in interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

ALU_in_PKG         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ALU_in_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ALU_in_pkg/ALU_in_filelist_hvl.f 

ALU_in_PKG_HDL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ALU_in_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ALU_in_pkg/ALU_in_filelist_hdl.f 

COMP_ALU_in_PKG_TGT_0 = q_comp_ALU_in_pkg
COMP_ALU_in_PKG_TGT_1 = v_comp_ALU_in_pkg
COMP_ALU_in_PKG_TGT = $(COMP_ALU_in_PKG_TGT_$(USE_VELOCE))

comp_ALU_in_pkg: $(COMP_ALU_in_PKG_TGT) 
	$(HDL_COMP_CMD) $(ALU_in_PKG_HDL)

q_comp_ALU_in_pkg:
	$(HVL_COMP_CMD) $(ALU_in_PKG) 

v_comp_ALU_in_pkg: q_comp_ALU_in_pkg
	$(VELANALYZE_HVL_CMD) $(ALU_in_PKG) 

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_ALU_in_pkg	= \

O_FILE_COMPILE_LIST_ALU_in_pkg = $(notdir $(C_FILE_COMPILE_LIST_ALU_in_pkg:.c=.o))

GCC_COMP_ARGS_ALU_in_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ALU_in_pkg/dpi \
	-fPIC 

GCC_LINK_ARGS_ALU_in_pkg	+= \
	 \
 	-o .so

comp_ALU_in_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_ALU_in_pkg) $(C_FILE_COMPILE_LIST_ALU_in_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_ALU_in_pkg) $(O_FILE_COMPILE_LIST_ALU_in_pkg)
	@echo "--------------------------------"

