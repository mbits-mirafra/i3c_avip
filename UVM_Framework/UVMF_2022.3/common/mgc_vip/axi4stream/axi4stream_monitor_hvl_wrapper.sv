
// Input Parameters:
// IF_NAME       - Indicates interface name for which this module will be instantiated.
// SCOPE         - Indicates the hierarchical path of hdl_wrapper instantiated in user hdl_top.

module axi4stream_monitor_hvl_wrapper # (int    AXI4_ID_WIDTH = 8,
                                         int    AXI4_USER_WIDTH = 4,
                                         int    AXI4_DEST_WIDTH = 4,
                                         int    AXI4_DATA_WIDTH = 32,
                                         string IF_NAME = "null",
                                         string PATH_NAME ="uvm_test_top",
                                         string SCOPE = "")
  ();

`ifdef USE_VTL
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  string scope_name = {{SCOPE},".monitor"};

  typedef virtual mgc_axi4stream #(AXI4_ID_WIDTH,
                                   AXI4_USER_WIDTH,
                                   AXI4_DEST_WIDTH,
                                   AXI4_DATA_WIDTH ) axi4stream_if_t;  

  // Instantiating the axi4stream interface
  mgc_axi4stream #( AXI4_ID_WIDTH,
                    AXI4_USER_WIDTH,
                    AXI4_DEST_WIDTH,
                    AXI4_DATA_WIDTH ) axi4stream_monitor_if(ACLK, ARESETn);  

  initial 
  begin
    uvm_config_db #( axi4stream_if_t )::set(null,PATH_NAME, IF_NAME , axi4stream_monitor_if);       
  end
 
  initial begin
    $display("SCOPE_NAME = %s",scope_name);
    axi4stream_monitor_if.mon_init(scope_name);
  end
`endif

endmodule

