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
// Unit            : Driver
// File            : spi_driver.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM
//        through proxy tasks in the spi configuration. This driver
//        passes transactions to the driver BFM through the access
//        task.
//
//----------------------------------------------------------------------
//
class spi_driver extends uvmf_driver_base #(.CONFIG_T(spi_configuration),
                                            .BFM_BIND_T(virtual spi_driver_bfm),
                                            .REQ(spi_transaction),
                                            .RSP(spi_transaction));

  `uvm_component_utils( spi_driver )

  REQ miso_transaction;
  RSP mosi_transaction;

  int miso_transaction_view_h;
  int mosi_transaction_view_h;

// ****************************************************************************
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(cfg.to_struct());
   endfunction

// ****************************************************************************
   virtual task access(inout REQ txn);
      spi_transaction spi_txn;
      $cast(spi_txn, txn);
      case (spi_txn.dir)
        TO_SPI:   bfm.put_spi_dout(spi_txn.to_struct());
        FROM_SPI: bfm.get_spi_din(spi_txn.to_struct(), spi_txn.spi_data);
      endcase
   endtask

// ****************************************************************************
   task get_outgoing_byte_from_sequence();
      REQ tmp;

      seq_item_port.get_next_item(miso_transaction);
      miso_transaction.pack_fields();
      miso_transaction.dir = TO_SPI;
      if (!$cast(tmp,miso_transaction)) `uvm_fatal("CAST", "Error casting");
      access(tmp);
      if (!$cast(miso_transaction,tmp)) `uvm_fatal("CAST", "Error casting");
      seq_item_port.item_done();
   endtask

// ****************************************************************************
   task send_incoming_byte_to_sequence();
      REQ tmp;

      mosi_transaction=RSP::type_id::create("mosi_transaction");
      mosi_transaction.set_id_info(miso_transaction);
      mosi_transaction.dir = FROM_SPI;
      if (!$cast(tmp,mosi_transaction)) `uvm_fatal("CAST", "Error casting");
      access(tmp);
      if (!$cast(mosi_transaction,tmp)) `uvm_fatal("CAST", "Error casting");
      mosi_transaction.unpack_fields();
      seq_item_port.put(mosi_transaction);
   endtask

// ****************************************************************************
   virtual task run_phase(uvm_phase phase);
      forever begin
         get_outgoing_byte_from_sequence();
         send_incoming_byte_to_sequence();
      end
   endtask

endclass
