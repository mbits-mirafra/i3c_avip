gen_regs:
	vreguvm -block ahb2spi_reg_block \
   -csvin register_blocks.csv \
   -uvmout ahb2spi_reg_pkg.sv \
   -uvmversion 1.1 

gen_regs_ra:
	$(CERTE_HOME)/registerassistant/regassist -f ctrl.rcf -project .

cp_for_edit:
	cp *.csv ~/Shared/Examples_UVM/.

cp_back:
	cp ~/Shared/Examples_UVM/register_blocks.csv .

clean:
	rm -r ahb2spi_reg_pkg.sv

#../../wb2spi_env_pkg/registers/register_description.csv ../../wb2spi_env_pkg/registers/register_blocks.csv