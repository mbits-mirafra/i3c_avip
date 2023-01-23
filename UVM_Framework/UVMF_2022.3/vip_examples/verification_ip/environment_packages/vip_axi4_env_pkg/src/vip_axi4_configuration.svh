//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVMF_Templates
// Unit            : vip_axi4_configuration
// File            : vip_axi4_configuration.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/03
//----------------------------------------------------------------------

//
// DESCRIPTION: This configuration class contains a configuration
//   object for each agent in the environment.  An agents configuration
//   configures the agent according to how it will be used within the
//   simulation.  This configuration also has a function, 
//   initialize, which tells each agent configuration the
//   string name of the virtual interface it will use and the string
//   path of where the environment resides in the simulation.  This
//   allows for the agent configurations to get their own virtual
//   interfaces and make themselves available to their own agent.
//
//----------------------------------------------------------------------
//
class vip_axi4_configuration #(int AXI4_ADDRESS_WIDTH = 32, 
                               int AXI4_RDATA_WIDTH = 32,
                               int AXI4_WDATA_WIDTH = 32,
                               int AXI4_ID_WIDTH = 8,
                               int AXI4_USER_WIDTH = 2,
                               int AXI4_REGION_MAP_SIZE = 16
                              ) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( vip_axi4_configuration #(AXI4_ADDRESS_WIDTH, 
                                                    AXI4_RDATA_WIDTH,
                                                    AXI4_WDATA_WIDTH,
                                                    AXI4_ID_WIDTH,
                                                    AXI4_USER_WIDTH,
                                                    AXI4_REGION_MAP_SIZE 
                                                   ))

  typedef addr_map_pkg::address_map addr_map_t;

  typedef axi4_master_rw_transaction #(AXI4_ADDRESS_WIDTH,
                                       AXI4_RDATA_WIDTH,
                                       AXI4_WDATA_WIDTH,
                                       AXI4_ID_WIDTH,
                                       AXI4_USER_WIDTH,
                                       AXI4_REGION_MAP_SIZE
                                      ) axi4_rw_trans_t;

  typedef axi4_coverage #(AXI4_ADDRESS_WIDTH,
                          AXI4_RDATA_WIDTH,
                          AXI4_WDATA_WIDTH,
                          AXI4_ID_WIDTH,
                          AXI4_USER_WIDTH,
                          AXI4_REGION_MAP_SIZE
                         ) axi4_cov_t;

  typedef virtual mgc_axi4 #(AXI4_ADDRESS_WIDTH,
                             AXI4_RDATA_WIDTH,
                             AXI4_WDATA_WIDTH,
                             AXI4_ID_WIDTH,
                             AXI4_USER_WIDTH,
                             AXI4_REGION_MAP_SIZE
                            ) axi4_if_t;

  typedef axi4_vip_config #(AXI4_ADDRESS_WIDTH,
                            AXI4_RDATA_WIDTH,
                            AXI4_WDATA_WIDTH,
                            AXI4_ID_WIDTH,
                            AXI4_USER_WIDTH,
                            AXI4_REGION_MAP_SIZE
                           ) vip_config_t;

  // Variable: m_master_config
  // The configuration object, of type <axi4_vip_config>, for the master end of the interface
  vip_config_t m_master_config;
  // The string variable that uniquely identifies the master virtual interface and sequencer in the uvm_config_db
  string   master_interface_name;

  // Variable: m_slave_config
  // The configuration object, of type <axi4_vip_config>, for the slave end of the interface
  vip_config_t m_slave_config;
  // The string variable that uniquely identifies the slave virtual interface and sequencer in the uvm_config_db
  string   slave_interface_name;

  // Variable: m_monitor_config
  // The configuration object, of type <axi4_vip_config>, for the monitor of the interface
  vip_config_t m_monitor_config;
  // The string variable that uniquely identifies the monitor virtual interface and sequencer in the uvm_config_db
  string   monitor_interface_name;

  // Variable: addr_map
  //
  // Instance of an address map for specifying regions of memory, along with
  // corresponding attribute values for each individual address map entry.

  addr_map_t addr_map;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );

    m_master_config  = vip_config_t::type_id::create("m_master_config"); 
    m_slave_config   = vip_config_t::type_id::create("m_slave_config"); 
    m_monitor_config = vip_config_t::type_id::create("m_monitor_config"); 
    addr_map = addr_map_t::type_id::create("addr_map");

  endfunction

// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {"" };

  endfunction

