module hdl_top();
  // pragma attribute hdl_top partition_module_xrtl

  import shared_params_pkg::*;
  
  // Wires
  logic [NUM_CLK_RSTS-1:0] clks;
  logic [NUM_CLK_RSTS-1:0] rst_n;
  logic [NUM_CLK_RSTS-1:0] async_rst;
  
  // Declare the pin interfaces
  genvar                   ii;
  for (ii = 0; ii < NUM_CLK_RSTS; ii++) begin : clk_rst_block
    clock_bfm #(shared_params_pkg::CLK_INIT_HALF_PERIOD_IN_PS,
                shared_params_pkg::CLK_PHASE_OFFSET_IN_PS) clk_if_h(clks[ii]);
    sync_reset_bfm #(shared_params_pkg::RST_POLARITY) rst_if_h(clks[ii],
                                                               rst_n[ii]);
    async_reset_bfm #(shared_params_pkg::ASYNC_RST_POLARITY,
                      shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS * (ii+1),
                      shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS * (ii+1)
                      ) async_rst_if_h(clks[ii], async_rst[ii]);

    initial begin //tbx vif_binding_block
      import uvm_pkg::uvm_config_db;
      uvm_config_db #(virtual clock_bfm #(shared_params_pkg::CLK_INIT_HALF_PERIOD_IN_PS, shared_params_pkg::CLK_PHASE_OFFSET_IN_PS))::set(null, "", $psprintf("clk%0d_if_h", ii), clk_if_h);
      uvm_config_db #(virtual sync_reset_bfm #(shared_params_pkg::RST_POLARITY))::set(null, "", $psprintf("rst%0d_if_h", ii), rst_if_h);
      uvm_config_db #(virtual async_reset_bfm #(
                         shared_params_pkg::ASYNC_RST_POLARITY,
                         shared_params_pkg::ASYNC_INIT_IDLE_TIME_IN_PS * (ii+1),
                         shared_params_pkg::ASYNC_RST_ACTIVE_IN_PS * (ii+1)
                                                ))::set(null, "", $psprintf("async_rst%0d_if_h", ii), async_rst_if_h);
    end 
  end
  
endmodule : hdl_top
