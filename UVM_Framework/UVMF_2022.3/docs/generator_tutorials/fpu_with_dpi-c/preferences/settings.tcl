proc config_proj_settings {} {
	 # import file path settings
	eval ::setAllowSofteningPaths 1 $::env(TESTBENCH_NAME) 1
	eval ::setUseRelativePaths 1 $::env(TESTBENCH_NAME) 2
	 # Define allowed environment variables to use in file soft paths
	::setEnvVariablesNamesForSofteningPaths {MY_PROJ_TOP QUESTA_MVC_HOME QUESTA_ROOT SVASSISTANT_HOME} $::env(TESTBENCH_NAME)

	eval ::setBuildProvider QuestaSim $::env(TESTBENCH_NAME)
	eval ::setLocationForNewFiles "$::env(MY_PROJ_TOP)" "$::env(TESTBENCH_NAME)"
	eval ::setPromptBuildManagerWarnings 0
	::setQuestaBinDir  {$(QUESTA_ROOT)}  $::env(TESTBENCH_NAME)
	 # User Code Templates
	eval ::setTemplateProjectLocation $::env(MY_PROJ_TOP)/preferences/Templates/selextemplates.svap "$::env(TESTBENCH_NAME)"
	eval ::setUnixHTMLViewerCommand firefox
	 # specify the build directory location
	eval ::setMakeInvocationDir $::env(MY_PROJ_TOP)/build $::env(TESTBENCH_NAME)

	 # Define plusargs before importing any files or you get a GUI prompt asking you to reload the project
	eval ::setPlusArgs {+define+MODEL_TECH} $::env(TESTBENCH_NAME)
} 

proc config_questa_settings {using_qvip} {
	#  Define the Questa preferneces required for UVM Framework/QVIP simulation
	if {$using_qvip == 1} {
	     # -mvchome switch is specified and passed value of env variable $QUESTA_MVC_HOME
		::editBuildVariableOp $::env(TESTBENCH_NAME) {Questasim} {Questa vsim} {QUESTA_VSIM_OPTIONS} {-l transcript.txt -i -voptargs=+acc -sv_seed random +UVM_VERBOSITY=UVM_HIGH -permit_unmatched_virtual_intf +notimingchecks -suppress 8887 -mvchome $(QUESTA_MVC_HOME) -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 work.hvl_top}
	} else {
	     # Does not pass -mvchome switch to vsim which requires $QUESTA_MVC_HOME to be set
	::editBuildVariableOp $::env(TESTBENCH_NAME) {Questasim} {Questa vsim} {QUESTA_VSIM_OPTIONS} {-l transcript.txt -i -voptargs=+acc -sv_seed random +UVM_VERBOSITY=UVM_HIGH -permit_unmatched_virtual_intf +notimingchecks -suppress 8887 -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 work.hvl_top}	
	}
	::editBuildVariableOp $::env(TESTBENCH_NAME) {Questasim} {Questa vsim} {SVASSIST_DEBUG} {-do 'set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; set PrefSource(OpenOnBreak) 0; radix hex showbase;'}
	::editBuildVariableOp $::env(TESTBENCH_NAME) {QuestaSim} {Questa vlog}  QUESTA_VLOG_OPTIONS {-incr -suppress 2167,2263 -nologo -timescale 1ps/1ps}
	::editBuildVariableOp $::env(TESTBENCH_NAME) {QuestaSim} {Questa vopt}  TIME_RES {-t ps}
	::editBuildVariableOp $::env(TESTBENCH_NAME) {QuestaSim} {Questa vsim}  TIME_RES {-t ps}
}

####################################
## Create Blank Project
####################################
eval ::createNewProjectOp $::env(TESTBENCH_NAME) {$::env(MY_PROJ_TOP)}

####################################
## General Project Preferences
####################################
 # Call procedure to configure general SV-A project settings
 # Would not expect user to have to change these
config_proj_settings


####################################
## IMPORT DESIGN LIBRARIES
####################################
  ## Import the UVM Base Class Library 	
eval ::setImportFilesetInProject UVM_1.1d "$env(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src" 0 $::env(TESTBENCH_NAME)
eval ::setUsePrecompiledOvmLibrary 1 $::env(TESTBENCH_NAME)

  ## Import customer TCL for import of UVMF & QVIP Base libraries plus user testbench
source preferences/sva_import_procs.tcl

  ## Import the UVMF Base Class Library  :: Relies on $UVMF_HOME being set
  puts "\n\tIMPORTING THE UVM BASE CLASS LIBRARIES Makefile...." 
  import_uvmf
  puts "\n\tUVM BASE CLASS LIBRARIES import complete." 


  ## Import the customer UVMF testbench.  Pass 3 parameters :  
  ##    1.  Top Virtual Folder Name
  ##    2.  Root directory where source code to be imported from
  ##    3.  File that specifies which folders to import
  puts "\n\tIMPORTING THE USER DESIGN...." 
  ##import_design zz_ALU_UVMF_TB $env(MY_PROJ_TOP)/design_src preferences/uvmf_ex2_alu.f
  ##import_design zz_ALU_UVMF_TB $env(MY_PROJ_TOP)/design_src *
  import_design zz_AHB2SPI_UVMF_TB $env(MY_PROJ_TOP)/design_src2 *
  puts "\n\tUSER DESIGN import complete."
  
  ## import QVIP base library :: Relies on $QUESTA_MVC_HOME being set plus a test file called questa_qvip_files.f in the preferences folder which specifies the folders to import
  ## puts "\n\tIMPORTING THE QVIP BASE LIBRARY...." 
  ## import_qvip
  ## puts "\n\tQVIP BASE LIbRARY import complete."

####################################
## SPECIFY QUESTA SETTINGS
####################################
  # Set flag to indicate if using QVIP (0=No;  1=Yes)
 set using_qvip 0
 # call procedure to define Questa settings
config_questa_settings $using_qvip

  ## Regenerate the Makefile
puts "\n\tREGENERATING THE Makefile...."  
::generateMakefileOp $::env(TESTBENCH_NAME)
puts "\n\tMakefile Generation Complete...."  

  ## Compile the Entire Project  :  Needed to compile hvl_top
puts "\n\tCOMPILING THE PROJECT...."  
::buildProjectOp $::env(TESTBENCH_NAME)
puts "\n\tProject Compilation Complete."  




