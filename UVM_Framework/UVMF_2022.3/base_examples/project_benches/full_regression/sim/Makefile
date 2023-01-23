#mvchome

MSEED ?= random
COLLAPSE ?= 0

bcr_run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html -GUSE_BCR=1 -GTESTLIST_NAME=bcr_testlist

run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html

yaml_bcr_run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html -GUSE_BCR=1 -GTESTLIST_NAME=bcr_testlist.yaml

yaml_run: clean
	vrun -rmdb $(UVMF_HOME)/scripts/default.rmdb -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED) -html -GTESTLIST_NAME=testlist.yaml

clean:
	rm -rf vrmhtmlreport transcript VRMDATA *.log covhtmlreport *.ucdb
