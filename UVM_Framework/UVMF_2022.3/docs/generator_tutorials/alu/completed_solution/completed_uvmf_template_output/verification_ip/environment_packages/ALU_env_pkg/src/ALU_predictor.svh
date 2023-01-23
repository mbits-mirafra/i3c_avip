//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
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
//   ALU_in_agent_ae receives transactions of type  ALU_in_transaction #()  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  ALU_sb_ap broadcasts transactions of type ALU_out_transaction #() 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class ALU_predictor #(
  type CONFIG_T
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( ALU_predictor #(
                              CONFIG_T
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_ALU_in_agent_ae #(ALU_in_transaction #(), ALU_predictor #(
                              .CONFIG_T(CONFIG_T)
                              )) ALU_in_agent_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(ALU_out_transaction #()) ALU_sb_ap;


  // Transaction variable for predicted values to be sent out ALU_sb_ap
  typedef ALU_out_transaction #() ALU_sb_ap_output_transaction_t;
  ALU_sb_ap_output_transaction_t ALU_sb_ap_output_transaction;
  // Code for sending output transaction out through ALU_sb_ap
  // ALU_sb_ap.write(ALU_sb_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    ALU_in_agent_ae = new("ALU_in_agent_ae", this);
    ALU_sb_ap =new("ALU_sb_ap", this );
  endfunction

  // FUNCTION: write_ALU_in_agent_ae
  // Transactions received through ALU_in_agent_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_ALU_in_agent_ae(ALU_in_transaction #() t);
    // pragma uvmf custom ALU_in_agent_ae_predictor begin
    `uvm_info("PRED", "Transaction Received through ALU_in_agent_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    
    // Construct one of each output transaction type.
    ALU_sb_ap_output_transaction = ALU_sb_ap_output_transaction_t::type_id::create("ALU_sb_ap_output_transaction");
    
    //  UVMF_CHANGE_ME: Implement predictor model here.  
      case (t.op)
        add_op: begin
                   ALU_sb_ap_output_transaction.result = t.a + t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",ALU_sb_ap_output_transaction.convert2string()},UVM_MEDIUM);
                   // Code for sending output transaction out through alu_sb_ap
                   ALU_sb_ap.write(ALU_sb_ap_output_transaction);
                end
        and_op: begin
                   ALU_sb_ap_output_transaction.result = t.a & t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",ALU_sb_ap_output_transaction.convert2string()},UVM_MEDIUM);
                   // Code for sending output transaction out through alu_sb_ap
                   ALU_sb_ap.write(ALU_sb_ap_output_transaction);
                end
        xor_op: begin
                   ALU_sb_ap_output_transaction.result = t.a ^ t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",ALU_sb_ap_output_transaction.convert2string()},UVM_MEDIUM);
                   // Code for sending output transaction out through alu_sb_ap
                   ALU_sb_ap.write(ALU_sb_ap_output_transaction);
                end
        mul_op: begin
                   ALU_sb_ap_output_transaction.result = t.a * t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",ALU_sb_ap_output_transaction.convert2string()},UVM_MEDIUM);
                   // Code for sending output transaction out through alu_sb_ap
                   ALU_sb_ap.write(ALU_sb_ap_output_transaction);
                end
      endcase // case (op_set)
       
    // pragma uvmf custom ALU_in_agent_ae_predictor end
  endfunction


endclass 
