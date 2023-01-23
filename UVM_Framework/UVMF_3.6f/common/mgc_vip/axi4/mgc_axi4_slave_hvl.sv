module mgc_axi4_slave_hvl #(
   int ADDR_WIDTH      = 32,
   int RDATA_WIDTH     = 32,
   int WDATA_WIDTH     = 32,
   int ID_WIDTH        = 4,
   int USER_WIDTH      = 4,
   int REGION_MAP_SIZE = 16,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   string VIP_IF_HDL_PATH
)();

`ifdef XRTL

   `include "mgc_axi4_hvl.svh"

   //
   // Bind the VTL API interface to the corresponding VTL XRTL BFM using given HDL path
   //
   defparam vip_if.xMVC_if.slave_TBX_SCOPE = {VIP_IF_HDL_PATH, ".vip_module"};

`endif

endmodule: mgc_axi4_slave_hvl
