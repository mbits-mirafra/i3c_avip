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
// Project         : spi interface agent
// Unit            : Transaction
// File            : spi_transaction.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class defines the variables required for an spi
//    memory slave transaction. Class variables to be displayed in
//    waveform transaction viewing are added to the transaction viewing
//    stream in the add_to_wave function.
//
//----------------------------------------------------------------------
//
class spi_mem_slave_transaction extends spi_transaction;

  `uvm_object_utils( spi_mem_slave_transaction )

  spi_op_t op;
  bit [2:0] addr;
  bit [3:0] data;
  bit status;
  bit command;


// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
  virtual function string convert2string();
      string msg;
      $sformat(msg,"op:%s dir:%s command:%h status:%h addr:0x%h data:0x%h",op, dir, command,status,addr,data);
      return { msg, super.convert2string()};
  endfunction

//*******************************************************************
  function void do_copy (uvm_object rhs);
     spi_transaction RHS;
     assert($cast(RHS,rhs));
     super.do_copy(rhs);
     unpack_fields();
  endfunction : do_copy

//*******************************************************************
  virtual function void do_print(uvm_printer printer);
    $display(convert2string());
  endfunction

//*******************************************************************
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
      spi_transaction RHS;
      if (!$cast(RHS,rhs))
        return 0;

      pack_fields();
      return (super.do_compare(rhs, comparer));

   endfunction : do_compare

// ****************************************************************************
   virtual function void unpack_fields();
      if (mosi_data[7]== 1) op = SPI_SLAVE_WRITE;
      else                 op = SPI_SLAVE_READ;
      command = mosi_data[7];
      addr = mosi_data[6:4];
      data = mosi_data[3:0];
   endfunction

// ****************************************************************************
   virtual function void pack_fields();
      //mosi_data = { command, addr, data};
      miso_data = { status,  addr, data};
   endfunction

// ****************************************************************************
  virtual function void add_to_wave( int transaction_viewing_stream_h );
    transaction_view_h = $begin_transaction(transaction_viewing_stream_h,op.name(),start_time);
    if      ( op == SPI_SLAVE_WRITE ) $add_color( transaction_view_h, "cyan" );
    else if ( op == SPI_SLAVE_READ  )  $add_color( transaction_view_h, "brown" );
    $add_attribute( transaction_view_h, dir, "dir" );
    $add_attribute( transaction_view_h, op, "op" );
    $add_attribute( transaction_view_h, addr, "addr" );
    $add_attribute( transaction_view_h, data, "data" );
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
