//----------------------------------------------------------------------
//   Copyright 2013-2021 Siemens Corporation
//   Digital Industries Software
//   Siemens EDA
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
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVM Framework
// Unit            : Predictor Base
// File            : uvmf_predictor_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------


// CLASS: uvmf_predictor_base
// This class defines a base class to be used by components that predict a
// data stream. Classes derived from this class only need to define the
// <transform> function. If the return value of the <transform> function is
// non null then the object returned is broadcasted out of the analysis port
// on this component.  If the return value of the transform function is null
// then nothing is broadcasted out of the analysis port on this component
// thereby case where multiple input transactions are required for a single
// output transaction.
//
// (see uvmf_predictor_base.jpg)
//
// PARAMETERS:
//       T - Incoming transaction type. 
//           Must be derived from uvmf_transaction_base.
//       P - Outgoing transaction type. 
//           Must be derived from uvmf_transaction_base.
//
// USAGE:
//   - Supported predicted modes
//      (start code)
//     1 transaction in 1 transaction out - 1:1
//     N transaction in 1 transaction out - N:1
//     (end)
//   - Unsupported predicted modes
//    (start code)
//     1 transaction in N transaction out - 1:N
//    (end)

virtual class uvmf_predictor_base #(
   type T = uvmf_transaction_base, 
   type P = uvmf_transaction_base
) extends uvm_subscriber #(T);

  // Analysis port used to broadcast predicted, expected, results.
  uvm_analysis_port #(P) transformed_result_analysis_port;

  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction : new

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
     // Construct the analysis port
     transformed_result_analysis_port=new( "transformed_result_ap", this );
  endfunction

  // FUNCTION: transform
  // *[REQUIRED]* Defines the transform function of the predictor. This is
  // where the <predictor> does it's work of creating an expected value based
  // on what is sent into the DUT.
  //
  // ARGUMENTS:
  //    t - Transaction that was observed entering the DUT, of type *T*.
  //
  // RETURNS:
  //    p - Transaction expected to be observed coming out of the DUT, of type *P*
  pure virtual function P transform( input T t );

  // FUNCTION: write
  // The write function automatically submits the input transaction to the transform
  // function.  If the return value of the transform function is not null then the
  // transaction returned from the transform function is broadcast out the analysis
  // port.
  virtual function void write ( input T t );
     P transformed_result;
     transformed_result = transform(t);
     if (transformed_result != null) transformed_result_analysis_port.write(transformed_result);
  endfunction : write

endclass : uvmf_predictor_base
