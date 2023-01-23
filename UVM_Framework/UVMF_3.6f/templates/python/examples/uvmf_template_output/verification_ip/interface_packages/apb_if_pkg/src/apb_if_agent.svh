//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface UVM agent
// File            : apb_if_agent.svh
//----------------------------------------------------------------------
//     
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class apb_if_agent #( int DATA_WIDTH = 32, int ADDR_WIDTH = 32)extends uvmf_parameterized_agent #(
                    .CONFIG_T(apb_if_configuration #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))),
                    .DRIVER_T(apb_if_driver #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))),
                    .MONITOR_T(apb_if_monitor #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))),
                    .COVERAGE_T(apb_if_transaction_coverage #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))),
                    .TRANS_T(apb_if_transaction #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)))
                    );

  `uvm_component_param_utils (apb_if_agent #(DATA_WIDTH,ADDR_WIDTH) )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
