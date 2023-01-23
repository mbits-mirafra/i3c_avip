//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface Transaction
// File            : ahb_transaction.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an ahb
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class ahb_transaction extends uvmf_transaction_base;

  `uvm_object_utils( ahb_transaction )

  rand ahb_op_t op;
  rand bit [15:0] data;
  rand bit [31:0] addr;

//Constraints for the transaction variables:

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
    return $sformatf("op:0x%x data:0x%x addr:0x%x ",op,data,addr);
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
    ahb_transaction RHS;
    if (!$cast(RHS,rhs)) return 0;
// UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.data == RHS.data)
            &&(this.addr == RHS.addr)
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"ahb_transaction",start_time);
    case(op)
       AHB_RESET : $add_color(transaction_view_h,"red");
       AHB_WRITE : $add_color(transaction_view_h,"blue");
       AHB_READ  : $add_color(transaction_view_h,"green");
       default : $add_color(transaction_view_h,"grey");
    endcase
    super.add_to_wave(transaction_view_h);
    $add_attribute(transaction_view_h,op,"op");
    $add_attribute(transaction_view_h,data,"data");
    $add_attribute(transaction_view_h,addr,"addr");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
