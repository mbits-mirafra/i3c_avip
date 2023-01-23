//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface configuration
// File            : ahb_configuration.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This class contains all variables and functions used
//      to configure the ahb agent and its bfm's.  It gets the
//      bfm's from the uvm_config_db for use by the agent.
//
//      Configuration utility function:
//             initialize:
//                   This function causes the configuration to retrieve
//                   its virtual interface handle from the uvm_config_db.
//                   This function also makes itself available to its
//                   agent through the uvm_config_db.
//
//                Arguments:
//                   uvmf_active_passive_t activity:
//                        This argument identifies the simulation level
//                        as either BLOCK, CHIP, SIMULATION, etc.
//
//                   agent_path:
//                        This argument identifies the path to this
//                        configurations agent.  This configuration
//                        makes itself available to the agent specified
//                        by agent_path by placing itself into the
//                        uvm_config_db.
//
//                   interface_name:
//                        This argument identifies the string name of
//                        this configuration's driver and monitor BFMs.
//                        This string name is used to retrieve these 
//                        BFMs from the uvm_config_db.
//
//----------------------------------------------------------------------
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class ahb_configuration extends uvmf_parameterized_agent_configuration_base#(
  .DRIVER_BFM_BIND_T(virtual ahb_driver_bfm),
  .MONITOR_BFM_BIND_T(virtual ahb_monitor_bfm));

  `uvm_object_utils( ahb_configuration )


//Constraints for the configuration variables:

  covergroup ahb_configuration_cg;
    option.auto_bin_max=1024;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "" );
    super.new( name );
    // Construct the covergroup for this configuration class 
    ahb_configuration_cg = new;
  endfunction

// ****************************************************************************
// FUNCTION: post_randomize()
// This function is automatically called after the randomize() function 
// is executed.
//
  function void post_randomize();
    super.post_randomize();
    ahb_configuration_cg.sample();
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
    ahb_configuration_cg.set_inst_name(interface_name);

    // This configuration places itself into the uvm_config_db for the agent, identified by the agent_path variable, to retrieve.  
    uvm_config_db #( ahb_configuration )::set( null ,agent_path,UVMF_AGENT_CONFIG, this );

    // This configuration also places itself in the config db using the same identifier used by the interface.  This allows users to access
    // configuration variables and the interface through the bfm api class rather than directly accessing the BFM.  This is useful for 
    // accessingthe BFM when using Veloce
    uvm_config_db #( ahb_configuration )::set( null ,UVMF_CONFIGURATIONS, interface_name, this );

    ahb_configuration_cg.set_inst_name(
        $sformatf("ahb_configuration_cg_%s",get_full_name())
        );


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
    return $sformatf("");
  endfunction

endclass
