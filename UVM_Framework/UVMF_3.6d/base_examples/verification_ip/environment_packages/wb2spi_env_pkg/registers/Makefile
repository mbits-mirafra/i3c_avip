gen_regs:
	vreguvm -block wb2spi_reg_block \
   -csvin register_description.csv register_blocks.csv \
   -uvmout wb2spi_reg_pkg.sv \
   -uvmversion 1.1 

gen_regs_py:
	#setenv PYTHONPATH /home/mhorn/uvm_misc/framework/templates/python:/home/mhorn/uvm_misc/reg_gen
	./wb2spi_registers.py

gen_regs_ra:
	$(CERTE_HOME)/registerassistant/regassist -f ctrl.rcf -project .

cp_for_edit:
	cp *.csv ~/Shared/Examples_UVM/.

cp_back:
	cp ~/Shared/Examples_UVM/register_blocks.csv .
	cp ~/Shared/Examples_UVM/register_description.csv .

clean:
	rm -r wb2spi_reg_pkg.sv
