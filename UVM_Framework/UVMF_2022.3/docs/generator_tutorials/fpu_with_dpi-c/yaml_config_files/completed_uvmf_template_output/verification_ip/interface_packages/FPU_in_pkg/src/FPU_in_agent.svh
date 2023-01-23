//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface UVM agent
// File            : FPU_in_agent.svh
//----------------------------------------------------------------------
//     
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_in_agent #( int FP_WIDTH = 32)extends uvmf_parameterized_agent #(
                    .CONFIG_T(FPU_in_configuration #(.FP_WIDTH(FP_WIDTH))),
                    .DRIVER_T(FPU_in_driver #(.FP_WIDTH(FP_WIDTH))),
                    .MONITOR_T(FPU_in_monitor #(.FP_WIDTH(FP_WIDTH))),
                    .COVERAGE_T(FPU_in_transaction_coverage #(.FP_WIDTH(FP_WIDTH))),
                    .TRANS_T(FPU_in_transaction #(.FP_WIDTH(FP_WIDTH)))
                    );

  `uvm_component_param_utils (FPU_in_agent #(FP_WIDTH) )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
