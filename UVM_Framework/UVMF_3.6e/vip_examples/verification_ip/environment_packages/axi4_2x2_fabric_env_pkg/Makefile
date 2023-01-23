# axi4_2x2_fabric environment packages source and make target

# Include all requisite sub-environment package targets for this bench

axi4_2x2_fabric_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/axi4_2x2_fabric_env_pkg/axi4_2x2_fabric_env_pkg.sv

comp_axi4_2x2_fabric_env_pkg: 
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/axi4_2x2_fabric_env_pkg $(axi4_2x2_fabric_ENV_PKG)
