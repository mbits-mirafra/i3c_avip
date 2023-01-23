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
// Project         : gpio interface agent
// Unit            : Driver
// File            : gpio_driver.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM
//        through proxy tasks in the gpio configuration. This driver
//        passes transactions to the driver BFM through the access
//        task.
//
//----------------------------------------------------------------------
//
class gpio_driver #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) extends uvmf_driver_base #(
   .CONFIG_T(gpio_configuration #(READ_PORT_WIDTH, WRITE_PORT_WIDTH)),
   .BFM_BIND_T(virtual gpio_driver_bfm#(READ_PORT_WIDTH,WRITE_PORT_WIDTH)),
   .REQ(gpio_transaction #(READ_PORT_WIDTH, WRITE_PORT_WIDTH)),
   .RSP(gpio_transaction #(READ_PORT_WIDTH, WRITE_PORT_WIDTH))
);

  `uvm_component_param_utils( gpio_driver #(READ_PORT_WIDTH,WRITE_PORT_WIDTH) )

   protected REQ read_port_txn; // HANS: BZ 73776


// ****************************************************************************
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
     // Conveniently set driver BFM back-pointer handle to this BFM API here.
     // (doesn't work in 'new' since that gets called before vif 'bfm' is bound)
     bfm.proxy = this;
   endfunction

// ****************************************************************************
   virtual task access(inout REQ txn);
      if ( txn.op == GPIO_WR ) begin
         bfm.write(txn.write_port);
      end
      else if ( txn.op == GPIO_RD ) begin
         // A GPIO_RD comes into this task typically just once to kick off
         // an autonomous read port monitoring process, which then continuously
         // provides read port change notifications that are relayed to upper
         // layer sequences.
         // This is implemented here by having a class member transaction object
         // handle point to the same object as the task inout argument txn.
         // Any read port change notification is then indicated via this shared
         // object using the notify_read_port_change function below, called from
         // the GPIO driver BFM via the 'proxy' backpointer set above.
         this.read_port_txn = txn;
         bfm.start_read_daemon();
      end
   endtask

// ****************************************************************************
   virtual function void notify_read_port_change(input bit [READ_PORT_WIDTH-1:0] data);
      this.read_port_txn.read_port = data;    // Place read port value into transaction
      -> this.read_port_txn.read_port_change; // Signal sequence of read port change
   endfunction

endclass

