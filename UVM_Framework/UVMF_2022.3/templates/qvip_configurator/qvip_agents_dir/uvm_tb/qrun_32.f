${QUESTA_MVC_HOME}/include/questa_mvc_svapi.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv +define+MAP_PROT_ATTR ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv 
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie ${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie/mgc_pcie_v2_0_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3/mgc_apb3_v1_0_pkg.sv
+incdir+../config_policies ../config_policies/qvip_agents_params_pkg.sv
qvip_agents_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/pcie/modules/pcie_ep_serial.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_master.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_slave.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/apb3/modules/apb_master.sv
default_clk_gen.sv
default_reset_gen.sv
hdl_qvip_agents.sv
hvl_qvip_agents.sv
-c
-mvchome ${QUESTA_MVC_HOME}
+nowarnTSCALE -t 1fs
-do "run -all; quit"
+UVM_TESTNAME=qvip_agents_test_base
+SEQ=qvip_agents_vseq_base
