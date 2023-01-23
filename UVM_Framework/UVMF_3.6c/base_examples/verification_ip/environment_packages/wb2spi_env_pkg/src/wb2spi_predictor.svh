//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : WB to SPI Environment Example
// Unit            : Predictor.
// File            : wb2spi_predictor.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class observes WB transactions and predicts SPI
//   transactions.  From the WB transaction the MOSI and next MISO 
//   transactions are predicted.  This prediction is done using a 
//   model of the memory contained in the SPI slave.  When a memory
//   write is performed through the WB the internal memory model is
//   updated.  When a memory read is done through the WB the predicted
//   read value is obtained from the memory model in this predictor.
//
//----------------------------------------------------------------------
//
class wb2spi_predictor extends uvm_subscriber#(.T(wb_transaction));
   `uvm_component_utils( wb2spi_predictor );



  uvm_analysis_port #(spi_transaction) transformed_result_analysis_port;
  spi_transaction next_miso_predicted=new;
  bit [3:0] mem [7:0];

// ****************************************************************************
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

// ****************************************************************************
  virtual function void build();
     super.build();
     transformed_result_analysis_port=new( "transformed_result_ap", this );
     next_miso_predicted.dir = MISO; // Setup for first miso transaction
  endfunction : build

// ****************************************************************************
  virtual function void write ( input T t );
      spi_transaction mosi_predicted=new;
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
            transformed_result_analysis_port.write(mosi_predicted);
            // Send previously predicted MISO
            `uvm_info("PREDICT",{"SPI-miso: ",next_miso_predicted.convert2string()},UVM_HIGH);
            transformed_result_analysis_port.write(next_miso_predicted);
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
