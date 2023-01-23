# FPU environment packages source and make target

# Include all requisite sub-environment package targets for this bench

FPU_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg/FPU_env_pkg.sv

comp_FPU_env_pkg:   comp_FPU_env_pkg_c_files  
		$(HVL_COMP_CMD) -timescale 1ps/1ps -dpiheader dpiheader.h +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg $(FPU_ENV_PKG)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

C_FILE_COMPILE_LIST_FPU_env_pkg	= \
	$(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg/dpi/myFirstFile.c \

O_FILE_COMPILE_LIST_FPU_env_pkg = $(notdir $(C_FILE_COMPILE_LIST_FPU_env_pkg:.c=.o))

GCC_COMP_ARGS_FPU_env_pkg	+= -I$(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg/dpi \
	-fPIC -c -DPRINT32 -O2

GCC_LINK_ARGS_FPU_env_pkg	+= \
	-shared \
 	-o FPUEnvPkg_CFunctions.so

comp_FPU_env_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Environment C source"
	@echo "--------------------------------"
#	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_FPU_env_pkg) $(C_FILE_COMPILE_LIST_FPU_env_pkg)
#	@echo "--------------------------------"
#	@echo "Linking Environment C objects into a shared object"
#	@echo "--------------------------------"
#	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_FPU_env_pkg) $(O_FILE_COMPILE_LIST_FPU_env_pkg)
	$(HVL_COMP_CMD) -timescale 1ps/1ps -dpiheader dpiheader.h +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg $(FPU_ENV_PKG)
	$(HVL_COMP_CMD) -work work -ccflags "-DPRINT32 -I. -T+incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/FPU_env_pkg/dpi"  $(C_FILE_COMPILE_LIST_FPU_env_pkg)
	@echo "--------------------------------"


