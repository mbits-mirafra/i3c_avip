# ahb2spi environment packages source and make target

# Include all requisite sub-environment package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/ahb2wb_env_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/wb2spi_env_pkg/Makefile

ahb2spi_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/ahb2spi_env_pkg/registers/ahb2spi_reg_pkg.sv \
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/ahb2spi_env_pkg/ahb2spi_env_pkg.sv

comp_ahb2spi_env_pkg:  comp_ahb2wb_env_pkg  comp_wb2spi_env_pkg 
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/ahb2spi_env_pkg $(ahb2spi_ENV_PKG)
