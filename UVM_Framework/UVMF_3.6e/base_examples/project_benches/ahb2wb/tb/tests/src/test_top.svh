//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2wb Simulation Bench 
// Unit            : Top level UVM test
// File            : test_top.svh
//----------------------------------------------------------------------
// Description: This top level UVM test is the base class for all
//     future tests created for this project.
//
//     This test class contains:
//          Configuration:  The top level configuration for the project.
//          Environment:    The top level environment for the project.
//          Top_level_sequence:  The top level sequence for the project.
//                                          
//----------------------------------------------------------------------
//

class test_top extends uvmf_test_base #(.CONFIG_T(ahb2wb_env_configuration), 
                                        .ENV_T(ahb2wb_environment), 
                                        .TOP_LEVEL_SEQ_T(ahb2wb_bench_sequence_base));

  `uvm_component_utils( test_top );


// ****************************************************************************
// FUNCTION: new()
// This is the standard system verilog constructor.  All components are 
// constructed in the build_phase to allow factory overriding.
//
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
  endfunction




// ****************************************************************************
// FUNCTION: build_phase()
// The construction of the configuration and environment classes is done in
// the build_phase of uvmf_test_base.  Once the configuraton and environment
// classes are built then the initialize call is made to perform the
// following: 
//     Monitor and driver BFM virtual interface handle passing into agents
//     Set the active/passive state for each agent
// Once this build_phase completes, the build_phase of the environment is
// executed which builds the agents.
//
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    configuration.initialize(BLOCK, "uvm_test_top.environment", ahb2wb_parameters_pkg::interface_names, null, ahb2wb_parameters_pkg::interface_activities);



  endfunction

endclass

