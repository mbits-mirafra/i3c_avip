module mgc_axi_monitor_hvl #(
   int ADDR_WIDTH,
   int RDATA_WIDTH,
   int WDATA_WIDTH,
   int ID_WIDTH,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   string VIP_IF_HDL_PATH
)();

`ifdef XRTL

   `include "mgc_axi_hvl.svh"

   // Bind VTL API interface to VTL XRTL BFM using given HDL path
   defparam vip_if.xMVC_if._monitor_TBX_SCOPE = {VIP_IF_HDL_PATH, ".vip_module"};

`endif

endmodule: mgc_axi_monitor_hvl
