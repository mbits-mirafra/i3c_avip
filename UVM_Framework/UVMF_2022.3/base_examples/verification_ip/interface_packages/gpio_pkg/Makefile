# gpio interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

gpio_PKG         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg/gpio_filelist_hvl.f 

gpio_PKG_HDL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg/gpio_filelist_hdl.f 

gpio_PKG_XRTL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg/gpio_filelist_xrtl.f 

COMP_gpio_PKG_TGT_0 = q_comp_gpio_pkg
COMP_gpio_PKG_TGT_1 = v_comp_gpio_pkg
COMP_gpio_PKG_TGT = $(COMP_gpio_PKG_TGT_$(USE_VELOCE))

comp_gpio_pkg: $(COMP_gpio_PKG_TGT) 

q_comp_gpio_pkg:
	$(HDL_COMP_CMD) $(gpio_PKG_HDL)
	$(HVL_COMP_CMD) $(gpio_PKG)
	$(HDL_COMP_CMD) $(gpio_PKG_XRTL) 

v_comp_gpio_pkg:
	$(HVL_COMP_CMD) $(gpio_PKG_HDL)
	$(HVL_COMP_CMD) $(gpio_PKG)
	$(VELANALYZE_HVL_CMD) $(gpio_PKG_HDL) 
	$(VELANALYZE_HVL_CMD) $(gpio_PKG) 
	$(HDL_COMP_CMD) $(gpio_PKG_XRTL)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_gpio_pkg	= \

O_FILE_COMPILE_LIST_gpio_pkg = $(notdir $(C_FILE_COMPILE_LIST_gpio_pkg:.c=.o))

GCC_COMP_ARGS_gpio_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/interface_packages/gpio_pkg/dpi \
	-fPIC 

GCC_LINK_ARGS_gpio_pkg	+= \
	 \
 	-o .so

comp_gpio_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_gpio_pkg) $(C_FILE_COMPILE_LIST_gpio_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_gpio_pkg) $(O_FILE_COMPILE_LIST_gpio_pkg)
	@echo "--------------------------------"

