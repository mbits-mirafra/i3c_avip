module mgc_axi_master_hvl #(
   int ADDR_WIDTH      = 32,
   int RDATA_WIDTH     = 32,
   int WDATA_WIDTH     = 32,
   int ID_WIDTH        = 4,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   string VIP_IF_HDL_PATH
)();

`ifdef XRTL

   `include "mgc_axi_hvl.svh"

   //
   // Bind the VTL API interface to the corresponding VTL XRTL BFM using given HDL path:
   //
   defparam vip_if.xMVC_if.master_TBX_SCOPE = {VIP_IF_HDL_PATH, ".vip_module"};

`endif

endmodule: mgc_axi_master_hvl
