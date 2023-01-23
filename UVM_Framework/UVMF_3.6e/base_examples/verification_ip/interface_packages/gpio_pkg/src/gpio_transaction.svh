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
// Project         : gpio interface agent
// Unit            : Transaction
// File            : gpio_transaction.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the variables required for an gpio
//    transaction. Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//
class gpio_transaction #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) extends uvmf_transaction_base;

   typedef gpio_transaction #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) this_t;

  `uvm_object_param_utils( this_t )

   typedef logic [WRITE_PORT_WIDTH-1:0] write_port_t;
   typedef logic [READ_PORT_WIDTH-1:0]  read_port_t;

   gpio_op_t op;
   event read_port_change;

   write_port_t write_port;
   read_port_t  read_port;


// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
  function string convert2string();
      return {super.convert2string(),$psprintf(" \nwrite_port:0x%h \nread_port: 0x%h", write_port, read_port)};
  endfunction

//*******************************************************************
  function bit do_compare (uvm_object rhs, uvm_comparer comparer);
      this_t RHS;
      if (!$cast(RHS,rhs))
        return 0;

      return ( (super.do_compare(rhs, comparer)) &&
               (this.read_port     == RHS.read_port   ));
   endfunction : do_compare


// ****************************************************************************
  virtual function void add_to_wave( int transaction_viewing_stream_h );
    if ( transaction_view_h == 0)
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,op.name(),start_time);
    super.add_to_wave( transaction_view_h );
    $add_attribute( transaction_view_h, write_port, "write_port" );
    $add_attribute( transaction_view_h, read_port, "read_port" );
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
