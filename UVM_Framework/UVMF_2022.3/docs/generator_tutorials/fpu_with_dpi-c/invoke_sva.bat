
@set PWD=%~dp0
@set PWD=%PWD:\=/%
@rem  Remove trailing '/' from %PWD%
IF %PWD:~-1%==/ set PWD=%PWD:~0,-1%
@set MY_PROJ_TOP=%PWD%

@echo " User Name is %USERNAME%"

@rem DEFINE TOOL PATHS HERE
@set SVASSISTANT_HOME=C:/MentorTools/HDS_2020.3/svassistant
@rem @set SVASSISTANT_HOME=C:/MentorTools/aeltayeb_SVA_DRs_2017_1_Main_hint_2017.1_1

@set   QUESTA_ROOT=C:/MentorTools/questasim_10.7b/win32
@set   QUESTA_BIN_DIR=%QUESTA_ROOT%
@set   QUESTA_MVC_HOME=C:/MentorTools/Questa_VIP_10_6a
@set   UVMF_HOME=C:/graemej/UVM_FRAMEWORK/UVMF_3.6h

@rem  set old questa library format
@set   MTI_DEFAULT_LIB_TYPE=0  

@rem   Call the Xilinx env settings
@rem call /fpga_apps/vivado_2016.1/Vivado/2016.1/settings64.sh
set PATH=%PATH%;%SVASSISTANT_HOME%/bin


@rem USER: SPECIFY SV-A PROJECT NAME HERE 
@set TESTBENCH_NAME=fpu_dpi

@rem TOOL PREFERENCES
@set SVA_PREFS_DIR=%MY_PROJ_TOP%preferences/%USERNAME%SVA
@echo ""
@echo " SVA PREFS DIR :::: %SVA_PREFS_DIR%"
@IF NOT EXIST %SVA_PREFS_DIR% (
  @echo "SVA USER PREFS DO NOT EXIST..... Will Copy Defaults"
  @echo " "
  @set TMP1=%MY_PROJ_TOP:/=\%
  @set TMP2=%SVA_PREFS_DIR:/=\%
  @echo "  Copying From..... %TMP1%preferences\defaultSVA"
  @echo "  Copying To  ..... %TMP2%"
@rem  xcopy /E /I %TMP1%preferences\defaultSVA %TMP2%
  @echo " Finished Copying "
) 
@rem xcopy /E /I c:\graemej\ToolNotes\HDL_Designer\SV_Assistant\Auto_Project_Creation\preferences\defaultSVA c:\graemej\ToolNotes\HDL_Designer\SV_Assistant\Auto_Project_Creation\preferences\graemej\SVA

@rem #run sva , create project if it does not exist
@IF NOT EXIST %TESTBENCH_NAME%.svap (
  @echo " AAA  :::    %SVA_ROOT%bin/svassist"
  %SVASSISTANT_HOME%/bin/svassist  -blank -do preferences/sva_project_creation.tcl
) ELSE (
  @echo " BBB "
   %SVASSISTANT_HOME%/bin/svassist  -project %TESTBENCH_NAME%.svap 
)

@rem -vmargs -Dorg.eclipse.equinox.p2.reconciler.dropins.directory=C:/MentorTools/SVA_PluginsDir/plugins