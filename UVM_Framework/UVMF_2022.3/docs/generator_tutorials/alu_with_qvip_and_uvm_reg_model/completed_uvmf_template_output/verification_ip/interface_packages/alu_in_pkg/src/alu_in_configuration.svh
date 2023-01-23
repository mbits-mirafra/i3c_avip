//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This class contains all variables and functions used
//      to configure the alu_in agent and its bfm's.  It gets the
//      bfm's from the uvm_config_db for use by the agent.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class alu_in_configuration #(
      int ALU_IN_OP_WIDTH = 8
      ) extends uvmf_parameterized_agent_configuration_base #(
      .DRIVER_BFM_BIND_T(virtual alu_in_driver_bfm #(
                          .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                          )),
      .MONITOR_BFM_BIND_T( virtual alu_in_monitor_bfm #(
                          .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                          )));

  `uvm_object_param_utils( alu_in_configuration #(
                           ALU_IN_OP_WIDTH
                           ))


  // Sequencer handle populated by agent
  uvm_sequencer #(alu_in_transaction #(
       .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
       ) ) sequencer;

  //Constraints for the configuration variables:

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  covergroup alu_in_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    // pragma uvmf custom covergroup end
  endgroup

  //*******************************************************************
  //*******************************************************************
  // Structure used to pass configuration variables to monitor and driver BFM's.
  // Use to_struct function to pack variables into structure.
  // Use from_struct function to unpack variables from structure.
  // This structure is defined in alu_in_macros.svh
  `alu_in_CONFIGURATION_STRUCT
  alu_in_configuration_s alu_in_configuration_struct;
  //*******************************************************************
  // FUNCTION: to_struct()
  // This function packs variables into a alu_in_configuration_s
  // structure.  The function returns the handle to the alu_in_configuration_struct.
  // This function is defined in alu_in_macros.svh
  `alu_in_CONFIGURATION_TO_STRUCT_FUNCTION
  //*******************************************************************
  // FUNCTION: from_struct()
  // This function unpacks the struct provided as an argument into 
  // variables of this class.
  // This function is defined in alu_in_macros.svh
  `alu_in_CONFIGURATION_FROM_STRUCT_FUNCTION

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new( string name = "" );
    super.new( name );
    // Construct the covergroup for this configuration class 
    alu_in_configuration_cg = new;
  endfunction

  // ****************************************************************************
  // FUNCTION: post_randomize()
  // This function is automatically called after the randomize() function 
  // is executed.
  //
  function void post_randomize();
    super.post_randomize();
    alu_in_configuration_cg.sample();
  endfunction

  // ****************************************************************************
  // FUNCTION: initialize
  //                   This function causes the configuration to retrieve
  //                   its virtual interface handle from the uvm_config_db.
  //                   This function also makes itself available to its
  //                   agent through the uvm_config_db.
  //
  //                ARGUMENTS:
  //                   uvmf_active_passive_t activity:
  //                        This argument identifies the simulation level
  //                        as either BLOCK, CHIP, SIMULATION, etc.
  //
  //                   AGENT_PATH:
  //                        This argument identifies the path to this
  //                        configurations agent.  This configuration
  //                        makes itself available to the agent specified
  //                        by agent_path by placing itself into the
  //                        uvm_config_db.
  //
  //                   INTERFACE_NAME:
  //                        This argument identifies the string name of
  //                        this configurations BFM's.  This string
  //                        name is used to retrieve the driver and 
  //                        monitor BFM from the uvm_config_db.
  //
  virtual function void initialize(uvmf_active_passive_t activity,
                                            string agent_path,
                                            string interface_name);

    super.initialize( activity, agent_path, interface_name);
    // The covergroup is given the same name as the interface
    alu_in_configuration_cg.set_inst_name(interface_name);

    // This configuration places itself into the uvm_config_db for the agent, identified by the agent_path variable, to retrieve.  
    uvm_config_db #( alu_in_configuration  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                             )
                    )::set( null ,agent_path,UVMF_AGENT_CONFIG, this );

    // This configuration also places itself in the config db using the same identifier used by the interface.  This allows users to access
    // configuration variables and the interface through the bfm api class rather than directly accessing the BFM.  This is useful for 
    // accessingthe BFM when using Veloce
    uvm_config_db #( alu_in_configuration  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                             )
                    )::set( null ,UVMF_CONFIGURATIONS, interface_name, this );

    alu_in_configuration_cg.set_inst_name($sformatf("alu_in_configuration_cg_%s",get_full_name()));

    // pragma uvmf custom initialize begin
    // This controls whether or not the agent returns a transaction handle in the driver when calling 
    // item_done() back into the sequencer or not. If set to 1, a transaction is sent back which means
    // the sequence on the other end must use the get_response() part of the driver/sequence API. If 
    // this doesn't occur, there will eventually be response_queue overflow errors during the test.
    return_transaction_response = 1'b0;

    // pragma uvmf custom initialize end

  endfunction

  // ****************************************************************************
  // TASK: wait_for_reset
  // *[Required]*  Blocks until reset is released.  The wait_for_reset operation is performed
  // by a task in the monitor bfm.
  virtual task wait_for_reset();
    monitor_bfm.wait_for_reset();
  endtask

  // ****************************************************************************
  // TASK: wait_for_num_clocks
  // *[Required]* Blocks until specified number of clocks have elapsed. The wait_for_num_clocks
  // operation is performed by a task in the monitor bfm.
  virtual task wait_for_num_clocks(int clocks);
    monitor_bfm.wait_for_num_clocks(clocks);
  endtask

  // ****************************************************************************
  // FUNCTION : convert2string()
  // This function is used to convert variables in this class into a string for log messaging.
  // 
  virtual function string convert2string ();
    // pragma uvmf custom convert2string begin
    return $sformatf("");
    // pragma uvmf custom convert2string end
  endfunction

  // ****************************************************************************
  // FUNCTION: get_sequencer
  function uvm_sequencer #(alu_in_transaction#(
       .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
       )) get_sequencer();
    return sequencer;
  endfunction

endclass
