//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Transaction
// File            : wb_transaction.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an wb
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class wb_transaction       #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( wb_transaction #(
                           .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
                           .WB_DATA_WIDTH(WB_DATA_WIDTH)
                            ))

  rand wb_op_t op;
  rand bit [WB_DATA_WIDTH-1:0] data;
  rand bit [WB_ADDR_WIDTH-1:0] addr;
  rand bit [(WB_DATA_WIDTH/8)-1:0] byte_select;

  bit dummy_start = 0;

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
    return $sformatf("op:0x%x data:0x%x addr:0x%x byte_select:0x%x ",op,data,addr,byte_select);
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
    wb_transaction   #(
            .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
            .WB_DATA_WIDTH(WB_DATA_WIDTH)
             ) RHS;
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"wb_transaction",start_time);
    case(op)
      WB_WRITE : $add_color(transaction_view_h,"blue");
      WB_READ  : $add_color(transaction_view_h,"green");
      WB_RESET : $add_color(transaction_view_h,"red");
      default  : $add_color(transaction_view_h,"grey");
    endcase
    super.add_to_wave(transaction_view_h);
// UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,op,"op");
    $add_attribute(transaction_view_h,data,"data");
    $add_attribute(transaction_view_h,addr,"addr");
    $add_attribute(transaction_view_h,byte_select,"byte_select");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
