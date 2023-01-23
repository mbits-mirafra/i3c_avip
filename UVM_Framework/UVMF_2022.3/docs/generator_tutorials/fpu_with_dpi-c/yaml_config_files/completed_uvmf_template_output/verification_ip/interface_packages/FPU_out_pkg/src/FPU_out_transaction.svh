//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Transaction
// File            : FPU_out_transaction.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an FPU_out
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_out_transaction extends uvmf_transaction_base;

  `uvm_object_utils( FPU_out_transaction )

  bit ine ;
  bit overflow ;
  bit underflow ;
  bit div_zero ;
  bit inf ;
  bit zero ;
  bit qnan ;
  bit snan ;

//Constraints for the transaction variables:

// System Verilog variables for C functions 

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
    return $sformatf("ine:0x%x overflow:0x%x underflow:0x%x div_zero:0x%x inf:0x%x zero:0x%x qnan:0x%x snan:0x%x ",ine,overflow,underflow,div_zero,inf,zero,qnan,snan);
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
    FPU_out_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
// UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.ine == RHS.ine)
            &&(this.overflow == RHS.overflow)
            &&(this.underflow == RHS.underflow)
            &&(this.div_zero == RHS.div_zero)
            &&(this.inf == RHS.inf)
            &&(this.zero == RHS.zero)
            &&(this.qnan == RHS.qnan)
            &&(this.snan == RHS.snan)
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"FPU_out_transaction",start_time);
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    super.add_to_wave(transaction_view_h);
// UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,ine,"ine");
    $add_attribute(transaction_view_h,overflow,"overflow");
    $add_attribute(transaction_view_h,underflow,"underflow");
    $add_attribute(transaction_view_h,div_zero,"div_zero");
    $add_attribute(transaction_view_h,inf,"inf");
    $add_attribute(transaction_view_h,zero,"zero");
    $add_attribute(transaction_view_h,qnan,"qnan");
    $add_attribute(transaction_view_h,snan,"snan");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
