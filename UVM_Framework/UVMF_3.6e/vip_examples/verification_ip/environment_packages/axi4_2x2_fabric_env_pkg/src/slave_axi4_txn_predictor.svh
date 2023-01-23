//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 12
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : slave_axi4_txn_predictor 
// Unit            : slave_axi4_txn_predictor 
// File            : slave_axi4_txn_predictor.svh
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   slave_axi4_txn_ae receives transactions of type  mvc_sequence_item_base  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  slave_axi4_txn_m1_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) 
//  slave_axi4_txn_m0_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) 
//

class slave_axi4_txn_predictor 
      #(
      int AXI4_ADDRESS_WIDTH = 32,                                
      int AXI4_RDATA_WIDTH = 32,                                
      int AXI4_WDATA_WIDTH = 32,                                
      int AXI4_MASTER_ID_WIDTH = 4,                                
      int AXI4_SLAVE_ID_WIDTH = 5,                                
      int AXI4_USER_WIDTH = 4,                                
      int AXI4_REGION_MAP_SIZE = 16                                
      )
extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( slave_axi4_txn_predictor #(
                              AXI4_ADDRESS_WIDTH,
                              AXI4_RDATA_WIDTH,
                              AXI4_WDATA_WIDTH,
                              AXI4_MASTER_ID_WIDTH,
                              AXI4_SLAVE_ID_WIDTH,
                              AXI4_USER_WIDTH,
                              AXI4_REGION_MAP_SIZE
                            ))

  // Instantiate a handle to the configuration of the environment in which this component resides
  axi4_2x2_fabric_env_configuration   #(
             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
             )  configuration;

  // Instantiate the analysis exports
  uvm_analysis_imp_slave_axi4_txn_ae #(mvc_sequence_item_base, slave_axi4_txn_predictor  #(
                              .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                              .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                              .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                              .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),
                              .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),
                              .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                              .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
                            ) ) slave_axi4_txn_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))) slave_axi4_txn_m1_ap;
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))) slave_axi4_txn_m0_ap;

  // Intermediate Transaction variable
  axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_SLAVE_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) slave_axi4_txn_transaction;

  // Transaction variable for predicted values to be sent out either slave_axi4_txn_m0_ap or slave_axi4_txn_m1_ap
  axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) slave_axi4_txn_ap_output_transaction;

  // Transaction variable for predicted values to be sent out slave_axi4_txn_m1_ap
  // axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) slave_axi4_txn_m1_ap_output_transaction;
  // Code for sending output transaction out through slave_axi4_txn_m1_ap
  // slave_axi4_txn_m1_ap.write(slave_axi4_txn_m1_ap_output_transaction);

  // Transaction variable for predicted values to be sent out slave_axi4_txn_m0_ap
  // axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) slave_axi4_txn_m0_ap_output_transaction;
  // Code for sending output transaction out through slave_axi4_txn_m0_ap
  // slave_axi4_txn_m0_ap.write(slave_axi4_txn_m0_ap_output_transaction);


  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    slave_axi4_txn_ae = new("slave_axi4_txn_ae", this);

    slave_axi4_txn_m1_ap =new("slave_axi4_txn_m1_ap", this );
    slave_axi4_txn_m0_ap =new("slave_axi4_txn_m0_ap", this );

  endfunction

  // FUNCTION: write_slave_axi4_txn_ae
  // Transactions received through slave_axi4_txn_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_slave_axi4_txn_ae(mvc_sequence_item_base t);
    `uvm_info("slave_axi4_txn_predictor", "Transaction Recievied through slave_axi4_txn_ae", UVM_MEDIUM)

  // Construct one of each intermediate transaction type.
  slave_axi4_txn_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_SLAVE_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("slave_axi4_txn_transaction");

  // Construct one of each output transaction type.
  // slave_axi4_txn_m1_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("slave_axi4_txn_m1_ap_output_transaction");
  // slave_axi4_txn_m0_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("slave_axi4_txn_m0_ap_output_transaction");
  slave_axi4_txn_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("slave_axi4_txn_ap_output_transaction");

    if (!$cast(slave_axi4_txn_transaction, t)) `uvm_fatal("CAST", "Error casting");

    // before adapter
    slave_axi4_txn_transaction.print();

    // populate all fields in txn to be broadcast by copying fields from received txn
    // fields came from questa_mvc_src/sv/axi4/shared/axi_master_sequence_items_MTI.svh
    slave_axi4_txn_ap_output_transaction.id = slave_axi4_txn_transaction.id[AXI4_MASTER_ID_WIDTH-1:0];
    slave_axi4_txn_ap_output_transaction.addr = slave_axi4_txn_transaction.addr;
    slave_axi4_txn_ap_output_transaction.read_or_write = slave_axi4_txn_transaction.read_or_write;
    slave_axi4_txn_ap_output_transaction.prot = slave_axi4_txn_transaction.prot;
    slave_axi4_txn_ap_output_transaction.region = slave_axi4_txn_transaction.region;
    slave_axi4_txn_ap_output_transaction.size = slave_axi4_txn_transaction.size;
    slave_axi4_txn_ap_output_transaction.burst = slave_axi4_txn_transaction.burst;
    slave_axi4_txn_ap_output_transaction.burst_length = slave_axi4_txn_transaction.burst_length;
    slave_axi4_txn_ap_output_transaction.lock = slave_axi4_txn_transaction.lock;
    slave_axi4_txn_ap_output_transaction.cache = slave_axi4_txn_transaction.cache;
    slave_axi4_txn_ap_output_transaction.qos = slave_axi4_txn_transaction.qos;
    slave_axi4_txn_ap_output_transaction.rdata_words = slave_axi4_txn_transaction.rdata_words;     // dynamic array
    slave_axi4_txn_ap_output_transaction.wdata_words = slave_axi4_txn_transaction.wdata_words;     // dynamic array
    slave_axi4_txn_ap_output_transaction.write_strobes = slave_axi4_txn_transaction.write_strobes; // dynamic array
    slave_axi4_txn_ap_output_transaction.resp = slave_axi4_txn_transaction.resp;                   // dynamic array

