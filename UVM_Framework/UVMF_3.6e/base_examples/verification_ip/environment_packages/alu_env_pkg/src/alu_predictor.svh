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
// File            : alu_predictor.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the predictor for the alu_out to alu_in
//    environment.  This predictor predicts AHB to WB DUT operation.
//    Because data from AHB to WB read operations is the last value to
//    be driven by the DUT the WB transaction is used to predict the
//    expected AHB operation.
//
//----------------------------------------------------------------------
//
class alu_predictor #(type T=alu_in_transaction, type P=alu_out_transaction) extends uvmf_predictor_base#(T,P);
   `uvm_component_param_utils( alu_predictor #(T,P));

// ****************************************************************************
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

// ****************************************************************************
  virtual function P transform ( input T t );
      P predicted;
         `uvm_info("PREDICT",{"ALU_IN: ",t.convert2string()},UVM_MEDIUM);

      case (t.op)
        add_op: begin
                   predicted=new;
                   predicted.result = t.a + t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",predicted.convert2string()},UVM_MEDIUM);
                end
        and_op: begin
                   predicted=new;
                   predicted.result = t.a & t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",predicted.convert2string()},UVM_MEDIUM);
                end
        xor_op: begin
                   predicted=new;
                   predicted.result = t.a ^ t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",predicted.convert2string()},UVM_MEDIUM);
                end
        mul_op: begin
                   predicted=new;
                   predicted.result = t.a * t.b;
                   `uvm_info("PREDICT",{"ALU_OUT: ",predicted.convert2string()},UVM_MEDIUM);
                end
      endcase // case (op_set)

      return (predicted);

  endfunction

endclass
