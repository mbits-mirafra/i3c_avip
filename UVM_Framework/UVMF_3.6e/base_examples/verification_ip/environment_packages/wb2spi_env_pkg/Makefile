# wb2spi environment packages source and make target

# Include all requisite sub-environment package targets for this bench

wb2spi_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/wb2spi_env_pkg/registers/wb2spi_reg_pkg.sv \
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/wb2spi_env_pkg/wb2spi_env_pkg.sv \

comp_wb2spi_env_pkg: 
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/wb2spi_env_pkg $(wb2spi_ENV_PKG)
