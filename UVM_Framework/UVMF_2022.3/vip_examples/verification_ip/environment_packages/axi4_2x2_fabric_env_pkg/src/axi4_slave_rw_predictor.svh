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
//   axi4_s1_ae receives transactions of type  rw_txn
//   axi4_s0_ae receives transactions of type  rw_txn
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  axi4_m1_ap broadcasts transactions of type rw_txn
//  axi4_m0_ap broadcasts transactions of type rw_txn
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class axi4_slave_rw_predictor #(
  type CONFIG_T
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( axi4_slave_rw_predictor #(
                              CONFIG_T
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_axi4_s1_ae #(rw_txn, axi4_slave_rw_predictor #(
                              .CONFIG_T(CONFIG_T)
                              )) axi4_s1_ae;
  uvm_analysis_imp_axi4_s0_ae #(rw_txn, axi4_slave_rw_predictor #(
                              .CONFIG_T(CONFIG_T)
                              )) axi4_s0_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(rw_txn) axi4_m1_ap;
  uvm_analysis_port #(rw_txn) axi4_m0_ap;


  // Transaction variable for predicted values to be sent out axi4_m1_ap
  typedef rw_txn axi4_m1_ap_output_transaction_t;
  axi4_m1_ap_output_transaction_t axi4_m1_ap_output_transaction;
  // Code for sending output transaction out through axi4_m1_ap
  // axi4_m1_ap.write(axi4_m1_ap_output_transaction);
  // Transaction variable for predicted values to be sent out axi4_m0_ap
  typedef rw_txn axi4_m0_ap_output_transaction_t;
  axi4_m0_ap_output_transaction_t axi4_m0_ap_output_transaction;
  // Code for sending output transaction out through axi4_m0_ap
  // axi4_m0_ap.write(axi4_m0_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin
  // Please note that the auto-output_transaction types/names used above
  // are not going to be used, but there is no way to avoid them, so we 
  // will let the templates declare them but we will use the one below instead.
  typedef rw_txn axi4_ap_output_transaction_t;
  axi4_ap_output_transaction_t axi4_ap_output_transaction;
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    axi4_s1_ae = new("axi4_s1_ae", this);
    axi4_s0_ae = new("axi4_s0_ae", this);
    axi4_m1_ap =new("axi4_m1_ap", this );
    axi4_m0_ap =new("axi4_m0_ap", this );
  endfunction

  // FUNCTION: write_axi4_s1_ae
  // Transactions received through axi4_s1_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_axi4_s1_ae(rw_txn t);
    // pragma uvmf custom axi4_s1_ae_predictor begin
    `uvm_info("PRED", "Transaction Received through axi4_s1_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)

    // Construct the output transaction.
    axi4_ap_output_transaction = axi4_ap_output_transaction_t::type_id::create("axi4_ap_output_transaction");

    // Copy incoming txn to a new object to be sent out the analysis ports 
    axi4_ap_output_transaction.copy(t);

    // If msb is asserted, then write to m1, else write to m0.
    if (axi4_ap_output_transaction.id[mgc_axi4_s1_params::AXI4_ID_WIDTH-1]) begin 
      // Code for sending output transaction out through axi4_m1_ap
      axi4_ap_output_transaction.id = t.id[mgc_axi4_s1_params::AXI4_ID_WIDTH-2:0];  // WIDTH Conversion  // lop off MSB bit added by fabric
      axi4_m1_ap.write(axi4_ap_output_transaction);
    end else begin
      // Code for sending output transaction out through axi4_m0_ap
      axi4_m0_ap.write(axi4_ap_output_transaction);
    end
    // pragma uvmf custom axi4_s1_ae_predictor end
  endfunction

  // FUNCTION: write_axi4_s0_ae
  // Transactions received through axi4_s0_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_axi4_s0_ae(rw_txn t);
    // pragma uvmf custom axi4_s0_ae_predictor begin
    `uvm_info("PRED", "Transaction Received through axi4_s0_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    
    // Construct the output transaction.
    axi4_ap_output_transaction = axi4_ap_output_transaction_t::type_id::create("axi4_ap_output_transaction");

    // Copy incoming txn to a new object to be sent out the analysis ports 
    axi4_ap_output_transaction.copy(t);

    // If msb is asserted, then write to m1, else write to m0.
    if (axi4_ap_output_transaction.id[mgc_axi4_s0_params::AXI4_ID_WIDTH-1]) begin 
      // Code for sending output transaction out through axi4_m1_ap
      axi4_ap_output_transaction.id = t.id[mgc_axi4_s0_params::AXI4_ID_WIDTH-2:0];  // WIDTH Conversion  // lop off MSB bit added by fabric
      axi4_m1_ap.write(axi4_ap_output_transaction);
    end else begin
      // Code for sending output transaction out through axi4_m0_ap
      axi4_m0_ap.write(axi4_ap_output_transaction);
    end
    // pragma uvmf custom axi4_s0_ae_predictor end
  endfunction


endclass 
