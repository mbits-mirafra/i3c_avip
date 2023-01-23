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
// File            : alu_out_transaction.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the variables required for an alu_out
//    transaction. Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************

class alu_out_transaction extends uvmf_transaction_base;

  `uvm_object_utils( alu_out_transaction )

  bit [ALU_OUT_RESULT_WIDTH-1:0] result;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
  virtual function string convert2string();
      string msg;
      $sformat(msg,"result:0x%h",result);
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
      alu_out_transaction RHS;
      if (!$cast(RHS,rhs)) return 0;
      else return (super.do_compare(rhs, comparer) &&
                  (this.result == RHS.result));
   endfunction : do_compare

// ****************************************************************************
  virtual function void add_to_wave( int transaction_viewing_stream_h );
    if ( transaction_view_h == 0) 
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,$sformatf("0x%4h",result),start_time);
    $add_color(transaction_view_h,"green");
    super.add_to_wave(transaction_view_h);
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
   function alu_out_transaction_s to_struct();
     alu_out_transaction_s s;
     {s.result} = {this.result};
     return s;
   endfunction
 
// ****************************************************************************
   function void from_struct(alu_out_transaction_s s);
     {this.result} = {s.result};
   endfunction
endclass
