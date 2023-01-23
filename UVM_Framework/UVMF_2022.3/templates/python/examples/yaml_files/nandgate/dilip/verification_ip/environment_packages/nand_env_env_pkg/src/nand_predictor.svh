//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
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
//   nand_in_agent_ae receives transactions of type  nand_in_transaction
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  nand_sco_ap broadcasts transactions of type nand_out_transaction
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class nand_predictor #(
  type CONFIG_T,
  type BASE_T = uvm_component
  ) extends BASE_T;

  // Factory registration of this class
  `uvm_component_param_utils( nand_predictor #(
                              CONFIG_T,
                              BASE_T
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_nand_in_agent_ae #(nand_in_transaction, nand_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .BASE_T(BASE_T)
                              )) nand_in_agent_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(nand_out_transaction) nand_sco_ap;


  // Transaction variable for predicted values to be sent out nand_sco_ap
  // Once a transaction is sent through an analysis_port, another transaction should
  // be constructed for the next predicted transaction. 
  typedef nand_out_transaction nand_sco_ap_output_transaction_t;
  nand_sco_ap_output_transaction_t nand_sco_ap_output_transaction;
  // Code for sending output transaction out through nand_sco_ap
  // nand_sco_ap.write(nand_sco_ap_output_transaction);

  // Define transaction handles for debug visibility 
  nand_in_transaction nand_in_agent_ae_debug;


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
    `uvm_warning("PREDICTOR_REVIEW", "This predictor has been created either through generation or re-generation with merging.  Remove this warning after the predictor has been reviewed.")
  // pragma uvmf custom new begin
  // pragma uvmf custom new end
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    nand_in_agent_ae = new("nand_in_agent_ae", this);
    nand_sco_ap =new("nand_sco_ap", this );
  // pragma uvmf custom build_phase begin
  // pragma uvmf custom build_phase end
  endfunction

  // FUNCTION: write_nand_in_agent_ae
  // Transactions received through nand_in_agent_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_nand_in_agent_ae(nand_in_transaction t);
    // pragma uvmf custom nand_in_agent_ae_predictor begin
    nand_in_agent_ae_debug = t;
    `uvm_info("PRED", "Transaction Received through nand_in_agent_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    // Construct one of each output transaction type.
    nand_sco_ap_output_transaction = nand_sco_ap_output_transaction_t::type_id::create("nand_sco_ap_output_transaction");
    //  UVMF_CHANGE_ME: Implement predictor model here. 
    nand_sco_ap_output_transaction.y = ~(t.a & t.b);
    `uvm_info("predictor", $sformatf("values from predictor t.a=%0b,t.b=%0b",t.a,t.b), UVM_LOW)
    `uvm_info("predictor", $sformatf("y=%0b",  nand_sco_ap_output_transaction.y), UVM_LOW)
//    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
 //   `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "UVMF_CHANGE_ME: The nand_predictor::write_nand_in_agent_ae function needs to be completed with DUT prediction model",UVM_NONE)
   // `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
 
    // Code for sending output transaction out through nand_sco_ap
    // Please note that each broadcasted transaction should be a different object than previously 
    // broadcasted transactions.  Creation of a different object is done by constructing the transaction 
    // using either new() or create().  Broadcasting a transaction object more than once to either the 
    // same subscriber or multiple subscribers will result in unexpected and incorrect behavior.
    nand_sco_ap.write(nand_sco_ap_output_transaction);
    // pragma uvmf custom nand_in_agent_ae_predictor end
  endfunction


endclass 

// pragma uvmf custom external begin
// pragma uvmf custom external end

