@set   QUESTA_ROOT=C:/MentorTools/questasim_2019.2
@set   QUESTA_BIN_DIR=%QUESTA_ROOT%
@set   UVMF_HOME=C:/graemej/UVM_FRAMEWORK/UVMF_Repo_2019.4

%QUESTA_ROOT%/win32/vsim -i -do "do compile.do; do run.do"

pause