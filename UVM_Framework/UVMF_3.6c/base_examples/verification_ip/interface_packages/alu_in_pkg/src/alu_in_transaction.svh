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
// File            : alu_in_transaction.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the variables required for an alu_in
//    transaction. Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************

class alu_in_transaction extends uvmf_transaction_base;

  `uvm_object_utils( alu_in_transaction )

  event read_complete;

  rand alu_in_op_t               op;
  rand bit [ALU_IN_OP_WIDTH-1:0] a;
  rand bit [ALU_IN_OP_WIDTH-1:0] b;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
  virtual function string convert2string();
      string msg;
      $sformat(msg,"op:%s a:0x%h b:0x%h",op, a, b);
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
      alu_in_transaction RHS;
      if (!$cast(RHS,rhs)) return 0;
      else return (super.do_compare(rhs, comparer) &&
                  (this.op == RHS.op) &&
                  (this.a == RHS.a) &&
                  (this.b == RHS.b));
   endfunction : do_compare

// ****************************************************************************
  virtual function void add_to_wave(int transaction_viewing_stream_h);
    if ( transaction_view_h == 0) 
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,op.name(),start_time);
    case (op)
      no_op :   $add_color(transaction_view_h,"grey");
      add_op :  $add_color(transaction_view_h,"green");
      and_op :  $add_color(transaction_view_h,"orange");
      xor_op :  $add_color(transaction_view_h,"red");
      mul_op :  $add_color(transaction_view_h,"yellow");
      rst_op :  $add_color(transaction_view_h,"blue");
      default : $add_color(transaction_view_h,"grey");
    endcase
    $add_attribute( transaction_view_h, a, "a" );
    $add_attribute( transaction_view_h, b, "b" );
    super.add_to_wave( transaction_view_h);
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

// ****************************************************************************
   virtual function void unpack_fields();
   endfunction

// ****************************************************************************
   virtual function void pack_fields();
   endfunction

// ****************************************************************************
   function alu_in_transaction_s to_struct();
     alu_in_transaction_s s;
     {s.op, s.a, s.b} = {this.op, this.a, this.b};
     return s;
   endfunction
 
// ****************************************************************************
   function void from_struct(alu_in_transaction_s s);
     {this.op, this.a, this.b} = {s.op, s.a, s.b};
   endfunction
endclass
