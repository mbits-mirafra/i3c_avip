//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: Protocol specific agent class definition
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class alu_out_agent #(
     int ALU_OUT_RESULT_WIDTH = 16
     ) extends uvmf_parameterized_agent #(
                    .CONFIG_T(alu_out_configuration #(
                              .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                              )),
                    .DRIVER_T(alu_out_driver #(
                              .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                              )),
                    .MONITOR_T(alu_out_monitor #(
                               .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                               )),
                    .COVERAGE_T(alu_out_transaction_coverage #(
                                .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                                )),
                    .TRANS_T(alu_out_transaction #(
                             .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                             ))
                    );

  `uvm_component_param_utils( alu_out_agent #(
                              ALU_OUT_RESULT_WIDTH
                              ))

// pragma uvmf custom class_item_additional begin
// pragma uvmf custom class_item_additional end

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (configuration.active_passive == ACTIVE) begin
      // Place sequencer handle into configuration object
      // so that it may be retrieved from configuration 
      // rather than using uvm_config_db
      configuration.sequencer = this.sequencer;
    end
  endfunction
  
endclass
