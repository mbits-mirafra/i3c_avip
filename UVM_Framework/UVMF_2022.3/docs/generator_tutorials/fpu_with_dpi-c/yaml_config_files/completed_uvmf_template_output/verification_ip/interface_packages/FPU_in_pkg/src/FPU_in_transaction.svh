//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface Transaction
// File            : FPU_in_transaction.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an FPU_in
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_in_transaction       #(
      int FP_WIDTH = 32                                
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( FPU_in_transaction #(
                           FP_WIDTH
                            ))

  rand fpu_op_t op ;
  rand fpu_rnd_t rmode ;
  rand bit [FP_WIDTH-1:0] a ;
  rand bit [FP_WIDTH-1:0] b ;
  bit [FP_WIDTH-1:0] result ;

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
    return $sformatf("op:0x%x rmode:0x%x a:0x%x b:0x%x result:0x%x ",op,rmode,a,b,result);
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
    FPU_in_transaction   #(
            .FP_WIDTH(FP_WIDTH)
             ) RHS;
    if (!$cast(RHS,rhs)) return 0;
// UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.op == RHS.op)
            &&(this.rmode == RHS.rmode)
            &&(this.a == RHS.a)
            &&(this.b == RHS.b)
            &&(this.result == RHS.result)
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"FPU_in_transaction",start_time);
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    super.add_to_wave(transaction_view_h);
// UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,op,"op");
    $add_attribute(transaction_view_h,rmode,"rmode");
    $add_attribute(transaction_view_h,a,"a");
    $add_attribute(transaction_view_h,b,"b");
    $add_attribute(transaction_view_h,result,"result");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

    // convert from a class to a struct
  virtual function reqstruct to_struct();
      reqstruct ts;
      
      ts.a = $bitstoshortreal(this.a);
      ts.b = $bitstoshortreal(this.b);
      ts.op = this.op;
      ts.round =this.rmode;
      
      return ts;
  endfunction
  
    // convert from a struct to a class
  static function FPU_in_transaction to_class(rspstruct ts);
      FPU_in_transaction req = new();
      
      req.a = $shortrealtobits(ts.a);
      req.b = $shortrealtobits(ts.b);
      req.op = ts.op;
      req.rmode = ts.round;
      req.result = $shortrealtobits(ts.result);
      //req.status = ts.status;
     
      return req;
  endfunction // to_class    
  
endclass
