# gpio_example environment packages source and make target

# Include all requisite sub-environment package targets for this bench

gpio_example_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/gpio_example_env_pkg/gpio_example_env_pkg.sv

comp_gpio_example_env_pkg: 
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/gpio_example_env_pkg $(gpio_example_ENV_PKG)
