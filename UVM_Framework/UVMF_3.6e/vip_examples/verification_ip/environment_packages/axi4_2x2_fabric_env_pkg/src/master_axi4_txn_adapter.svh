//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 12
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : master_axi4_txn_adapter 
// Unit            : master_axi4_txn_adapter 
// File            : master_axi4_txn_adapter.svh
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
//   master_axi4_txn_ae receives transactions of type  mvc_sequence_item_base  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  master_axi4_txn_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) 
//

class master_axi4_txn_adapter 
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
  `uvm_component_param_utils( master_axi4_txn_adapter #(
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
  uvm_analysis_imp_master_axi4_txn_ae #(mvc_sequence_item_base, master_axi4_txn_adapter  #(
                              .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                              .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                              .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                              .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),
                              .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),
                              .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                              .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
                            ) ) master_axi4_txn_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))) master_axi4_txn_ap;

  // Transaction variable for predicted values to be sent out master_axi4_txn_ap
  axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) master_axi4_txn_ap_output_transaction;
  // Code for sending output transaction out through master_axi4_txn_ap
  // master_axi4_txn_ap.write(master_axi4_txn_ap_output_transaction);


  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    master_axi4_txn_ae = new("master_axi4_txn_ae", this);

    master_axi4_txn_ap =new("master_axi4_txn_ap", this );

  endfunction

  // FUNCTION: write_master_axi4_txn_ae
  // Transactions received through master_axi4_txn_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_master_axi4_txn_ae(mvc_sequence_item_base t);
    `uvm_info("master_axi4_txn_adapter", "Transaction Recievied through master_axi4_txn_ae", UVM_MEDIUM)

    // Construct one of each output transaction type.
    master_axi4_txn_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("master_axi4_txn_ap_output_transaction");

    if (!$cast(master_axi4_txn_ap_output_transaction, t)) `uvm_fatal("CAST", "Error casting");

    master_axi4_txn_ap_output_transaction.addr_user_data              = 'b0;
    master_axi4_txn_ap_output_transaction.address_valid_delay         = 'b0;
    master_axi4_txn_ap_output_transaction.write_response_valid_delay  = 'b0;
    master_axi4_txn_ap_output_transaction.address_ready_delay         = 'b0;
    master_axi4_txn_ap_output_transaction.write_response_ready_delay  = 'b0;
    master_axi4_txn_ap_output_transaction.write_data_with_address     = 'b0;
    master_axi4_txn_ap_output_transaction.write_address_to_data_delay = 'b0;
    master_axi4_txn_ap_output_transaction.write_data_to_address_delay = 'b0;
    master_axi4_txn_ap_output_transaction.resp_user_data.delete();   // dynamic array
    master_axi4_txn_ap_output_transaction.wdata_user_data.delete();  // dynamic array
    master_axi4_txn_ap_output_transaction.data_valid_delay.delete(); // dynamic array
    master_axi4_txn_ap_output_transaction.data_ready_delay.delete(); // dynamic array
    master_axi4_txn_ap_output_transaction.write_data_beats_delay.delete(); // dynamic array

    // after adapter
    master_axi4_txn_ap_output_transaction.print();

    // Code for sending output transaction out through master_axi4_txn_ap
    master_axi4_txn_ap.write(master_axi4_txn_ap_output_transaction);
  endfunction

endclass 

