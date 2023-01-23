gen_regs:
	vreguvm -block wb2spi_reg_block \
   -csvin register_description.csv register_blocks.csv \
   -uvmout wb2spi_reg_pkg.sv \
   -uvmversion 1.1 

gen_regs_py:
	./wb2spi_registers.py

gen_regs_ra:
	$(CERTE_HOME)/registerassistant/regassist -f ctrl.rcf -project .

clean:
	rm -r wb2spi_reg_pkg.sv
