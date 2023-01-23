//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
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
//   ahb_ae receives transactions of type  ahb_transaction  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  wb_ap broadcasts transactions of type wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH)) 
//  ahb_ap broadcasts transactions of type ahb_transaction 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class ahb2wb_predictor #(
  type CONFIG_T,
  int WB_DATA_WIDTH = 16,
  int WB_ADDR_WIDTH = 32
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( ahb2wb_predictor #(
                              CONFIG_T,
                              WB_DATA_WIDTH,
                              WB_ADDR_WIDTH
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_ahb_ae #(ahb_transaction, ahb2wb_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .WB_DATA_WIDTH(WB_DATA_WIDTH),
                              .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                              )) ahb_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH))) wb_ap;
  uvm_analysis_port #(ahb_transaction) ahb_ap;


  // Transaction variable for predicted values to be sent out wb_ap
  typedef wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH)) wb_ap_output_transaction_t;
  wb_ap_output_transaction_t wb_ap_output_transaction;
  // Code for sending output transaction out through wb_ap
  // wb_ap.write(wb_ap_output_transaction);
  // Transaction variable for predicted values to be sent out ahb_ap
  typedef ahb_transaction ahb_ap_output_transaction_t;
  ahb_ap_output_transaction_t ahb_ap_output_transaction;
  // Code for sending output transaction out through ahb_ap
  // ahb_ap.write(ahb_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    ahb_ae = new("ahb_ae", this);
    wb_ap =new("wb_ap", this );
    ahb_ap =new("ahb_ap", this );
  endfunction

  // FUNCTION: write_ahb_ae
  // Transactions received through ahb_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_ahb_ae(ahb_transaction t);
    // pragma uvmf custom ahb_ae_predictor begin
    `uvm_info("PRED", "Transaction Recievied through ahb_ae", UVM_MEDIUM)
    if (t.op == AHB_WRITE ) begin  // AHB_WRITE
        // Create transaction for sending to scoreboard
        wb_ap_output_transaction = wb_transaction#(.WB_ADDR_WIDTH(WB_ADDR_WIDTH),.WB_DATA_WIDTH(WB_DATA_WIDTH))::type_id::create("wb_ap_output_transaction");
        // Populate predicted fieldss
        wb_ap_output_transaction.op   = WB_WRITE;
        wb_ap_output_transaction.addr = t.addr;
        wb_ap_output_transaction.data = t.data;
        // Send transaction to expected side of scoreboard
        wb_ap.write(wb_ap_output_transaction);
        `uvm_info("PRED",{"WB Write Predicted: ",wb_ap_output_transaction.convert2string()},UVM_MEDIUM);
    end else if (t.op == AHB_READ) begin // AHB_READ
        // Send DUT output directly to actual side of scoreboard for comparison with expected
        ahb_ap.write(t);
        `uvm_info("PRED",{"AHB Read Actual: ",t.convert2string()},UVM_MEDIUM);
    end



    // pragma uvmf custom ahb_ae_predictor end
  endfunction


endclass 
