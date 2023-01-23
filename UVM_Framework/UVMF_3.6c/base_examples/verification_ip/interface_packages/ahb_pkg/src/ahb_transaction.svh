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
// Unit            : Transaction
// File            : ahb_transaction.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the variables required for an ahb
//    transaction. Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------

class ahb_transaction extends uvmf_transaction_base;

  `uvm_object_utils( ahb_transaction )

  event read_complete;

  rand ahb_op_t                  op;
  rand bit [AHB_DATA_WIDTH-1:0] data;
  rand bit [AHB_ADDR_WIDTH-1:0] addr;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
  virtual function string convert2string();
      string msg;
      $sformat(msg,"op:%s addr:0x%h data:0x%h",op, addr, data);
      return msg;
  endfunction

//*******************************************************************
   virtual function void do_print(uvm_printer printer);
      if (printer.knobs.sprint==0)
        $display(convert2string());
      else
        printer.m_string = convert2string();
   endfunction

//*******************************************************************
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
      ahb_transaction RHS;
      if (!$cast(RHS,rhs)) return 0;
      else return (super.do_compare(rhs, comparer) &&
                  (this.op == RHS.op) &&
                  (this.addr == RHS.addr) &&
                  (this.data == RHS.data));
   endfunction : do_compare

// ****************************************************************************
  virtual function void add_to_wave( int transaction_viewing_stream_h );
    if ( transaction_view_h == 0)
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,op.name(),start_time);
    if      ( op == AHB_RESET ) $add_color( transaction_view_h, "red" );
    else if ( op == AHB_WRITE ) $add_color( transaction_view_h, "blue" );
    else if ( op == AHB_READ )  $add_color( transaction_view_h, "green" );

    $add_attribute( transaction_view_h, op, "op" );
    $add_attribute( transaction_view_h, addr, "addr" );
    $add_attribute( transaction_view_h, data, "data" );
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

// ****************************************************************************
   virtual function void unpack_fields();
   endfunction

// ****************************************************************************
   virtual function void pack_fields();
   endfunction

endclass
