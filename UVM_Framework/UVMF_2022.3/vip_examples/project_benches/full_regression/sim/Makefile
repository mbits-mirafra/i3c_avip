#mvchome
export AXI4_2X2_FABRIC_QVIP_DIR_NAME ?= ../../../../../../../../verification_ip/environment_packages/axi4_2x2_fabric_qvip_dir/uvmf

MSEED ?= random
COLLAPSE ?= 0

help:
	@echo "make run: Run full regression"
	@echo "make bcr_run: Run full regression with BCR"

run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html

yaml_run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html -GTESTLIST_NAME=testlist.yaml

bcr_run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html -GTESTLIST_NAME=bcr_testlist -GUSE_BCR=1

yaml_bcr_run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html -GTESTLIST_NAME=bcr_testlist.yaml -GUSE_BCR=1

clean:
	rm -rf vrmhtmlreport transcript VRMDATA *.log covhtmlreport *.ucdb
