//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This class contains all variables and functions used
//      to configure the i3c_m agent and its bfm's.  It gets the
//      bfm's from the uvm_config_db for use by the agent.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i3c_m_configuration  extends uvmf_parameterized_agent_configuration_base #(
      .DRIVER_BFM_BIND_T(virtual i3c_m_driver_bfm ),
      .MONITOR_BFM_BIND_T( virtual i3c_m_monitor_bfm ));

  `uvm_object_utils( i3c_m_configuration )

  uvm_active_passive_enum is_active;
  int no_of_slaves;
  shift_direction_e shift_dir;
  bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address_array [];
  bit [7:0] slave_register_address_array [];
  rand bit [2:0] primary_prescalar;
  rand bit [2:0] secondary_prescalar;
  int baudrate_divisor;
  bit has_coverage;

  // Sequencer handle populated by agent
  uvm_sequencer #(i3c_m_transaction  ) sequencer;

  //Constraints for the configuration variables:

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  covergroup i3c_m_configuration_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    coverpoint is_active;
    coverpoint no_of_slaves;
    coverpoint shift_dir;
//    coverpoint slave_address_array;
//    coverpoint slave_register_address_array;
    coverpoint primary_prescalar;
    coverpoint secondary_prescalar;
    coverpoint baudrate_divisor;
    coverpoint has_coverage;
    // pragma uvmf custom covergroup end
  endgroup


  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new( string name = "" );
    super.new( name );
    // Construct the covergroup for this configuration class 
    i3c_m_configuration_cg = new;
  endfunction

  // ****************************************************************************
  // FUNCTION: post_randomize()
  // This function is automatically called after the randomize() function 
  // is executed.
  //
  function void post_randomize();
    super.post_randomize();
    i3c_m_configuration_cg.sample();
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
    i3c_m_configuration_cg.set_inst_name(interface_name);

    // This configuration places itself into the uvm_config_db for the agent, identified by the agent_path variable, to retrieve.  
    uvm_config_db #( i3c_m_configuration  
                    )::set( null ,agent_path,UVMF_AGENT_CONFIG, this );

    // This configuration also places itself in the config db using the same identifier used by the interface.  This allows users to access
    // configuration variables and the interface through the bfm api class rather than directly accessing the BFM.  This is useful for 
    // accessingthe BFM when using Veloce
    uvm_config_db #( i3c_m_configuration  
                    )::set( null ,UVMF_CONFIGURATIONS, interface_name, this );

    i3c_m_configuration_cg.set_inst_name($sformatf("i3c_m_configuration_cg_%s",get_full_name()));

// This code is to aid in debugging parameter mismatches between the BFM and its corresponding agent.
// Enable this debug by setting UVM_VERBOSITY to UVM_DEBUG
// Setting UVM_VERBOSITY to UVM_DEBUG causes all BFM's and all agents to display their parameter settings.
// All of the messages from this feature have a UVM messaging id value of "CFG"
// The transcript or run.log can be parsed to ensure BFM parameter settings match its corresponding agents parameter settings.
    `uvm_info("CFG", 
              $psprintf("The agent at '%s' is using interface named %s has the following parameters: ", agent_path, interface_name, ),
              UVM_DEBUG)

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
    return $sformatf("is_active:0x%x  no_of_slaves:0x%x  shift_dir:0x%x  slave_address_array:%p  slave_register_address_array:%p  primary_prescalar:0x%x  secondary_prescalar:0x%x  baudrate_divisor:0x%x  has_coverage:0x%x  ",is_active,no_of_slaves,shift_dir,slave_address_array,slave_register_address_array,primary_prescalar,secondary_prescalar,baudrate_divisor,has_coverage);
    // pragma uvmf custom convert2string end
  endfunction

  // ****************************************************************************
  // FUNCTION: get_sequencer
  function uvm_sequencer #(i3c_m_transaction) get_sequencer();
    return sequencer;
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

