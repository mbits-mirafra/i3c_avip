@set QUESTA_ROOT=C:/MentorTools/questasim_10.7b
@set UVMF_HOME=%QUESTA_ROOT%/examples/UVM_Framework/UVMF_3.6h

python %UVMF_HOME%/scripts/yaml2uvmf.py FPU_in_interface.yaml FPU_out_interface.yaml FPU_predictor.yaml FPU_environment.yaml FPU_bench.yaml -d uvmf_template_output

pause
