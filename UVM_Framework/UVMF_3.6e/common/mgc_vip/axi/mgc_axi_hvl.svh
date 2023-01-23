
   //
   // Instantiate VTL API interface and register virtual interface with UVM config DB using given UVM context and name
   //
   mgc_axi #(ADDR_WIDTH, RDATA_WIDTH, WDATA_WIDTH, ID_WIDTH) vip_if (1'bz, 1'bz);

   initial begin
      uvm_pkg::uvm_config_db #(virtual mgc_axi #(ADDR_WIDTH, RDATA_WIDTH, WDATA_WIDTH, ID_WIDTH))::
         set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
   end
