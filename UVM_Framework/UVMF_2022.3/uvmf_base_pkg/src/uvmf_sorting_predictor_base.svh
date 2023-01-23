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
// Unit            : Sorting Transformer
// File            : uvmf_sorting_predictor_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------


// CLASS: uvmf_sorting_predictor_base
// This class provides the interfaces and analysis ports for sorting an
// incoming transaction stream into two output streams. Classes derived from
// this class only need to define the port_0_transform an port_1_transform
// function. A non null return value from these functions allows the incoming
// transaction to be broadcast through the appropriate analysis port. If the
// return value of the transform function is null then nothing is broadcasted
// out of the analysis port on this component thereby filtering the incoming
// transaction.  This can be done in the case where multiple input transactions
// are required for a single output transaction.
//
// (see uvmf_sorting_predictor_base.jpg)
//
// PARAMETERS:
//       T  - Incoming transaction type.
//            Must be derived from uvmf_transaction_base.
//       P0 - Outgoing transaction type for port 0.
//            Must be derived from uvmf_transaction_base.
//       P1 - Outgoing transaction type for port 1.
//            Must be derived from uvmf_transaction_base.
//
// USAGE:
//   - Supported predicted modes
//  (start code)
//     1 transaction in 1 transaction out - 1:1
//     N transaction in 1 transaction out - N:1
//  (end)
//   - Unsupported predicted modes
//  (start code)
//     1 transaction in N transaction out - 1:N
//  (end)

virtual class uvmf_sorting_predictor_base #(
   type T = uvmf_transaction_base,
   type P0 = uvmf_transaction_base,
   type P1 = uvmf_transaction_base
) extends uvm_subscriber #(T);

  // Instantiate the analysis ports
  uvm_analysis_port #(P0) port_0_ap;
  uvm_analysis_port #(P1) port_1_ap;

  // FUNCTION: new
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction : new

  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
     // Build the analysis ports
     port_0_ap=new( "port_0_ap", this );
     port_1_ap=new( "port_1_ap", this );
  endfunction

  // FUNCTION: port_0_transform
  // Used to define the transform function for port 0. If the return value is
  // non null then the returned transaction is broadcasted out of port 0.
  pure virtual function P0 port_0_transform( input T t );

  // FUNCTION: port_1_transform
  // Used to define the transform function for port 1. If the return value is
  // non null then the returned transaction is broadcasted out of port 1.
  pure virtual function P1 port_1_transform( input T t );

  // FUNCTION: write
  // Automatically submit the incoming transaction t to each transform function. If
  // the return value is not null then broadcast out the appropriate analysis port.
  virtual function void write ( input T t );
     P0 p0;
     P1 p1;
     p0 = port_0_transform(t);
     p1 = port_1_transform(t);
     if ( p0 != null ) port_0_ap.write(p0);
     if ( p1 != null ) port_1_ap.write(p1);
  endfunction : write

endclass : uvmf_sorting_predictor_base
