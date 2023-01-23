//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   nand_out_pred_sb_ae receives transactions of type  nand_out_transaction  
//   nand_out_ag_sb_ae receives transactions of type  nand_out_transaction  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//


class nand_scoreboard #(
  type CONFIG_T,
  type BASE_T = uvm_component
  ) extends BASE_T;

  // Factory registration of this class
  `uvm_component_param_utils( nand_scoreboard #(
                              CONFIG_T,
                              BASE_T
                              ))

  bit y_p, y_a;

// Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_nand_out_pred_sb_ae #(nand_out_transaction, nand_scoreboard #(
                              .CONFIG_T(CONFIG_T),
                              .BASE_T(BASE_T)
                              )) nand_out_pred_sb_ae;
  uvm_analysis_imp_nand_out_ag_sb_ae #(nand_out_transaction, nand_scoreboard #(
                              .CONFIG_T(CONFIG_T),
                              .BASE_T(BASE_T)
                              )) nand_out_ag_sb_ae;




  // pragma uvmf custom class_item_additional begini
  virtual function void comparing();
  if(y_p == y_a)begin
    `uvm_info("NAND_SCOREBOARD", $sformatf("nand output:%0d", y_p), UVM_LOW)
    `uvm_info("SCOREBOARD", "compare sucess", UVM_LOW)
  end
  else
  begin
    `uvm_warning("SCOREBOARD", "compare_failed")
  end
endfunction
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  // pragma uvmf custom new begin
  // pragma uvmf custom new end
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    nand_out_pred_sb_ae = new("nand_out_pred_sb_ae", this);
    nand_out_ag_sb_ae = new("nand_out_ag_sb_ae", this);
  // pragma uvmf custom build_phase begin
  // pragma uvmf custom build_phase end
  endfunction

  // FUNCTION: write_nand_out_pred_sb_ae
  // Transactions received through nand_out_pred_sb_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_nand_out_pred_sb_ae(nand_out_transaction t);
    // pragma uvmf custom nand_out_pred_sb_ae_scoreboard begin
    `uvm_info("PRED", "Transaction Received through nand_out_pred_sb_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    //  UVMF_CHANGE_ME: Implement custom scoreboard here.
    this.y_p = t.y;
//    `uvm_info("UNIMPLEMENTED_CUSTOM_SCOREBOARD", "******************************************************************************************************",UVM_NONE)
  //  `uvm_info("UNIMPLEMENTED_CUSTOM_SCOREBOARD", "UVMF_CHANGE_ME: The nand_scoreboard::write_nand_out_pred_sb_ae function needs to be completed with custom scoreboard functionality",UVM_NONE)
    //`uvm_info("UNIMPLEMENTED_CUSTOM_SCOREBOARD", "******************************************************************************************************",UVM_NONE)
 `uvm_info("nand_out_pred_sb_ae", $sformatf("y=%0b", y_p),UVM_LOW)
    // pragma uvmf custom nand_out_pred_sb_ae_scoreboard end
  endfunction

  // FUNCTION: write_nand_out_ag_sb_ae
  // Transactions received through nand_out_ag_sb_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_nand_out_ag_sb_ae(nand_out_transaction t);
    // pragma uvmf custom nand_out_ag_sb_ae_scoreboard begin
    `uvm_info("PRED", "Transaction Received through nand_out_ag_sb_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    //  UVMF_CHANGE_ME: Implement custom scoreboard here.  
     this.y_a = t.y;

 `uvm_info("nand_out_ag_sb_ae", $sformatf("y_a=%0b", y_a),UVM_LOW)
//    `uvm_info("UNIMPLEMENTED_CUSTOM_SCOREBOARD", "******************************************************************************************************",UVM_NONE)
  //  `uvm_info("UNIMPLEMENTED_CUSTOM_SCOREBOARD", "UVMF_CHANGE_ME: The nand_scoreboard::write_nand_out_ag_sb_ae function needs to be completed with custom scoreboard functionality",UVM_NONE)
    //`uvm_info("UNIMPLEMENTED_CUSTOM_SCOREBOARD", "******************************************************************************************************",UVM_NONE)
 
    // pragma uvmf custom nand_out_ag_sb_ae_scoreboard end
  endfunction



  // FUNCTION: extract_phase
  virtual function void extract_phase(uvm_phase phase);
// pragma uvmf custom extract_phase begin
     super.extract_phase(phase);
// pragma uvmf custom extract_phase end
  endfunction

  // FUNCTION: check_phase
  virtual function void check_phase(uvm_phase phase);
// pragma uvmf custom check_phase begin
     super.check_phase(phase);
     comparing();
// pragma uvmf custom check_phase end
  endfunction

  // FUNCTION: report_phase
  virtual function void report_phase(uvm_phase phase);
// pragma uvmf custom report_phase begin
     super.report_phase(phase);
// pragma uvmf custom report_phase end
  endfunction

endclass 

// pragma uvmf custom external begin
// pragma uvmf custom external end

