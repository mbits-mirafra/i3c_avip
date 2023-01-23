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
//    transaction. Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//

class spi_transaction extends uvmf_transaction_base;

  `uvm_object_utils( spi_transaction )

  spi_dir_t dir;
  bit [SPI_XFER_WIDTH-1:0] spi_data;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
  virtual function string convert2string();
      string msg;
      $sformat(msg,"dir:%s spi_data:0x%h",dir, spi_data);
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
      spi_transaction RHS;
      if (!$cast(RHS,rhs)) return 0;
      else return (super.do_compare(rhs, comparer) && (this.dir == RHS.dir) && (this.spi_data == RHS.spi_data));
   endfunction : do_compare

//*******************************************************************
      function void do_copy (uvm_object rhs);
          spi_transaction RHS;
          assert($cast(RHS,rhs));
          super.do_copy(rhs);
          this.dir = RHS.dir;
          this.spi_data = RHS.spi_data;
   endfunction : do_copy

// ****************************************************************************
  virtual function void add_to_wave( int transaction_viewing_stream_h );
    if ( transaction_view_h == 0)
       transaction_view_h = $begin_transaction(transaction_viewing_stream_h,dir.name(),start_time);
    if      ( dir == MOSI ) $add_color( transaction_view_h, "LavenderBlush" );
    else if ( dir == MISO )  $add_color( transaction_view_h, "orange" );
    $add_attribute( transaction_view_h, dir, "dir" );
    $add_attribute( transaction_view_h, spi_data, "spi_data" );
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
   function spi_transaction_s to_struct();
     spi_transaction_s s;
     {s.dir, s.spi_data} = {this.dir, this.spi_data};
     return s;
   endfunction
 
// ****************************************************************************
   function void from_struct(spi_transaction_s s);
     {this.dir, this.spi_data} = {s.dir, s.spi_data};
   endfunction
endclass
