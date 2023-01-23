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
// Project         : AHB interface agent
// Unit            : Driver
// File            : ahb_driver.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM
//        through proxy tasks in the ahb configuration. This driver
//        passes transactions to the driver BFM through the access
//        task.
//
//----------------------------------------------------------------------
class ahb_driver extends uvmf_driver_base #(
   .CONFIG_T(ahb_configuration),
   .BFM_BIND_T(virtual ahb_driver_bfm),
   .REQ(ahb_transaction),
   .RSP(ahb_transaction)
);

  `uvm_component_utils( ahb_driver )

// ****************************************************************************
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(cfg.master_slave);

      //Alternative: using (possibly less efficient) class-struct conversion 
      //(see also ahb_driver_bfm.sv)
      //bfm.configure(cfg.to_struct());
   endfunction

// ****************************************************************************
   virtual task access(inout REQ txn);
      case (txn.op)
        AHB_WRITE: bfm.write(txn.addr, txn.data);
        AHB_READ:  bfm.read(txn.addr, txn.data);
        AHB_RESET: bfm.assert_hresetn();
      endcase
      if (txn.op == AHB_READ) ->txn.read_complete;

      //Alternative: implementing access task completely on HDL side
      //bfm.access(txn.op, txn.addr, txn.data, txn.data);

      //Alternative: using (possibly less efficient) class-struct conversion 
      //(see also ahb_driver_bfm.sv)
      //bfm.access(txn.to_struct(), txn.data);
   endtask

endclass
