//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_predictor 
// Unit            : FPU_predictor 
// File            : FPU_predictor.svh
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
//   FPU_in_agent_ae receives transactions of type  FPU_in_transaction #()  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  FPU_sb_ap broadcasts transactions of type FPU_in_transaction #() 
//

class FPU_predictor 
extends uvm_component;

  // Factory registration of this class
  `uvm_component_utils( FPU_predictor );

  // System Verilog variables for C function  fpu_compute (reqstruct req_data, rspstruct rsp_data) 
  reqstruct  req_data ;
  rspstruct  rsp_data ;

  // Instantiate a handle to the configuration of the environment in which this component resides
  FPU_env_configuration  configuration;

  // Instantiate the analysis exports
  uvm_analysis_imp_FPU_in_agent_ae #(FPU_in_transaction #(), FPU_predictor ) FPU_in_agent_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(FPU_in_transaction #()) FPU_sb_ap;

  // Transaction variable for predicted values to be sent out FPU_sb_ap
  typedef FPU_in_transaction #() FPU_sb_ap_output_transaction_t;
  FPU_sb_ap_output_transaction_t FPU_sb_ap_output_transaction;
  // Code for sending output transaction out through FPU_sb_ap
  // FPU_sb_ap.write(FPU_sb_ap_output_transaction);


  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    FPU_in_agent_ae = new("FPU_in_agent_ae", this);

    FPU_sb_ap =new("FPU_sb_ap", this );

  endfunction

  // FUNCTION: write_FPU_in_agent_ae
  // Transactions received through FPU_in_agent_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_FPU_in_agent_ae(FPU_in_transaction #() t);
    `uvm_info("COV", "Transaction Received through FPU_in_agent_ae", UVM_MEDIUM)
    `uvm_info("COV", {"            Data: ",t.convert2string()}, UVM_FULL)

  // Construct one of each output transaction type.
  FPU_sb_ap_output_transaction = FPU_sb_ap_output_transaction_t::type_id::create("FPU_sb_ap_output_transaction");

    // convert request transaction to stuct before passing over DPI
    req_data = t.to_struct;
	  
    // Calling C functions
    fpu_compute(req_data,rsp_data);
 
    // convert struct to class and return
    FPU_sb_ap_output_transaction = FPU_sb_ap_output_transaction.to_class(rsp_data);
 

    // Code for sending output transaction out through FPU_sb_ap
    FPU_sb_ap.write(FPU_sb_ap_output_transaction);
  endfunction

endclass 

