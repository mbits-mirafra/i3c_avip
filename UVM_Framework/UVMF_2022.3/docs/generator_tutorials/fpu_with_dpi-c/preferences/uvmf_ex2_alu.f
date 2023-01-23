# Blank lines are ignored
# Use 1 x TAB character to indicate each depth level of the directory hierarchy to be imported
project_benches
	alu
		rtl *
		tb *
verification_ip
	environment_packages
		alu_env_pkg *
	interface_packages
		alu_in_pkg *
		alu_out_pkg *