//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface UVM agent
// File            : wb_agent.svh
//----------------------------------------------------------------------
//     
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class wb_agent #( int WB_ADDR_WIDTH = 32, int WB_DATA_WIDTH = 16)extends uvmf_parameterized_agent #(
                    .CONFIG_T(wb_configuration #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))),
                    .DRIVER_T(wb_driver #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))),
                    .MONITOR_T(wb_monitor #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))),
                    .COVERAGE_T(wb_transaction_coverage #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))),
                    .TRANS_T(wb_transaction #(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)))
                    );

  `uvm_component_param_utils (wb_agent #(WB_ADDR_WIDTH,WB_DATA_WIDTH) )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
