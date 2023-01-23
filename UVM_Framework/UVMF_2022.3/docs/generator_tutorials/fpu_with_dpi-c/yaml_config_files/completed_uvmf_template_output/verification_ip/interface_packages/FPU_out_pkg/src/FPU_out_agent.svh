//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface UVM agent
// File            : FPU_out_agent.svh
//----------------------------------------------------------------------
//     
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_out_agent extends uvmf_parameterized_agent #(
                    .CONFIG_T(FPU_out_configuration ),
                    .DRIVER_T(FPU_out_driver ),
                    .MONITOR_T(FPU_out_monitor ),
                    .COVERAGE_T(FPU_out_transaction_coverage ),
                    .TRANS_T(FPU_out_transaction )
                    );

  `uvm_component_utils( FPU_out_agent )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