/****
    slave_axi4_txn_ap_output_transaction.addr_user_data = 'b0;
    // slave_axi4_txn_ap_output_transaction.resp_user_data = slave_axi4_txn_transaction.resp_user_data;     // dynamic array
    // slave_axi4_txn_ap_output_transaction.wdata_user_data = slave_axi4_txn_transaction.wdata_user_data;   // dynamic array
    slave_axi4_txn_ap_output_transaction.address_valid_delay = 'b0;
    slave_axi4_txn_ap_output_transaction.write_response_valid_delay = 'b0;
    slave_axi4_txn_ap_output_transaction.address_ready_delay = 'b0;
    slave_axi4_txn_ap_output_transaction.write_response_ready_delay = 'b0;
    slave_axi4_txn_ap_output_transaction.write_data_with_address = 'b0;
    slave_axi4_txn_ap_output_transaction.write_address_to_data_delay = 'b0;
    slave_axi4_txn_ap_output_transaction.write_data_to_address_delay = 'b0;
    // slave_axi4_txn_ap_output_transaction.data_valid_delay = slave_axi4_txn_transaction.data_valid_delay; // dynamic array
    // slave_axi4_txn_ap_output_transaction.data_ready_delay = slave_axi4_txn_transaction.data_ready_delay; // dynamic array
    // slave_axi4_txn_ap_output_transaction.write_data_beats_delay = slave_axi4_txn_transaction.write_data_beats_delay; // dynamic array
*****/

    // after adapter
    slave_axi4_txn_ap_output_transaction.print();

    // Code for sending output transaction out through appropriate ap
    if (slave_axi4_txn_transaction.id[AXI4_SLAVE_ID_WIDTH-1])  // if msb asserted, then send to m1
      slave_axi4_txn_m1_ap.write(slave_axi4_txn_ap_output_transaction);
    else
      slave_axi4_txn_m0_ap.write(slave_axi4_txn_ap_output_transaction);

  endfunction

endclass 

