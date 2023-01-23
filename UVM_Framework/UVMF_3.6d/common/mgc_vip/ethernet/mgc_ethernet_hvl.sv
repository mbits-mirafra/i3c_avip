module mgc_ethernet_hvl #(
   string VIP_IF_UVM_NAME = " ",  // Cannot be empty string or else: # UVM_ERROR @ 0: reporter [RNFNAME] Resrouce named  not found in name map; cannot change its search priority
   string VIP_IF_UVM_CONTEXT = "",
   string VIP_IF_HDL_PATH
   //int NUM_OF_LANES = 4,
)();

`ifdef XRTL

   //
   // Instantiate VTL API interface and register virtual interface with UVM config DB using given UVM context and name
   //
   //mgc_ethernet vip_if (1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
   mgc_ethernet vip_if (1'bz);

   static int dummy = vip_if.init({VIP_IF_HDL_PATH, ".vip_mod"});

//`ifdef USE_UVM
   initial uvm_pkg::uvm_config_db #(virtual mgc_ethernet)::set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
//`endif

`endif

endmodule: mgc_ethernet_hvl
