   //
   // Instantiate VTL API interface and register virtual interface with UVM config DB using given UVM context and name
   //
   mgc_ace #(ADDR_WIDTH, RDATA_WIDTH, WDATA_WIDTH, ID_WIDTH, USER_WIDTH, REGION_MAP_SIZE, SNOOP_DATA_WIDTH, CACHE_LINE_SIZE) vip_if (1'bz, 1'bz);
   //mgc_ace #(PARAMS) vip_if (1'bz, 1'bz);

   initial begin
      uvm_pkg::uvm_config_db #(virtual mgc_ace #(ADDR_WIDTH, RDATA_WIDTH, WDATA_WIDTH, ID_WIDTH, USER_WIDTH, REGION_MAP_SIZE, SNOOP_DATA_WIDTH, CACHE_LINE_SIZE))::
         set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
      //uvm_pkg::uvm_config_db #(virtual mgc_ace #(PARAMS))::set(null, VIP_IF_UVM_CONTEXT, VIP_IF_UVM_NAME, vip_if);
   end
