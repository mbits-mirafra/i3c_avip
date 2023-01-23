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
// Project         : spi interface agent
// Unit            : Transaction viewer
// File            : spi_transaction_coverage.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class creates a waveform transaction viewing stream
//  for spi mem slave transactions from the spi agent
//
//----------------------------------------------------------------------
//
class spi_mem_slave_transaction_viewer extends uvm_subscriber#(.T(spi_transaction));

  `uvm_component_utils( spi_mem_slave_transaction_viewer )

  spi_mem_slave_transaction spi_mem_transaction=new;

  spi_configuration configuration;

  // Handle used for transaction viewing
  int transaction_viewing_stream;

  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
 endfunction

   // FUNCTION: start_of_simulation_phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
     if (configuration.enable_transaction_viewing)
       transaction_viewing_stream = $create_transaction_stream({"..",get_full_name(),".","txn_stream"});
    endfunction

  virtual function void write (T t);
    `uvm_info("VIEW","Received transaction",UVM_LOW);
    if ( configuration.enable_transaction_viewing ) begin
       spi_mem_transaction.do_copy(t);
       spi_mem_transaction.unpack_fields();
       spi_mem_transaction.add_to_wave(transaction_viewing_stream);
    end
  endfunction

endclass