// ****************************************************************************
// FUNCTION: initialize();
// This function configures each interface agents configuration class.  The 
// sim level determines the active/passive state of the agent.  The environment_path
// identifies the hierarchy down to and including the instantiation name of the
// environment for this configuration class.  Each instance of the environment 
// has its own configuration class.  The string interface names are used by 
// the agent configurations to identify the virtual interface handle to pull from
// the uvm_config_db.  
//
  function void initialize(uvmf_sim_level_t sim_level, 
                           string environment_path,
                           string interface_names[] ,
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null
                           );

     this.master_interface_name  = interface_names[0];
     this.slave_interface_name   = interface_names[1];
     this.monitor_interface_name = interface_names[2];

     addr_map.set
     //           kind,    name, id, domain, region,    start_addr,          size,   mem_type
     ('{ '{ MAP_NORMAL, "RANGE1", 0, MAP_NS,      0, 32'h0000_0000, 32'h2000_0000, MEM_DEVICE},
         '{ MAP_NORMAL, "RANGE2", 0, MAP_NS,      0, 32'h2000_0000, 32'h2000_0000, MEM_DEVICE},
         '{ MAP_NORMAL, "RANGE3", 0, MAP_NS,      0, 32'h4000_0000, 32'h2000_0000, MEM_DEVICE},
         '{ MAP_NORMAL, "RANGE4", 0, MAP_NS,      0, 32'h6000_0000, 32'h2000_0000, MEM_DEVICE},
         '{ MAP_NORMAL, "RANGE5", 0, MAP_NS,      0, 32'h8000_0000, 32'h8000_0000, MEM_DEVICE}
       });

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
     m_master_config.addr_map = addr_map;
     m_monitor_config.addr_map = addr_map;
     m_slave_config.addr_map = addr_map;
`endif

     do_master_configuration();
     do_slave_configuration();
     do_monitor_configuration();

  endfunction

    function void do_master_configuration();

       typedef bit[AXI4_ADDRESS_WIDTH-1:0] Address;
       typedef bit[(AXI4_REGION_MAP_SIZE-1):0][((2 * AXI4_ADDRESS_WIDTH + 4 + 1) - 1):0] region_map_t;
    
      if(!uvm_config_db #( axi4_if_t )::get( null , UVMF_VIRTUAL_INTERFACES, master_interface_name , m_master_config.m_bfm ))
         `uvm_error("CFG" , $psprintf("uvm_config_db #( axi4_if_t )::get cannot find resource %s", master_interface_name) )

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
       m_master_config.agent_cfg.agent_type = AXI4_MASTER;
       m_master_config.agent_cfg.ext_clock = 1;
       m_master_config.agent_cfg.ext_reset = 1;
       m_master_config.agent_cfg.en_sb = 0;
       m_master_config.slave_id = 0;
`else
       m_master_config.m_active_passive = UVM_ACTIVE;
       m_master_config.m_bfm.axi4_set_master_abstraction_level(0,1); // TLM

       //if(m_master_config.master_delay == null)
         `uvm_info("CFG",
                   {"axi4_master_delay_db handle is null. Create handle to",
                    "use master delay database"},
                    UVM_MEDIUM);
`endif

       // Initialize the region map with 16 regions (the last of which covers the address space from
       // 32'hf0000000 to the top of the address space). The format of each entry is a concatenation
       // of lower-address, upper-address and region value.
       // (Note: entry 0 is the last in the initializer !)
       m_master_config.m_bfm.set_config_enable_region_support(1'b1);
       m_master_config.m_bfm.set_config_slave_regions(16);
       m_master_config.m_bfm.set_config_region(region_map_t'{
            // Lower-address         upper-address          region   cacheable
            {Address'(32'hf0000000), Address'(32'hffffffff),4'hf,1'b1},
            {Address'(32'he0000000), Address'(32'hefffffff),4'he,1'b1},
            {Address'(32'hd0000000), Address'(32'hdfffffff),4'hd,1'b0},
            {Address'(32'hc0000000), Address'(32'hcfffffff),4'hc,1'b1},
            {Address'(32'hb0000000), Address'(32'hbfffffff),4'hb,1'b1},
            {Address'(32'ha0000000), Address'(32'hafffffff),4'ha,1'b1},
            {Address'(32'h90000000), Address'(32'h9fffffff),4'h9,1'b0},
            {Address'(32'h80000000), Address'(32'h8fffffff),4'h8,1'b1},
            {Address'(32'h70000000), Address'(32'h7fffffff),4'h7,1'b1},
            {Address'(32'h60000000), Address'(32'h6fffffff),4'h6,1'b1},
            {Address'(32'h50000000), Address'(32'h5fffffff),4'h5,1'b0},
            {Address'(32'h40000000), Address'(32'h4fffffff),4'h4,1'b1},
            {Address'(32'h30000000), Address'(32'h3fffffff),4'h3,1'b1},
            {Address'(32'h20000000), Address'(32'h2fffffff),4'h2,1'b1},
            {Address'(32'h10000000), Address'(32'h1fffffff),4'h1,1'b1},
            {Address'(32'h00000000), Address'(32'h0fffffff),4'h0,1'b0}
          });
     
       // Turn off an 'error' check we don't need (as it is not really a protocol error - this is a warning wanted by some customers)
       m_master_config.m_bfm.set_config_enable_assertion_index1(AXI4_WRITE_DATA_BEFORE_ADDRESS, 1'b0);
   
       // Configure no warning on reading from an uninitialized memory location 
       m_master_config.m_warn_on_uninitialized_read = 1'b0;

    endfunction

    function void do_slave_configuration();

       if(!uvm_config_db #( axi4_if_t )::get( null , UVMF_VIRTUAL_INTERFACES, slave_interface_name , m_slave_config.m_bfm ))
          `uvm_error("CFG" , $psprintf("uvm_config_db #( axi4_if_t )::get cannot find resource %s", slave_interface_name) )

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
       m_slave_config.agent_cfg.agent_type = AXI4_SLAVE;
       m_slave_config.agent_cfg.ext_clock = 1;
       m_slave_config.agent_cfg.ext_reset = 1;
       m_slave_config.agent_cfg.en_sb = 0;
       m_slave_config.agent_cfg.en_slv_seq = 1;
       m_slave_config.slave_id = 0;
       do_set_axi4_slave_delay(m_slave_config);
