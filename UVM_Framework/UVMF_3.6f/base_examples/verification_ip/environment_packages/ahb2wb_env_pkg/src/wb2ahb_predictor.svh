//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2ahb_predictor 
// Unit            : wb2ahb_predictor 
// File            : wb2ahb_predictor.svh
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
//   wb_ae receives transactions of type  wb_transaction  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  wb_ap broadcasts transactions of type wb_transaction 
//  ahb_ap broadcasts transactions of type ahb_transaction 
//

class wb2ahb_predictor #(int WB_ADDR_WIDTH = 32,int WB_DATA_WIDTH = 16) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( wb2ahb_predictor#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) );

  // Instantiate the analysis exports
  uvm_analysis_imp_wb_ae #(wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)), wb2ahb_predictor ) wb_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))) wb_ap;
  uvm_analysis_port #(ahb_transaction) ahb_ap;

  // Transaction variable for predicted values to be sent out wb_ap
  wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) wb_ap_output_transaction;
  // Code for sending output transaction out through wb_ap
  // wb_ap.write(wb_ap_output_transaction);

  // Transaction variable for predicted values to be sent out ahb_ap
  ahb_transaction ahb_ap_output_transaction;
  // Code for sending output transaction out through ahb_ap
  // ahb_ap.write(ahb_ap_output_transaction);


  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    wb_ae = new("wb_ae", this);

    wb_ap =new("wb_ap", this );
    ahb_ap =new("ahb_ap", this );

  endfunction

  // FUNCTION: write_wb_ae
  // Transactions received through wb_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_wb_ae(wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH)) t);
    `uvm_info("wb2ahb_predictor", "Transaction Recievied through wb_ae", UVM_MEDIUM)
    if (t.op == WB_WRITE ) begin  // WB_WRITE
      // Send DUT output transaction directly to scoareboard for commparison with expected
      wb_ap.write(t);
      `uvm_info("PREDICT",{"AHB Write Actual: ",t.convert2string()},UVM_MEDIUM);
    end else if (t.op == WB_READ) begin // WB_READ
      // Construct expected transaction for sending to wb2ahb scorebaord
      ahb_ap_output_transaction = ahb_transaction::type_id::create("ahb_ap_output_transaction");
      // Set predicted transaction variable values
      ahb_ap_output_transaction.op   = AHB_READ;
      ahb_ap_output_transaction.addr = t.addr;
      ahb_ap_output_transaction.data = t.data;
      // Send predicted transaction to expected side of scoreboard to be held for comparison against DUT output transaction
      ahb_ap.write(ahb_ap_output_transaction);
      `uvm_info("PREDICT",{"AHB Read Predicted: ",ahb_ap_output_transaction.convert2string()},UVM_MEDIUM);
         end
    
  endfunction

endclass 

