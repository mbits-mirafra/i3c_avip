TAR_VERSION=$(shell cat version)

tar: clean
	cd ..; tar zcvf uvm_co-emulation_utilities-$(TAR_VERSION).tgz uvm_co-emulation_utilities \
     --exclude uvm_co-emulation_utilities/.git \
     --exclude uvm_co-emulation_utilities/.gitignore \
     --exclude uvm_co-emulation_utilities/UVM_Co-Emulation_Utility_Library_Pictures.graffle \
     --exclude uvm_co-emulation_utilities/UVM_Co-Emulation_Utility_Library_User_Guide.docx \
     --exclude uvm_co-emulation_utilities/Co-Emulation_Utilities.pptx \
     --exclude *modelsim.ini \
     --exclude *tbxbindings.h \
     --exclude *veloce.map \
     --exclude *veloce.med \
     --exclude *veloce.log \
     --exclude *velrunopts.ini \
     --exclude *work \
     --exclude *design.bin \
     --exclude *wave.db \
     --exclude *.log \
     --exclude *.DS_Store \
     --exclude *.project

clean:
	cd tests/clock_tester/sim; make clean
	cd tests/reg_access_file_test; make clean
	find . -name "*~" -delete
	find . -name "#*#" -delete
