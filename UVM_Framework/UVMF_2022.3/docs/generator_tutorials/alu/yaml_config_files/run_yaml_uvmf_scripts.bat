@set QUESTA_ROOT=C:/MentorTools/questasim_2019.2
@set UVMF_HOME=C:/graemej/UVM_FRAMEWORK/UVMF_Repo_2019.4

python %UVMF_HOME%/scripts/yaml2uvmf.py ALU_in_interface.yaml ALU_out_interface.yaml ALU_util_comp_alu_predictor.yaml ALU_environment.yaml ALU_bench.yaml -d ../uvmf_template_output

pause
