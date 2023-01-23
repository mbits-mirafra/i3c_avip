
   //
   // Instantiate VTL API interface and register virtual interface with UVM config DB using given UVM context and name
   //
   mgc_axi4 #(ADDR_WIDTH, RDATA_WIDTH, WDATA_WIDTH, ID_WIDTH, USER_WIDTH, REGION_MAP_SIZE) vip_if (1'bz, 1'bz);

   initial begin
      uvm_pkg::uvm_config_db #(virtual mgc_axi4 #(ADDR_WIDTH, RDATA_WIDTH, WDATA_WIDTH, ID_WIDTH, USER_WIDTH, REGION_MAP_SIZE))::
         set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
   end
