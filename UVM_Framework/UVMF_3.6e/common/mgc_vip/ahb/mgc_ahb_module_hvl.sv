
module mgc_ahb_module_hvl #(
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

`ifdef XRTL

  //
  // Instantiate VTL API interface and bind to corresponding VTL XRTL BFM using given HDL path:
  //
  mgc_ahb #(NUM_MASTERS, NUM_MASTER_BITS, NUM_SLAVES, ADDRESS_WIDTH, WDATA_WIDTH, RDATA_WIDTH) vip_if (1'bz, 1'bz);

  defparam vip_if.i_AHBTBX.SYSTEMSCOPE = {VIP_IF_HDL_PATH, ".vip_bfm.i_xrtlAHBInterface"};

  //
  // Register VTL API interface with UVM config DB using given UVM context and name:
  //
  initial begin
    uvm_pkg::uvm_config_db #(virtual mgc_ahb #(NUM_MASTERS, NUM_MASTER_BITS, NUM_SLAVES, ADDRESS_WIDTH, WDATA_WIDTH, RDATA_WIDTH))::
       set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
  end 

`endif

endmodule: mgc_ahb_module_hvl
