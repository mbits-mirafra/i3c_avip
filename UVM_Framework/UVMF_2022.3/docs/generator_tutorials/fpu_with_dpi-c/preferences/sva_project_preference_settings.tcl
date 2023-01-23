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
	 # User Code Templates [not working in 2016.1]
	eval ::setTemplateProjectLocation $::env(MY_PROJ_TOP)/preferences/Templates-Generic/company_template.svap "$::env(TESTBENCH_NAME)"
   # ::TemplateApi::setTmplVariableOp -templateName "company_header.svt" -varName “COMPANY_NAME” -varValue "AAAA_Company"
   # ::TemplateApi::setTmplVariableOp -templateName "file_header.svt" -varName “COMPANY_NAME” -varValue "AAAA_Company"
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
	::editBuildVariableOp $::env(TESTBENCH_NAME) {QuestaSim} {Questa vlog}  QUESTA_VLOG_OPTIONS {-incr -suppress 2167,2263 -nologo}

}