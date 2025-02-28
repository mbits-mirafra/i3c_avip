# -s means silent mode
# The command executed along with the output will be displayed on the terminal
# To get only the ouput use 'silent' mode
#
# make target -s


# -n or --just-print 
# The first test I perform on a new makefile target is to invoke make with the --just-print (-n) option. 
# This causes make to read the makefile and print every command it would normally execute to 
# update the target but without executing them.
#
# make target -n


# When you run make with the -i or --ignore-errors flag, 
# errors are ignored in all recipes of all rules. 
# A rule in the makefile for the special target .IGNORE has the same effect, 
# if there are no prerequisites. This is less flexible but sometimes useful.
# When errors are to be ignored, because of -i flag, make treats an error return just like success,
# except that it prints out a message that tells you the status code the shell exited with, 
# and says that the error has been ignored.
#
# make target -i 


.IGNORE:
	compile
	simulate

# WE can also use the target where we WANT the silent mode 
.SILENT:
	compile
	simulate
	usage

# First target will be executed incase the user doesn't mention
# the target to execute
# In this case, usage will be executed
# Usage
usage:
	@echo "";
	@echo "-----------------------------------------------------------------";
	@echo "------------------------- Usage ---------------------------------";
	@echo "";
	@echo "To compile use:"
	@echo "make compile";
	@echo "";
	@echo "To simulate individual test:"
	@echo "make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>";
	@echo "";
	@echo "Example:":
	@echo "make simulate test=base_test uvm_verbosity=UVM_HIGH";
	@echo "";
	@echo "To provide seed number (default is random):"
	@echo "make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL> seed=<value>";
	@echo "";
	@echo "To run regression:"
	@echo "make regression testlist_name=<regression_testlist_name.list>";
	@echo "";
	@echo "Example:":
	@echo "make regression testlist_name=i3c_standard_mode_regression.list";
	@echo "";
	@echo "-----------------------------------------------------------------";
	@echo "-----------------------------------------------------------------";
	@echo "";

all:	
	make clean_compile; make compile; make simulate;
 
#VCS_CMD_RAND    = xrun
#FSDB_DUMP = ./simv +fsdbfile+waves.fsdb
#FSDB_DUMP1 = +vcs+vcdpluson
 
clean_compile: 
	rm -rf *_compile.log *_compile.history xcelium.d
 
clean_simulate: 
	rm -rf *_test
 
compile:
	make clean_compile; 
	#make clean_simulate;
	xrun -c \
	-64 \
	-sv \
	-uvm \
	-access +rwc \
	-elaborate \
	-f ../i3c_compile.f \
	-l i3c_compile.log \
	-top work.hvl_top ../../src/hvl_top/hvl_top.sv \
	-top work.hdl_top ../../src/hdl_top/hdl_top.sv \
	+access+rw \
	-coverage all \
	-sva \
	#-lwdgen

	# -s means silent mode
	#  The command executed along with the output will be displayed on the terminal
	#  To get only the ouput use 'silent' mode
	# make compile_war_err -s
	# or use .SILENT
	make compile_war_err

 
# setting the comamnd for the commmand line argumnet for the test
ifndef test
override test = i3c_base_test
endif
 
# Setting the default seed value to random 
ifndef seed
override seed = random 
endif

# Setting the default uvm_verbosity to UVM_MEDIUM
ifndef uvm_verbosity
override uvm_verbosity = UVM_MEDIUM
endif

ifndef test_folder
override test_folder := $(test)
endif
 
 
simulate:
	mkdir $(test_folder)
 
	xrun -R \
	-64 \
	-sv \
	-uvm \
	-f ../i3c_compile.f \
	+sv_seed=$(seed) \
	+UVM_TESTNAME=$(test) \
	+UVM_VERBOSITY=$(uvm_verbosity) \
	-l $(test_folder)/$(test).log \
	-access +rwc \
	-coverage all \
	-covoverwrite \
	-covtest $(test_folder)/ \
  #+plusarg_ignore \
	#-covreport -covdir ./cov_work -html coverage_html_output
  #-l transcript_vcs.log
	#-access +rwc -waves waves.shm \
	//TODO
	# need to be updated command for coverage, able to generate .ucd file but imc not working
 
	mv *.vcd $(test_folder)/
	# For checking and reporting simulation errors
	make simulate_war_err

 
clean_all:
	make clean_compile;
	make clean_simulate;
 
## For Regression and coverage merge
##
regression:
	#Run compilation
	make compile
	#Run simualtion - regression 
	python regression_handling.py $(testlist_name)
	#	# Get the tests from regression list
	#	grep "_test" ../../src/hvl_top/testlists/i3c_standard_mode_regression.list | grep -v "\#" > reg_list
	#	make simulate test=value #Get the name from regression list
	#	Merge coverage
	#make merge_cov_report
 # make clean
	
## For merge to happen, the coverage names for each test must be different
#merge_cov_report:
#	rm -rf merged_coverage.ucdb merged_cov_html_report
#	# Merging all the coverage
#	vcover merge merged_coverage.ucdb -64 */*.ucdb  
#	#vcover merge mem_cover mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 mem_cov6 mem_cov7 mem_cov8
#	vcover report -html merged_coverage.ucdb -htmldir ./merged_cov_html_report -details
#
#	echo "";
#	echo "-----------------------------------------------------------------";
#	echo "Coverage report: firefox merged_cov_html_report/index.html &"
#	echo "-----------------------------------------------------------------";
#	echo "";

 
compile_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------- Compilation Report --------------------------";
	echo "";
	grep "** " i3c_compile.log;
	echo "";
	grep "Error" i3c_compile.log;
	echo "";
	echo "Log file path: i3c_compile.log"
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

simulate_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-------------------- Simulation Report --------------------------";
	echo "";
	#echo "Simulator Errors";
	#grep "Error" $(test_folder)/$(test).log;
	#echo "";
	#echo "UVM Fatal";
	#grep "UVM_FATAL" $(test_folder)/$(test).log;
	#echo "";
	#echo "UVM Errors";
	#grep "UVM_ERROR" $(test_folder)/$(test).log;
	#echo "";
	#echo "UVM Warnings";
	#grep "UVM_WARNING" $(test_folder)/$(test).log;
	#echo "";
	echo "Testname: $(test)"
	echo "";
	echo "Log file path: $(test_folder)/$(test).log"
	echo "";
	echo "Waveform: simvision $(test_folder)/i3c_avip.vcd &"
	echo "";
	#echo "Coverage report: firefox $(test_folder)/html_cov_report/index.html &"
	#echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

