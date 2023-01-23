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
// Project         : AHB to WB Block Level Environment
// Unit            : Predictor
// File            : ahb2wb_predictor.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the predictor for the ahb to wb
//    environment.  This predictor predicts AHB to WB DUT operation.
//    Because data from AHB to WB read operations is the last value to
//    be driven by the DUT the WB transaction is used to predict the
//    expected AHB operation.
//
//----------------------------------------------------------------------
//
class ahb2wb_predictor #(type T=ahb_transaction, type P0=wb_transaction, type P1=ahb_transaction) extends uvmf_sorting_predictor_base#(T,P0,P1);
   `uvm_component_param_utils( ahb2wb_predictor #(T,P0,P1));

// ****************************************************************************
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

// ****************************************************************************
  virtual function P0 port_0_transform( input T t );
         P0 p0;
         if (t.op == AHB_WRITE ) begin  // AHB_WRITE
           p0 = P0::type_id::create("p0");
             p0.op   = WB_WRITE;
             p0.addr = t.addr;
             p0.data = t.data;

             `uvm_info("PREDICT",{"AHB Write Predicted: ",p0.convert2string()},UVM_MEDIUM);
         end
         return p0;
  endfunction

// ****************************************************************************
  virtual function P1 port_1_transform( input T t );
         P1 p1;
         if (t.op == AHB_READ) begin // AHB_READ
             p1 = t;
             `uvm_info("PREDICT",{"AHB Read Actual: ",t.convert2string()},UVM_MEDIUM);
         end
         return p1;
  endfunction

endclass

