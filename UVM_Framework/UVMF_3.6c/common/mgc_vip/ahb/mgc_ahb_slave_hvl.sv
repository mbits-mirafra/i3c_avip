
module mgc_ahb_slave_hvl #(
   int NUM_MASTERS      = 16,
   int NUM_MASTER_BITS  = 4,
   int NUM_SLAVES       = 32,
   int ADDRESS_WIDTH    = 32,
   int WDATA_WIDTH      = 1024,
   int RDATA_WIDTH      = 1024,
   string VIP_IF_UVM_NAME,
   string VIP_IF_UVM_CONTEXT,
   string VIP_IF_HDL_PATH
);

`include "mgc_ahb_hvl.svh"

endmodule: mgc_ahb_slave_hvl
