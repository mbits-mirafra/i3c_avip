@set   QUESTA_ROOT=C:/MentorTools/questasim_10.7b
@set   QUESTA_BIN_DIR=%QUESTA_ROOT%
@set   QUESTA_MVC_HOME=C:/MentorTools/Questa_VIP_10_6a
@set   UVMF_HOME=%QUESTA_ROOT%/examples/UVM_Framework/UVMF_3.6h

%QUESTA_ROOT%/win32/vsim -i -do "do compile.do; do run.do"

pause