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
//   wb_ae receives transactions of type  wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH))  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  wb2spi_sb_ap broadcasts transactions of type spi_transaction 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class wb2spi_predictor #(
  type CONFIG_T,
  int WB_DATA_WIDTH = 16,
  int WB_ADDR_WIDTH = 32
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( wb2spi_predictor #(
                              CONFIG_T,
                              WB_DATA_WIDTH,
                              WB_ADDR_WIDTH
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_wb_ae #(wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH)), wb2spi_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .WB_DATA_WIDTH(WB_DATA_WIDTH),
                              .WB_ADDR_WIDTH(WB_ADDR_WIDTH)
                              )) wb_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(spi_transaction) wb2spi_sb_ap;


  // Transaction variable for predicted values to be sent out wb2spi_sb_ap
  typedef spi_transaction wb2spi_sb_ap_output_transaction_t;
  wb2spi_sb_ap_output_transaction_t wb2spi_sb_ap_output_transaction;
  // Code for sending output transaction out through wb2spi_sb_ap
  // wb2spi_sb_ap.write(wb2spi_sb_ap_output_transaction);

  // pragma uvmf custom class_item_additional begin

  // Prediction variables
  bit[7:0] next_miso_predicted;
  bit [3:0] mem [7:0];



  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    wb_ae = new("wb_ae", this);
    wb2spi_sb_ap =new("wb2spi_sb_ap", this );
  endfunction

  // FUNCTION: write_wb_ae
  // Transactions received through wb_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_wb_ae(wb_transaction #(.WB_DATA_WIDTH(WB_DATA_WIDTH), .WB_ADDR_WIDTH(WB_ADDR_WIDTH)) t);
    // pragma uvmf custom wb_ae_predictor begin
    if (t.op == WB_WRITE && t.addr == 'd2) begin 
      `uvm_info("PRED",{"RECEIVED: ",t.convert2string()},UVM_MEDIUM);
      // Predict SPI operation
      wb2spi_sb_ap_output_transaction = wb2spi_sb_ap_output_transaction_t::type_id::create("wb2spi_sb_ap_output_transaction");
      // MISO is result of last MOSI
      wb2spi_sb_ap_output_transaction.miso_data = next_miso_predicted;
      // MOSI will be presented on SPI bus
      wb2spi_sb_ap_output_transaction.mosi_data = t.data;
      // Broadcast predicted value
      wb2spi_sb_ap.write(wb2spi_sb_ap_output_transaction);
      `uvm_info("PRED",{"PREDICTED: ",wb2spi_sb_ap_output_transaction.convert2string()},UVM_MEDIUM);

      // Predict next MISO value and update memory
      if (t.data[7] == 0 ) begin // SPI Slave read operation
        // predict miso for read operation
        next_miso_predicted[7:4] = t.data[7:4];
        next_miso_predicted[3:0] = mem[t.data[6:4]];
      end else begin // SPI Slave write operation
        // update the memory
        mem[t.data[6:4]] = t.data[3:0];
        // predict miso for write operation
        next_miso_predicted = t.data;
      end
      // Set success bit for next miso predicted as design will
      next_miso_predicted[7] = 1'b1;
    end



    // pragma uvmf custom wb_ae_predictor end
  endfunction


endclass 
