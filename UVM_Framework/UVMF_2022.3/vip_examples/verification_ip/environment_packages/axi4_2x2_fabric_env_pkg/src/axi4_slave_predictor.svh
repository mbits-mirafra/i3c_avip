//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  axi4_m1_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE))
//  axi4_m0_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE))
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class axi4_slave_predictor #(
  type CONFIG_T,
  int AXI4_ADDRESS_WIDTH = 32,
  int AXI4_RDATA_WIDTH = 32,
  int AXI4_WDATA_WIDTH = 32,
  int AXI4_ID_WIDTH = 5,
  int AXI4_USER_WIDTH = 4,
  int AXI4_REGION_MAP_SIZE = 16
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( axi4_slave_predictor #(
                              CONFIG_T,
                              AXI4_ADDRESS_WIDTH,
                              AXI4_RDATA_WIDTH,
                              AXI4_WDATA_WIDTH,
                              AXI4_ID_WIDTH,
                              AXI4_USER_WIDTH,
                              AXI4_REGION_MAP_SIZE
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;


  
  // Instantiate the analysis ports
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE))) axi4_m1_ap;
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE))) axi4_m0_ap;

 
  // Instantiate QVIP analysis exports
  uvm_analysis_imp_axi4_ae #(mvc_sequence_item_base, axi4_slave_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                              .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                              .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                              .AXI4_ID_WIDTH(AXI4_ID_WIDTH),
                              .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                              .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
                              )) axi4_ae;

  // Transaction variable for predicted values to be sent out axi4_m1_ap
  typedef axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m1_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m1_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m1_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m1_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m1_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m1_params::AXI4_REGION_MAP_SIZE)) axi4_m1_ap_output_transaction_t;
  axi4_m1_ap_output_transaction_t axi4_m1_ap_output_transaction;
  // Code for sending output transaction out through axi4_m1_ap
  // axi4_m1_ap.write(axi4_m1_ap_output_transaction);
  // Transaction variable for predicted values to be sent out axi4_m0_ap
  typedef axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(mgc_axi4_m0_params::AXI4_ADDRESS_WIDTH),.AXI4_RDATA_WIDTH(mgc_axi4_m0_params::AXI4_RDATA_WIDTH),.AXI4_WDATA_WIDTH(mgc_axi4_m0_params::AXI4_WDATA_WIDTH),.AXI4_ID_WIDTH(mgc_axi4_m0_params::AXI4_ID_WIDTH),.AXI4_USER_WIDTH(mgc_axi4_m0_params::AXI4_USER_WIDTH),.AXI4_REGION_MAP_SIZE(mgc_axi4_m0_params::AXI4_REGION_MAP_SIZE)) axi4_m0_ap_output_transaction_t;
  axi4_m0_ap_output_transaction_t axi4_m0_ap_output_transaction;
  // Code for sending output transaction out through axi4_m0_ap
  // axi4_m0_ap.write(axi4_m0_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    axi4_ae = new("axi4_ae", this);
    axi4_m1_ap =new("axi4_m1_ap", this );
    axi4_m0_ap =new("axi4_m0_ap", this );
  endfunction


  // FUNCTION: write_axi4_ae
  // QVIP transactions received through axi4_ae initiate the execution of this function.
  // This function casts incoming QVIP transactions into the correct protocol type and then performs prediction 
  // of DUT output values based on DUT input, configuration and state
  virtual function void write_axi4_ae(mvc_sequence_item_base _t);
    // pragma uvmf custom axi4_ae_predictor begin
    axi4_master_rw_transaction 
      #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), 
        .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), 
        .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), 
        .AXI4_ID_WIDTH(AXI4_ID_WIDTH), 
        .AXI4_USER_WIDTH(AXI4_USER_WIDTH), 
        .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) t;
    if (!$cast(t,_t)) begin
      `uvm_fatal("PRED","Cast from mvc_sequence_item_base to axi4_master_rw_transaction 
      #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), 
        .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), 
        .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), 
        .AXI4_ID_WIDTH(AXI4_ID_WIDTH), 
        .AXI4_USER_WIDTH(AXI4_USER_WIDTH), 
        .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) in write_axi4_ae failed!")
    end
    `uvm_info("PRED", "Transaction Received through axi4_ae", UVM_MEDIUM)
    `uvm_info("PRED",{"            Data: ",t.convert2string()}, UVM_FULL)
    // If msb asserted, then write to m1, else write to m0.

    // Populate broadcast txn attributes by copying attributes from received txn
    // Attributes are defined within questa_mvc_src/sv/axi4/shared/axi_master_sequence_items_MTI.svh
    // Those attributes not specified below will be zero or null.
    if (t.id[AXI4_ID_WIDTH-1]) begin
      // Construct the output transaction type.
      axi4_m1_ap_output_transaction = axi4_m1_ap_output_transaction_t::type_id::create("axi4_m1_ap_output_transaction");

      axi4_m1_ap_output_transaction.id            = t.id[mgc_axi4_m1_params::AXI4_ID_WIDTH-1:0];
      axi4_m1_ap_output_transaction.addr          = t.addr;
      axi4_m1_ap_output_transaction.read_or_write = t.read_or_write;
      axi4_m1_ap_output_transaction.prot          = t.prot;
      axi4_m1_ap_output_transaction.region        = t.region;
      axi4_m1_ap_output_transaction.size          = t.size;
      axi4_m1_ap_output_transaction.burst         = t.burst;
      axi4_m1_ap_output_transaction.burst_length  = t.burst_length;
      axi4_m1_ap_output_transaction.lock          = t.lock;
      axi4_m1_ap_output_transaction.cache         = t.cache;
      axi4_m1_ap_output_transaction.qos           = t.qos;
      axi4_m1_ap_output_transaction.rdata_words   = t.rdata_words;   // dynamic array
      axi4_m1_ap_output_transaction.wdata_words   = t.wdata_words;   // dynamic array
      axi4_m1_ap_output_transaction.write_strobes = t.write_strobes; // dynamic array
      axi4_m1_ap_output_transaction.resp          = t.resp;          // dynamic array
      // Code for sending output transaction out through axi4_m1_ap
      axi4_m1_ap.write(axi4_m1_ap_output_transaction);
    end else begin
      // Construct the output transaction type.
      axi4_m0_ap_output_transaction = axi4_m0_ap_output_transaction_t::type_id::create("axi4_m0_ap_output_transaction");

      axi4_m0_ap_output_transaction.id            = t.id[mgc_axi4_m0_params::AXI4_ID_WIDTH-1:0];
      axi4_m0_ap_output_transaction.addr          = t.addr;
      axi4_m0_ap_output_transaction.read_or_write = t.read_or_write;
      axi4_m0_ap_output_transaction.prot          = t.prot;
      axi4_m0_ap_output_transaction.region        = t.region;
      axi4_m0_ap_output_transaction.size          = t.size;
      axi4_m0_ap_output_transaction.burst         = t.burst;
      axi4_m0_ap_output_transaction.burst_length  = t.burst_length;
      axi4_m0_ap_output_transaction.lock          = t.lock;
      axi4_m0_ap_output_transaction.cache         = t.cache;
      axi4_m0_ap_output_transaction.qos           = t.qos;
      axi4_m0_ap_output_transaction.rdata_words   = t.rdata_words;   // dynamic array
      axi4_m0_ap_output_transaction.wdata_words   = t.wdata_words;   // dynamic array
      axi4_m0_ap_output_transaction.write_strobes = t.write_strobes; // dynamic array
      axi4_m0_ap_output_transaction.resp          = t.resp;          // dynamic array
      // Code for sending output transaction out through axi4_m0_ap
      axi4_m0_ap.write(axi4_m0_ap_output_transaction);
    end
    // pragma uvmf custom axi4_ae_predictor end
  endfunction
  
endclass 
