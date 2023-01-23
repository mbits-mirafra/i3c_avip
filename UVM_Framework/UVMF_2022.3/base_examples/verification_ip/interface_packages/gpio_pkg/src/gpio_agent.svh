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
class gpio_agent #(
     int READ_PORT_WIDTH = 4,
     int WRITE_PORT_WIDTH = 4
     ) extends uvmf_parameterized_agent #(
                    .CONFIG_T(gpio_configuration #(
                              .READ_PORT_WIDTH(READ_PORT_WIDTH),
                              .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                              )),
                    .DRIVER_T(gpio_driver #(
                              .READ_PORT_WIDTH(READ_PORT_WIDTH),
                              .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                              )),
                    .MONITOR_T(gpio_monitor #(
                               .READ_PORT_WIDTH(READ_PORT_WIDTH),
                               .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                               )),
                    .COVERAGE_T(gpio_transaction_coverage #(
                                .READ_PORT_WIDTH(READ_PORT_WIDTH),
                                .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                                )),
                    .TRANS_T(gpio_transaction #(
                             .READ_PORT_WIDTH(READ_PORT_WIDTH),
                             .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                             ))
                    );

  `uvm_component_param_utils( gpio_agent #(
                              READ_PORT_WIDTH,
                              WRITE_PORT_WIDTH
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
