//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
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

typedef axi4_2x2_fabric_env_configuration axi4_2x2_fabric_env_configuration_t;
typedef axi4_2x2_fabric_environment axi4_2x2_fabric_environment_t;

class test_top extends uvmf_test_base #(.CONFIG_T(axi4_2x2_fabric_env_configuration_t), 
                                        .ENV_T(axi4_2x2_fabric_environment_t), 
                                        .TOP_LEVEL_SEQ_T(axi4_2x2_fabric_bench_sequence_base));

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
    configuration.initialize(BLOCK, "uvm_test_top.environment", axi4_2x2_fabric_parameters_pkg::interface_names, null, axi4_2x2_fabric_parameters_pkg::interface_activities);



  endfunction

endclass

