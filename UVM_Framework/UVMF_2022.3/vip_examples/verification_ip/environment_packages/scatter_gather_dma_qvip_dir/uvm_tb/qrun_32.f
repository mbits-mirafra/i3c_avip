${QUESTA_MVC_HOME}/include/questa_mvc_svapi.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv +define+MAP_PROT_ATTR ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv
+incdir+../config_policies ../config_policies/scatter_gather_dma_qvip_params_pkg.sv
scatter_gather_dma_qvip_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_master.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_slave.sv
default_clk_gen.sv
default_reset_gen.sv
hdl_scatter_gather_dma_qvip.sv
hvl_scatter_gather_dma_qvip.sv
-c
-mvchome ${QUESTA_MVC_HOME}
+nowarnTSCALE -t 1ps
-do "run -all; quit"
+UVM_TESTNAME=scatter_gather_dma_qvip_test_base
+SEQ=scatter_gather_dma_qvip_vseq_base
