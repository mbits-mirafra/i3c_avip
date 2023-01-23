//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 09
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb2spi_predictor 
// Unit            : wb2spi_predictor 
// File            : wb2spi_predictor.svh
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
//  wb2spi_sb_ap broadcasts transactions of type spi_transaction 
//

class wb2spi_predictor extends uvm_component;

  // Factory registration of this class
  `uvm_component_utils( wb2spi_predictor );

  // Instantiate the analysis exports
  uvm_analysis_imp_wb_ae #(wb_transaction, wb2spi_predictor ) wb_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(spi_transaction) wb2spi_sb_ap;

  // Prediction variables
  spi_transaction next_miso_predicted=new;
  bit [3:0] mem [7:0];



  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    wb_ae = new("wb_ae", this);

    wb2spi_sb_ap =new("wb2spi_sb_ap", this );

    // Setup for first miso transaction
    next_miso_predicted.dir = MISO; 

  endfunction

  // FUNCTION: write_wb_ae
  // Transactions received through wb_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_wb_ae(wb_transaction t);
    spi_transaction mosi_predicted=new;

    `uvm_info("wb2spi_predictor", "Transaction Recievied through wb_ae", UVM_MEDIUM)
        `uvm_info("PREDICT",{"WB: ",t.convert2string()},UVM_HIGH);
        if (t.op == WB_WRITE && t.addr == 'd2) begin 
            // Predict MOSI
            // if (t.data[7] == 1) mosi_predicted.op = SPI_SLAVE_WRITE;
            // else                mosi_predicted.op = SPI_SLAVE_READ;
            mosi_predicted.dir = MOSI;
            // mosi_predicted.command = t.data[7];
            mosi_predicted.spi_data[7] = t.data[7];
            // mosi_predicted.addr = t.data[6:4];
            mosi_predicted.spi_data[6:4] = t.data[6:4];
            // mosi_predicted.data = t.data[3:0];
            mosi_predicted.spi_data[3:0] = t.data[3:0];
            `uvm_info("PREDICT",{"SPI-mosi: ",mosi_predicted.convert2string()},UVM_HIGH);
            wb2spi_sb_ap.write(mosi_predicted);
            // Send previously predicted MISO
            `uvm_info("PREDICT",{"SPI-miso: ",next_miso_predicted.convert2string()},UVM_HIGH);
            wb2spi_sb_ap.write(next_miso_predicted);
            // Predict next MISO
            next_miso_predicted = new mosi_predicted;
            next_miso_predicted.dir = MISO;
            // next_miso_predicted.command = 0;
            // next_miso_predicted.status = 1;
            next_miso_predicted.spi_data[7] = 1;
            next_miso_predicted.spi_data[6:4] = t.data[6:4];
            if (t.data[7] == 0 ) begin // SPI Slave read operation
               // next_miso_predicted.data = mem[next_miso_predicted.addr];
               next_miso_predicted.spi_data[3:0] = mem[t.data[6:4]];
            end else begin // SPI Slave write operation
               // mem[t.data[6:4]] = t.data[3:0];
               mem[t.data[6:4]] = t.data[3:0];
               next_miso_predicted.spi_data[3:0] = t.data[3:0];
            end
         end

  endfunction

endclass 

