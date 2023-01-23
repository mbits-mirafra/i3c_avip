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
// Unit            : Transaction base
// File            : uvmf_transaction_base.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_transaction_base
// This class defines a transacion base class that defines interface functions
// and provides debug utilities. Interface methods and debug methods are
// described below.
class uvmf_transaction_base #(type BASE_T = uvm_sequence_item) extends BASE_T;

  // STRING: report_id
  // This needs to be the full name of the transaction and can be used for debug
  string report_id;

  // INT: global_transaction_count
  // This is a static variable that provides a unique number for each transaction
  // created
  static int unsigned global_transaction_count;

  // INT: unique_transaction_id
  // This is initialized to this objects unique ID when the object is constructed.
  // It is used in conjunction with the ID field of the UVM reporting to group all
  // messages related to this transaction regardless of where the report message
  // was generated.
  int unsigned unique_transaction_id;

  // INT: key
  // This is used to uniquely identify this transaction when using the out of order
  // scoreboard. It is also used to identify a logical stream this transaction
  // belongs to when using the in order scoreboard array.
  // The key field is used by the uvmf_out_of_order_scoreboard as the hash key.
  // The key field is used by the uvmf_in_order_scoreboard_array as the channel identifier.
  int unsigned key;

  // time: start_time, end_time
  // Start and end times are used for transaction recording but can also be used for
  // scoreboarding and coverage collection. These are expected to be populated by
  // the monitor (or driver) at the appropriate time during any given transaction.
  time start_time, end_time;

  // INT: duration
  // This is used to represent the duration of this transaction (by user discretion
  // in clock cycles or unit delay), defined as the time between above start 
  // and end times. It can be a useful alternative to explicit start and end times
  // where these times may not be accurately known. For instance, with co-emulation 
  // s/w-h/w transaction boundaries must coincide with function call boundaries,
  // making it sometimes difficult to set start time accurately because $time
  // is not (currently) supported as XRTL modeling construct.
  int duration; 

  // uvm_status_e: transaction_status
  // This is used to communicate the status of the bus operation from the BFM to
  // the UVM component.  For example, the driver BFM uses this flag to indicate 
  // to the UVM driver the status of the bus operation.
  uvm_status_e transaction_status;

  // INT: transaction_view_h
  // Transaction viewing handle is used for viewing this transaction within the GUI
  int transaction_view_h;

  // FUNCTION: new
  function new(string name="");
     super.new(name);
     report_id = name;
     unique_transaction_id = global_transaction_count++;
  endfunction


//*******************************************************************
      function void do_copy (uvm_object rhs);
          uvmf_transaction_base RHS;
          assert($cast(RHS,rhs));
          super.do_copy(rhs);
          this.report_id = RHS.report_id;
          this.unique_transaction_id = RHS.global_transaction_count++;
          this.key = RHS.key;
          this.start_time = RHS.start_time;
          this.end_time = RHS.end_time;
          this.duration = RHS.duration;
          this.transaction_status = RHS.transaction_status;
          this.transaction_view_h = RHS.transaction_view_h;
   endfunction : do_copy

  // FUNCTION: get_unique_transaction_id
  // This function converts <unique_transaction_id> to a string.
  // This function can be used with the ID field of the reporting functions
  // to sort messages based on the transactions <unique_transaction_id>
  //
  // RETURNS:
  //      string - used with UVM reporting mechanism.
  function string get_unique_transaction_id();
     return $sformatf("%32d", unique_transaction_id);
  endfunction

  // FUNCTION: build_msg_id
  // This function appends a string header to the <unique_transaction_id> for use with
  // the UVM reporting mechanism.  The string can be used to identify where the message
  // was generated.  Appending the unique id allows the Questa Message Viewer to group
  // all messages for this transaction
  //
  // RETURNS:
  //     string - used with UVM reporting mechanism.
  function string build_msg_id(string header);
     return {header, "_", $sformatf("%32d", unique_transaction_id)};
  endfunction

  // FUNCTION: sample_coverage
  // Can be overloaded by the derived class in order to sample coverage.
  virtual function void sample_coverage ();
  endfunction

  // FUNCTION: add_to_wave
  // Questa system function calls to add transaction variables to the transaction
  // handle for viewing transactions in the wave form viewer
  virtual function void add_to_wave(int transaction_viewing_stream_h);
  `ifdef QUESTA
    if ( transaction_view_h == 0)
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"Transaction",start_time);
    $add_attribute( transaction_view_h, unique_transaction_id, "unique_transaction_id" );
  `endif // QUESTA
  endfunction

  // FUNCTION: convert2string
  // Has <unique_transaction_id>, but will need to added to by derived classs.
  virtual function string convert2string();
       return $psprintf(" unique_transaction_id=%d key=%d", unique_transaction_id, key);
  endfunction

  // FUNCTION: set_key
  // This function sets the key field from fields in the derived class.
  virtual function void set_key(int unsigned new_key);
     key = new_key;
  endfunction

  // FUNCTION: get_key
  // This function returns the value of the key.
  virtual function int unsigned get_key();
    return key;
  endfunction

endclass : uvmf_transaction_base
