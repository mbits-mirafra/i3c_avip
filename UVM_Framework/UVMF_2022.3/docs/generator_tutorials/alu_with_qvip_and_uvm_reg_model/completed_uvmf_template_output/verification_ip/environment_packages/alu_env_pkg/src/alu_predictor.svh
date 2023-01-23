//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
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
//   alu_in_agent_ae receives transactions of type  alu_in_transaction #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  alu_sb_ap broadcasts transactions of type alu_out_transaction #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class alu_predictor #(
  type CONFIG_T,
  int ALU_IN_OP_WIDTH = 8,
  int ALU_OUT_RESULT_WIDTH = 16
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( alu_predictor #(
                              CONFIG_T,
                              ALU_IN_OP_WIDTH,
                              ALU_OUT_RESULT_WIDTH
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_alu_in_agent_ae #(alu_in_transaction #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)), alu_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH),
                              .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)
                              )) alu_in_agent_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(alu_out_transaction #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))) alu_sb_ap;


  // Transaction variable for predicted values to be sent out alu_sb_ap
  typedef alu_out_transaction #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)) alu_sb_ap_output_transaction_t;
  alu_sb_ap_output_transaction_t alu_sb_ap_output_transaction;
  // Code for sending output transaction out through alu_sb_ap
  // alu_sb_ap.write(alu_sb_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    alu_in_agent_ae = new("alu_in_agent_ae", this);
    alu_sb_ap =new("alu_sb_ap", this );
  endfunction

  // FUNCTION: write_alu_in_agent_ae
  // Transactions received through alu_in_agent_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_alu_in_agent_ae(alu_in_transaction #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)) t);
    // pragma uvmf custom alu_in_agent_ae_predictor begin
    `uvm_info("PRED", "Transaction Received through alu_in_agent_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    // Construct one of each output transaction type.
    alu_sb_ap_output_transaction = alu_sb_ap_output_transaction_t::type_id::create("alu_sb_ap_output_transaction");
    //  UVMF_CHANGE_ME: Implement predictor model here.  
  case (t.op)
      add_op: begin
                alu_sb_ap_output_transaction.result = t.a + t.b;
                `uvm_info("PREDICT", {"ALU_OUT: ",alu_sb_ap_output_transaction.convert2string()}, UVM_MEDIUM)
                // Code for sending output transaction out through alu_sb_ap
                alu_sb_ap.write(alu_sb_ap_output_transaction);
              end
      and_op: begin
                alu_sb_ap_output_transaction.result = t.a & t.b;
                `uvm_info("PREDICT", {"ALU_OUT: ",alu_sb_ap_output_transaction.convert2string()}, UVM_MEDIUM)
                // Code for sending output transaction out through alu_sb_ap
                alu_sb_ap.write(alu_sb_ap_output_transaction);
              end
      xor_op: begin
                alu_sb_ap_output_transaction.result = t.a ^ t.b;
                `uvm_info("PREDICT", {"ALU_OUT: ",alu_sb_ap_output_transaction.convert2string()}, UVM_MEDIUM)
                // Code for sending output transaction out through alu_sb_ap
                alu_sb_ap.write(alu_sb_ap_output_transaction);
              end
      mul_op: begin
                alu_sb_ap_output_transaction.result = t.a * t.b;
                `uvm_info("PREDICT", {"ALU_OUT: ",alu_sb_ap_output_transaction.convert2string()}, UVM_MEDIUM)
                // Code for sending output transaction out through alu_sb_ap
                alu_sb_ap.write(alu_sb_ap_output_transaction);
              end
  endcase
    // pragma uvmf custom alu_in_agent_ae_predictor end
  endfunction


endclass 
