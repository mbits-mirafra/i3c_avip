
// Input Parameters:
// SLAVE_COUNT   - Indicates number of slaves.
// ADDR_WIDTH    - Indicates address bus width.
// WDATA_WIDTH   - Indicates write data bus width.
// RDATA_WIDTH   - Indicates read data bus width.
// IF_NAME       - Indicates interface name for which this module will be instantiated.
// SCOPE         - Indicates the hierarchical path of hdl_wrapper instantiated in user hdl_top.

module apb_monitor_hvl_wrapper #( SLAVE_COUNT   = 1,
                                 ADDR_WIDTH    = 32,
                                 WDATA_WIDTH   = 32,
                                 RDATA_WIDTH   = 32,
                                 string IF_NAME = "null",
                                 string PATH_NAME ="uvm_test_top",
                     string SCOPE = "")
                               ();
  `ifdef USE_VTL
     import uvm_pkg::*;
     `include "uvm_macros.svh"
     string scope_name = {{SCOPE},".apb3_monitor"};

     typedef virtual mgc_apb3 #(SLAVE_COUNT,
                                ADDR_WIDTH,
                                WDATA_WIDTH,
                                RDATA_WIDTH) apb3_if_t;

     mgc_apb3 #(SLAVE_COUNT,
                ADDR_WIDTH,
                WDATA_WIDTH,
                RDATA_WIDTH) apb3_monitor_if(clk, rst_n);

     initial begin
       uvm_config_db #(apb3_if_t)::set(null,PATH_NAME,IF_NAME, apb3_monitor_if);
     end
 
     initial begin
       $display("SCOPE_NAME = %s",scope_name);
       apb3_monitor_if.mon_init(scope_name);
     end
  `endif
endmodule

