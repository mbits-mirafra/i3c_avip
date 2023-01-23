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
//  axi4_ap broadcasts transactions of type axi4_master_rw_transaction_t 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class axi4_master_predictor #(
  type CONFIG_T,
  type axi4_master_rw_transaction_t
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( axi4_master_predictor #(
                              CONFIG_T,
                              axi4_master_rw_transaction_t
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;


  
  // Instantiate the analysis ports
  uvm_analysis_port #(axi4_master_rw_transaction_t) axi4_ap;

 
  // Instantiate QVIP analysis exports
  uvm_analysis_imp_axi4_ae #(mvc_sequence_item_base, axi4_master_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .axi4_master_rw_transaction_t(axi4_master_rw_transaction_t)
                              )) axi4_ae;

  // Transaction variable for predicted values to be sent out axi4_ap
  typedef axi4_master_rw_transaction_t axi4_ap_output_transaction_t;
  axi4_ap_output_transaction_t axi4_ap_output_transaction;
  // Code for sending output transaction out through axi4_ap
  // axi4_ap.write(axi4_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    axi4_ae = new("axi4_ae", this);
    axi4_ap =new("axi4_ap", this );
  endfunction


  // FUNCTION: write_axi4_ae
  // QVIP transactions received through axi4_ae initiate the execution of this function.
  // This function casts incoming QVIP transactions into the correct protocol type and then performs prediction 
  // of DUT output values based on DUT input, configuration and state
  virtual function void write_axi4_ae(mvc_sequence_item_base _t);
    // pragma uvmf custom axi4_ae_predictor begin
    axi4_master_rw_transaction_t t;
    if (!$cast(t,_t)) begin
      `uvm_fatal("PRED","Cast from mvc_sequence_item_base to axi4_master_rw_transaction_t in write_axi4_ae failed!")
    end
    `uvm_info("PRED", "Transaction Received through axi4_ae", UVM_MEDIUM)
    `uvm_info("PRED",{"            Data: ",t.convert2string()}, UVM_FULL)
    // Construct one of each output transaction type.
    axi4_ap_output_transaction = axi4_ap_output_transaction_t::type_id::create("axi4_ap_output_transaction");

    // Copy the transaction to avoid modifying the original transaction
    axi4_ap_output_transaction.copy(t);
 
    // zero out attributes which are a don't care for comparison...
    axi4_ap_output_transaction.addr_user_data              = 'b0;
    axi4_ap_output_transaction.address_valid_delay         = 'b0;
    axi4_ap_output_transaction.write_response_valid_delay  = 'b0;
    axi4_ap_output_transaction.address_ready_delay         = 'b0;
    axi4_ap_output_transaction.write_response_ready_delay  = 'b0;
    axi4_ap_output_transaction.write_data_with_address     = 'b0;
    axi4_ap_output_transaction.write_address_to_data_delay = 'b0;
    axi4_ap_output_transaction.write_data_to_address_delay = 'b0;
    axi4_ap_output_transaction.resp_user_data.delete();         // dynamic array
    axi4_ap_output_transaction.wdata_user_data.delete();        // dynamic array
    axi4_ap_output_transaction.data_valid_delay.delete();       // dynamic array
    axi4_ap_output_transaction.data_ready_delay.delete();       // dynamic array
    axi4_ap_output_transaction.write_data_beats_delay.delete(); // dynamic array

    // after adapter
    //axi4_ap_output_transaction.print();

    // Code for sending output transaction out through axi4_ap
    axi4_ap.write(axi4_ap_output_transaction);
    // pragma uvmf custom axi4_ae_predictor end
  endfunction
  
endclass 
