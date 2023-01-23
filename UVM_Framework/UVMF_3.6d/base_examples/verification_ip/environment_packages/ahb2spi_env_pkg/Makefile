# Package make targets
AHB2SPI_ENV_PKG =\
+incdir+$(UVMF_HOME)/base_examples/verification_ip/environment_packages/ahb2spi_env_pkg \
$(UVMF_HOME)/base_examples/verification_ip/environment_packages/ahb2spi_env_pkg/registers/ahb2spi_reg_pkg.sv \
$(UVMF_HOME)/base_examples/verification_ip/environment_packages/ahb2spi_env_pkg/ahb2spi_env_pkg.sv

comp_ahb2spi_env_pkg:
	$(HVL_COMP_CMD) $(AHB2SPI_ENV_PKG)

