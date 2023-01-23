# ahb2wb environment packages source and make target

# Include all requisite sub-environment package targets for this bench

ahb2wb_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/ahb2wb_env_pkg/ahb2wb_env_pkg.sv

comp_ahb2wb_env_pkg: 
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/ahb2wb_env_pkg $(ahb2wb_ENV_PKG)
