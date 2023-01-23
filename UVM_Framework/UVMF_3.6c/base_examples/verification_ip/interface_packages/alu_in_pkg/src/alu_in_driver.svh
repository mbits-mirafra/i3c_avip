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
// File            : alu_in_driver.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM
//        through proxy tasks in the alu_in configuration. This driver
//        passes transactions to the driver BFM through the access
//        task.
//
// ****************************************************************************
class alu_in_driver extends uvmf_driver_base #(
   .CONFIG_T(alu_in_configuration),
   .BFM_BIND_T(virtual alu_in_driver_bfm),
   .REQ(alu_in_transaction),
   .RSP(alu_in_transaction)
);

  `uvm_component_utils( alu_in_driver )

// ****************************************************************************
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.set_clock_period(cfg.clock_period);
   endfunction

// ****************************************************************************
   virtual task access(inout REQ txn);
      bfm.access(txn.to_struct());
   endtask

endclass
