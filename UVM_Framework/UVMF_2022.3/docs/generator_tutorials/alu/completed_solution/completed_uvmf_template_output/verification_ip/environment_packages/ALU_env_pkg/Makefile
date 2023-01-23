# ALU environment packages source and make target

# pragma uvmf custom additional begin
# pragma uvmf custom additional end

# Include all requisite sub-environment package targets for this bench

ALU_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/ALU_env_pkg/ALU_env_pkg.sv

comp_ALU_env_pkg:   
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/ALU_env_pkg $(ALU_ENV_PKG)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_ALU_env_pkg	= \

O_FILE_COMPILE_LIST_ALU_env_pkg = $(notdir $(C_FILE_COMPILE_LIST_ALU_env_pkg:.c=.o))

GCC_COMP_ARGS_ALU_env_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/environment_packages/ALU_env_pkg/dpi \
	-fPIC 

GCC_LINK_ARGS_ALU_env_pkg	+= \
	 \
 	-o .so

comp_ALU_env_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Environment C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_ALU_env_pkg) $(C_FILE_COMPILE_LIST_ALU_env_pkg)
	@echo "--------------------------------"
	@echo "Linking Environment C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_ALU_env_pkg) $(O_FILE_COMPILE_LIST_ALU_env_pkg)
	@echo "--------------------------------"