`else
       m_slave_config.m_active_passive = UVM_ACTIVE;
       m_slave_config.m_bfm.axi4_set_slave_abstraction_level(0,1); // TLM

       //if(m_slave_config.slave_delay == null)
         `uvm_info("CFG",
                   {"axi4_slave_delay_db handle is null. Create handle to",
                    "use slave delay database"},
                    UVM_MEDIUM);
`endif

    endfunction

    function void do_monitor_configuration();

       if(!uvm_config_db #( axi4_if_t )::get( null , UVMF_VIRTUAL_INTERFACES, monitor_interface_name , m_monitor_config.m_bfm ))
          `uvm_error("CFG" , $psprintf("uvm_config_db #( axi4_if_t )::get cannot find resource %s", monitor_interface_name) )

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
       m_monitor_config.agent_cfg.is_active = 0;   // this is a passive component
       m_monitor_config.agent_cfg.ext_clock = 1;
       m_monitor_config.agent_cfg.ext_reset = 1;
       m_monitor_config.agent_cfg.en_txn_ltnr = 1;
       m_monitor_config.agent_cfg.en_cvg.func = 1;
       m_monitor_config.slave_id = 0;
`else
       m_monitor_config.m_active_passive = UVM_PASSIVE;
       m_monitor_config.set_analysis_component("trans_ap", "listener", mvc_item_listener #(axi4_rw_trans_t)::get_type());
       m_monitor_config.set_analysis_component("", "func_cov", axi4_cov_t::type_id::get());
`endif

    endfunction

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
    function void do_set_axi4_slave_delay(vip_config_t slave_config);
      axi4_slave_delay_db slave_delay;

      // Handles for master/slave wr/rd delay structs for
      // inserting default delay
      axi4_slave_rd_delay_s min_rd_delay;
      axi4_slave_rd_delay_s max_rd_delay;
      axi4_slave_wr_delay_s min_wr_delay;
      axi4_slave_wr_delay_s max_wr_delay;

      slave_delay = axi4_slave_delay_db::type_id::create("slave_delay");

      slave_delay.set_address_map(addr_map);
      slave_delay.set_axi4lite_interface(1'b0);
      // slave_delay.set_ready_delay_mode(1'b0, 1'b0);    // set delay mode to accept2ready rather than valid2ready

      // Min
      min_rd_delay.arvalid2arready = 0;
      min_rd_delay.addr2data       = 1;
      min_rd_delay.data2data       = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

      // Max
      max_rd_delay.arvalid2arready = 1;
      max_rd_delay.addr2data       = 2;
      max_rd_delay.data2data       = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

      // Set default delays for slave read database
      slave_delay.set_rd_def_delays(min_rd_delay, max_rd_delay);

      // Min
      min_wr_delay.awvalid2awready = 0;
      min_wr_delay.wvalid2wready   = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
      min_wr_delay.wlast2bvalid    = 0;

      // Max
      max_wr_delay.awvalid2awready = 1;
      max_wr_delay.wvalid2wready   = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
      max_wr_delay.wlast2bvalid    = 2;

      // Set default delays for slave write database
      slave_delay.set_wr_def_delays(min_wr_delay, max_wr_delay);

      slave_config.slave_delay = slave_delay;
    endfunction
`endif

endclass
