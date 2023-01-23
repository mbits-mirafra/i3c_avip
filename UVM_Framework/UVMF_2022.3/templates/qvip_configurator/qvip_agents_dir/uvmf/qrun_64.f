export QVIP_AGENTS_DIR_NAME=$(pwd)

-f qvip_agents_test_filelist.f +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv
hdl_qvip_agents.sv
hvl_qvip_agents.sv
-c
-mvchome ${QUESTA_MVC_HOME}
+nowarnTSCALE -t 1fs
-do "run -all; quit"
+UVM_TESTNAME=qvip_agents_test_base
+SEQ=qvip_agents_vseq_base
