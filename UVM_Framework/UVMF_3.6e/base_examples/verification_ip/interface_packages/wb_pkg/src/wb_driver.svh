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
// Project         : WB interface agent
// Unit            : Driver
// File            : wb_driver.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM
//        through proxy tasks in the wb configuration. This driver
//        passes transactions to the driver BFM through the access
//        task.
//
//----------------------------------------------------------------------
class wb_driver extends uvmf_driver_base #(
      .CONFIG_T(wb_configuration),
      .BFM_BIND_T(virtual wb_driver_bfm),
      .REQ(wb_transaction),
      .RSP(wb_transaction)
      );

  `uvm_component_utils(wb_driver);

//**********************************************************************
  function new(string name = "", uvm_component parent=null);
    super.new(name, parent);
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(cfg.master_slave);
   endfunction

// ****************************************************************************
  virtual task run_phase(uvm_phase phase);
    REQ txn;
    forever
      begin : forever_loop
        if ( configuration.master_slave == MASTER) begin
          seq_item_port.get_next_item(txn);
          access(txn);
          seq_item_port.item_done(txn);
      end else begin
          seq_item_port.get(txn);
          access(txn);
      end
    end : forever_loop
  endtask

// ****************************************************************************
   virtual task access(inout REQ txn);
      case (txn.op)
        WB_RESET: begin
           bfm.reset();
        end
        WB_WRITE: begin
           bfm.write(txn.addr, txn.data/*, txn.delay*/);
        end
        WB_READ : begin
           bfm.read(txn.addr, txn.data/*, txn.delay*/);
        end
        WB_SLAVE: begin
           bfm.slave(txn.op, txn.addr, txn.data);
           ->txn.slave_op_started;
           if (txn.op == WB_READ) begin
              @(txn.slave_op_complete);
              bfm.slave_read_ack(txn.data);
           end
           bfm.slave_complete();
        end
      endcase
   endtask

/* Do we care about exact cycle at which slave_op_started is triggered for writes?
   If not can treat writes separately in one go, saving 1 callee (slave_complete()) - test indeed still runs fine
        WB_SLAVE: begin
           bfm.slave(txn.op, txn.addr, txn.data); // Write now completely finished
           ->txn.slave_op_started;
           if (txn.op == WB_READ) begin
              @(txn.slave_op_complete);
              bfm.slave_read_ack(txn.data);
              bfm.slave_complete();
           end
        end
   In fact, do we even care about this for reads, and do we really need to wait for slave_op_completed?
   If not can treat reads also separately in one go, saving 2 callees (slave_read_ack(), slave_complete()) - test indeed still runs fine
        WB_SLAVE: begin
           bfm.slave(txn.op, txn.addr, txn.data); // Write and read now completely finished
           ->txn.slave_op_started;
        end
*/


endclass
