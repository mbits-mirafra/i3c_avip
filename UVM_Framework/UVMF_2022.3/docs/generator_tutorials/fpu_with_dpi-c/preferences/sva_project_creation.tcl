
####################################
## Import SV-A TCL Utility procedures
####################################
  ## Import TCL for standard SV-A Projet settings when using UVMF and QVIP
source preferences/sva_project_preference_settings.tcl
  ## Import customer TCL for import of UVMF & QVIP Base libraries plus user testbench code
source preferences/sva_import_procs.tcl

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
## IMPORT UVM BASE LIBRARIES
####################################
  ## Import the UVM Base Class Library 	
eval ::setImportFilesetInProject UVM_1.1d "$env(SVASSISTANT_HOME)/resources/lib/svassist_uvm_src/UVM_1.1d/src" 0 $::env(TESTBENCH_NAME)
eval ::setUsePrecompiledOvmLibrary 1 $::env(TESTBENCH_NAME)


######################################
## IMPORT UVM FRAMEWORK BASE LIBRARIES
######################################
  ## Import the UVMF Base Class Library  :: Relies on $UVMF_HOME being set
  ## Will create a virtual folder using the UVMF version number that $UVMF_HOME is pointing to
puts "\n\tIMPORTING THE UVM BASE CLASS LIBRARIES Makefile...." 
import_uvmf
puts "\n\tUVM BASE CLASS LIBRARIES import complete." 


######################################
## IMPORT QVIP BASE LIBRARIES
######################################
  # Set flag to indicate if using QVIP (0=No;  1=Yes)
 set using_qvip 0
 ## import QVIP base library :: Relies on $QUESTA_MVC_HOME being set plus a test file called questa_qvip_files.f in the preferences folder which specifies the folders to import
 ## Uncomment the 3 lines below
 # puts "\n\tIMPORTING THE QVIP BASE LIBRARY...." 
 # import_qvip
 # puts "\n\tQVIP BASE LIbRARY import complete."


######################################
## IMPORT USER'S UVMF TESTBENCH SOURCE
######################################
  ## Import the customer UVMF testbench.  Pass 3 parameters :  
  ##    1.  Top Virtual Folder Name
  ##    2.  Root directory where source code to be imported from
  ##    3.  File that specifies which folders to import
  puts "\n\tIMPORTING THE USER DESIGN...." 
  ## Ex 1  : import from file
  ## import_design zz_ALU_UVMF_TB $env(MY_PROJ_TOP)/design_src preferences/uvmf_ex2_alu.f

  ## Ex 2  : import from specified root directory
  import_design zz_ALU_UVMF_TB $env(MY_PROJ_TOP)/uvmf_template_output *
  
  ## Ex 3  : import from alternative root directory
  ##import_design zz_AHB2SPI_UVMF_TB $env(MY_PROJ_TOP)/design_src2 *
  puts "\n\tUSER DESIGN import complete."
  

####################################
## SPECIFY QUESTA SETTINGS
####################################
 # call procedure to define Questa settings
 # parameter $using_qvip  defines if QVIP is being used (0=no, 1=yes)
config_questa_settings $using_qvip


####################################
## COMPILE THE SV-A PROJECT
####################################
  ## Regenerate the Makefile
puts "\n\tREGENERATING THE Makefile...."  
::generateMakefileOp $::env(TESTBENCH_NAME)
puts "\n\tMakefile Generation Complete...."  
  ## Compile the Entire Project  :  Needed to compile hvl_top
puts "\n\tCOMPILING THE PROJECT...."  
::buildProjectOp $::env(TESTBENCH_NAME)
puts "\n\tProject Compilation Complete."  




