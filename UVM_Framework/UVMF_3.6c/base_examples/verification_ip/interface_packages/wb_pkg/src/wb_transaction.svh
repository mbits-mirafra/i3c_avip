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
// Unit            : Transaction
// File            : wb_transaction.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the variables required for an wb
//    transaction. Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//
class wb_transaction extends uvmf_transaction_base;
   `uvm_object_utils(wb_transaction)

   int delay=0;
   rand bit [WB_ADDR_WIDTH-1:0] addr;
   rand bit [WB_DATA_WIDTH-1:0] data;
   rand bit [2:0] byte_select;
   rand wb_op_t       op;
   event read_complete;
   event slave_op_started;
   event slave_op_complete;
   //rand unsigned int burst_length;


//*******************************************************************
   function new(string name="");
      super.new(name);
   endfunction

//*******************************************************************
   virtual function void add_to_wave(int transaction_viewing_stream_h);
    if ( transaction_view_h == 0)
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,op.name(),start_time);
      if      ( op == WB_RESET ) $add_color( transaction_view_h, "red" );
      else if ( op == WB_WRITE ) $add_color( transaction_view_h, "blue" );
      else if ( op == WB_READ )  $add_color( transaction_view_h, "green" );
      super.add_to_wave(transaction_view_h);
      $add_attribute(transaction_view_h, op, "op");
      $add_attribute(transaction_view_h, addr, "addr");
      $add_attribute(transaction_view_h, data, "data");
      $add_attribute(transaction_view_h, byte_select, "byte_select");
      $end_transaction(transaction_view_h,end_time);
      $free_transaction(transaction_view_h);
   endfunction

//*******************************************************************
   function string convert2string();
      // $sformat(s, "%p", this);
      return $sformatf("T(%s, addr:%0h, data:%0h)", op, addr, data);
   endfunction

//*******************************************************************
   function void do_copy (uvm_object rhs);
      wb_transaction RHS;
      super.do_copy(rhs);
      assert($cast(RHS,rhs));
      addr = RHS.addr;
      data = RHS.data;
      op   = RHS.op;
   endfunction : do_copy

//*******************************************************************
   function void do_print(uvm_printer printer);
      if (printer.knobs.sprint==0)
        $display(convert2string());
      else
        printer.m_string = convert2string();
   endfunction : do_print

//*******************************************************************
   function bit do_compare (uvm_object rhs, uvm_comparer comparer);
      wb_transaction RHS;
      if (!$cast(RHS,rhs))
        return 0;

      return (super.do_compare(rhs, comparer) &&
              (addr == RHS.addr) &&
              (data == RHS.data) &&
              (op   == RHS.op));
   endfunction : do_compare


endclass

