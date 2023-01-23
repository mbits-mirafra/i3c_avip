//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
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
class ccs_agent #(
     int WIDTH = 32
     ) extends uvmf_parameterized_agent #(
                    .CONFIG_T(ccs_configuration #(
                              .WIDTH(WIDTH)
                              )),
                    .DRIVER_T(ccs_driver #(
                              .WIDTH(WIDTH)
                              )),
                    .MONITOR_T(ccs_monitor #(
                               .WIDTH(WIDTH)
                               )),
                    .COVERAGE_T(ccs_transaction_coverage #(
                                .WIDTH(WIDTH)
                                )),
                    .TRANS_T(ccs_transaction #(
                             .WIDTH(WIDTH)
                             ))
                    );

  `uvm_component_param_utils( ccs_agent #(
                              WIDTH
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
