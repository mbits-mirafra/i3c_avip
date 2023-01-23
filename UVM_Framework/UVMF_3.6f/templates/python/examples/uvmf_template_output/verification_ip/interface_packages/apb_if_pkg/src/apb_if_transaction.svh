//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Transaction
// File            : apb_if_transaction.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an apb_if
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class apb_if_transaction       #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( apb_if_transaction #(
                           DATA_WIDTH,
                           ADDR_WIDTH
                            ))

  bit [DATA_WIDTH-1:0] prdata;
  bit [DATA_WIDTH-1:0] pwdata;
  rand bit [ADDR_WIDTH-1:0] paddr;
  rand bit [2:0] pprot;
  int pselx;

//Constraints for the transaction variables:
  constraint pselx_c1 { $countones(pselx)]==1; }
  constraint pselx_c2 { pselx >0 && pselx <2**1; }
  constraint pwdata_c3 {soft pwdata inside {[0:100]} ; }
  constraint transfer_size_c4 { transfer_size inside {8,16,24,32}; }

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for 
// logfile reporting.
//
  virtual function string convert2string();
    // UVMF_CHANGE_ME : Customize format if desired.
    return $sformatf("prdata:0x%x pwdata:0x%x paddr:0x%x pprot:0x%x pselx:0x%x ",prdata,pwdata,paddr,pprot,pselx);
  endfunction

//*******************************************************************
// FUNCTION: do_print()
// This function is automatically called when the .print() function
// is called on this class.
//
  virtual function void do_print(uvm_printer printer);
    if (printer.knobs.sprint==0)
      $display(convert2string());
    else
      printer.m_string = convert2string();
  endfunction

//*******************************************************************
// FUNCTION: do_compare()
// This function is automatically called when the .compare() function
// is called on this class.
//
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    apb_if_transaction   #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH(ADDR_WIDTH)
             ) RHS;
    if (!$cast(RHS,rhs)) return 0;
// UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.prdata == RHS.prdata)
            &&(this.pwdata == RHS.pwdata)
            &&(this.paddr == RHS.paddr)
            );
  endfunction

// ****************************************************************************
// FUNCTION: add_to_wave()
// This function is used to display variables in this class in the waveform 
// viewer.  The start_time and end_time variables must be set before this 
// function is called.  If the start_time and end_time variables are not set
// the transaction will be hidden at 0ns on the waveform display.
// 
  virtual function void add_to_wave(int transaction_viewing_stream_h);
    if (transaction_view_h == 0)
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"apb_if_transaction",start_time);
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    super.add_to_wave(transaction_view_h);
// UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,prdata,"prdata");
    $add_attribute(transaction_view_h,pwdata,"pwdata");
    $add_attribute(transaction_view_h,paddr,"paddr");
    $add_attribute(transaction_view_h,pprot,"pprot");
    $add_attribute(transaction_view_h,pselx,"pselx");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
