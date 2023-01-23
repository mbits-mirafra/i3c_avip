$QUESTA_MVC_HOME/include/questa_mvc_svapi.svh
+define+MAP_PROT_ATTR $QUESTA_MVC_HOME/questa_mvc_src/sv/mvc_pkg.sv
$UVMF_HOME/common/fli_pkg/*.sv
$UVMF_HOME/uvmf_base_pkg/uvmf_base_pkg_hdl.sv
$UVMF_HOME/uvmf_base_pkg/uvmf_base_pkg.sv
+incdir+$QUESTA_MVC_HOME/questa_mvc_src/sv/axi4 $QUESTA_MVC_HOME/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv
$AXI4_2X2_FABRIC_QVIP_DIR_NAME/../config_policies/axi4_2x2_fabric_qvip_params_pkg.sv
$AXI4_2X2_FABRIC_QVIP_DIR_NAME/axi4_2x2_fabric_qvip_pkg.sv
+incdir+$QUESTA_MVC_HOME/questa_mvc_src/sv/axi4/modules $QUESTA_MVC_HOME/questa_mvc_src/sv/axi4/modules/axi4_master.sv
+incdir+$QUESTA_MVC_HOME/questa_mvc_src/sv/axi4/modules $QUESTA_MVC_HOME/questa_mvc_src/sv/axi4/modules/axi4_slave.sv
$AXI4_2X2_FABRIC_QVIP_DIR_NAME/default_clk_gen.sv
$AXI4_2X2_FABRIC_QVIP_DIR_NAME/default_reset_gen.sv
