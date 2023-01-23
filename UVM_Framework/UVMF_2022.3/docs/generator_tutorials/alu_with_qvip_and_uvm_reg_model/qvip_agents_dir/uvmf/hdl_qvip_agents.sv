//
// File: hdl_qvip_agents.sv
//
// Generated from Mentor VIP Configurator (20200115)
// Generated using Mentor VIP Library ( 2020.1 : 01/23/2020:13:29 )
//
module hdl_qvip_agents;
    parameter  UNIQUE_ID = "";
    parameter  APB_MASTER_0_ACTIVE = 1;
    parameter  EXT_CLK_RESET = 0;
    import uvm_pkg::*;
    import qvip_agents_params_pkg::*;
    wire                                                      default_clk_gen_CLK;
    wire                                                      default_reset_gen_RESET;
    wire [apb_master_0_params::APB3_PADDR_BIT_WIDTH-1:0]      apb_master_0_PADDR;
    wire [apb_master_0_params::APB3_SLAVE_COUNT-1:0]          apb_master_0_PSEL;
    wire                                                      apb_master_0_PENABLE;
    wire                                                      apb_master_0_PWRITE;
    wire [apb_master_0_params::APB3_PWDATA_BIT_WIDTH-1:0]     apb_master_0_PWDATA;
    wire [apb_master_0_params::APB3_PRDATA_BIT_WIDTH-1:0]     apb_master_0_PRDATA;
    wire                                                      apb_master_0_PREADY;
    wire                                                      apb_master_0_PSLVERR;
    
    generate
        if ( EXT_CLK_RESET == 0 )
        begin: generate_internal_clk_rst
            default_clk_gen default_clk_gen
            (
                .CLK(default_clk_gen_CLK)
            );
            default_reset_gen default_reset_gen
            (
                .RESET(default_reset_gen_RESET),
                .CLK_IN(default_clk_gen_CLK)
            );
        end
    endgenerate
    generate
        if ( APB_MASTER_0_ACTIVE )
        begin: generate_active_apb_master_0
            apb_master 
            #(
                .SLAVE_COUNT(apb_master_0_params::APB3_SLAVE_COUNT),
                .ADDR_WIDTH(apb_master_0_params::APB3_PADDR_BIT_WIDTH),
                .WDATA_WIDTH(apb_master_0_params::APB3_PWDATA_BIT_WIDTH),
                .RDATA_WIDTH(apb_master_0_params::APB3_PRDATA_BIT_WIDTH),
                .IF_NAME({UNIQUE_ID,"apb_master_0"}),
                .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
            )
            apb_master_0
            (
                .PCLK(default_clk_gen_CLK),
                .PRESETn(default_reset_gen_RESET),
                .PADDR(apb_master_0_PADDR),
                .PSEL(apb_master_0_PSEL),
                .PENABLE(apb_master_0_PENABLE),
                .PWRITE(apb_master_0_PWRITE),
                .PWDATA(apb_master_0_PWDATA),
                .PRDATA(apb_master_0_PRDATA),
                .PREADY(apb_master_0_PREADY),
                .PSLVERR(apb_master_0_PSLVERR),
                .PPROT(),
                .PSTRB()
            );
        end
        else
        begin: generate_passive_apb_master_0_monitor
            apb_monitor 
            #(
                .SLAVE_COUNT(apb_master_0_params::APB3_SLAVE_COUNT),
                .ADDR_WIDTH(apb_master_0_params::APB3_PADDR_BIT_WIDTH),
                .WDATA_WIDTH(apb_master_0_params::APB3_PWDATA_BIT_WIDTH),
                .RDATA_WIDTH(apb_master_0_params::APB3_PRDATA_BIT_WIDTH),
                .IF_NAME({UNIQUE_ID,"apb_master_0"}),
                .PATH_NAME("UVMF_VIRTUAL_INTERFACES")
            )
            apb_master_0
            (
                .PCLK(default_clk_gen_CLK),
                .PRESETn(default_reset_gen_RESET),
                .PADDR(apb_master_0_PADDR),
                .PSEL(apb_master_0_PSEL),
                .PENABLE(apb_master_0_PENABLE),
                .PWRITE(apb_master_0_PWRITE),
                .PWDATA(apb_master_0_PWDATA),
                .PRDATA(apb_master_0_PRDATA),
                .PREADY(apb_master_0_PREADY),
                .PSLVERR(apb_master_0_PSLVERR),
                .PPROT(),
                .PSTRB()
            );
        end
    endgenerate

endmodule: hdl_qvip_agents
