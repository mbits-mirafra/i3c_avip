export SCATTER_GATHER_DMA_QVIP_DIR_NAME=$(pwd)

-f scatter_gather_dma_qvip_test_filelist.f +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv
hdl_scatter_gather_dma_qvip.sv
hvl_scatter_gather_dma_qvip.sv
-c
-mvchome ${QUESTA_MVC_HOME}
+nowarnTSCALE -t 1ps
-do "run -all; quit"
+UVM_TESTNAME=scatter_gather_dma_qvip_test_base
+SEQ=scatter_gather_dma_qvip_vseq_base
