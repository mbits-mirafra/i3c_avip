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
class alu_in_agent #(
     int ALU_IN_OP_WIDTH = 8
     ) extends uvmf_parameterized_agent #(
                    .CONFIG_T(alu_in_configuration #(
                              .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                              )),
                    .DRIVER_T(alu_in_driver #(
                              .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                              )),
                    .MONITOR_T(alu_in_monitor #(
                               .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                               )),
                    .COVERAGE_T(alu_in_transaction_coverage #(
                                .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                                )),
                    .TRANS_T(alu_in_transaction #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                             ))
                    );

  `uvm_component_param_utils( alu_in_agent #(
                              ALU_IN_OP_WIDTH
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
