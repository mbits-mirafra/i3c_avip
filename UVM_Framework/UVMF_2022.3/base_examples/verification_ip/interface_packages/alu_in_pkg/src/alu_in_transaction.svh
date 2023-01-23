//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an alu_in
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class alu_in_transaction #(
      int ALU_IN_OP_WIDTH = 8
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( alu_in_transaction #(
                           ALU_IN_OP_WIDTH
                           ))

  rand alu_in_op_t op ;
  rand bit [ALU_IN_OP_WIDTH-1:0] a ;
  rand bit [ALU_IN_OP_WIDTH-1:0] b ;

  //Constraints for the transaction variables:
  constraint valid_op_c { op inside {add_op, and_op, xor_op, mul_op}; }

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  //*******************************************************************
  //*******************************************************************
  // Macros that define structs and associated functions are
  // located in alu_in_macros.svh

  //*******************************************************************
  // Monitor macro used by alu_in_monitor and alu_in_monitor_bfm
  // This struct is defined in alu_in_macros.svh
  `alu_in_MONITOR_STRUCT
    alu_in_monitor_s alu_in_monitor_struct;
  //*******************************************************************
  // FUNCTION: to_monitor_struct()
  // This function packs transaction variables into a alu_in_monitor_s
  // structure.  The function returns the handle to the alu_in_monitor_struct.
  // This function is defined in alu_in_macros.svh
  `alu_in_TO_MONITOR_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_monitor_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in alu_in_macros.svh
  `alu_in_FROM_MONITOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Initiator macro used by alu_in_driver and alu_in_driver_bfm
  // to communicate initiator driven data to alu_in_driver_bfm.
  // This struct is defined in alu_in_macros.svh
  `alu_in_INITIATOR_STRUCT
    alu_in_initiator_s alu_in_initiator_struct;
  //*******************************************************************
  // FUNCTION: to_initiator_struct()
  // This function packs transaction variables into a alu_in_initiator_s
  // structure.  The function returns the handle to the alu_in_initiator_struct.
  // This function is defined in alu_in_macros.svh
  `alu_in_TO_INITIATOR_STRUCT_FUNCTION  
  //*******************************************************************
  // FUNCTION: from_initiator_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in alu_in_macros.svh
  `alu_in_FROM_INITIATOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Responder macro used by alu_in_driver and alu_in_driver_bfm
  // to communicate Responder driven data to alu_in_driver_bfm.
  // This struct is defined in alu_in_macros.svh
  `alu_in_RESPONDER_STRUCT
    alu_in_responder_s alu_in_responder_struct;
  //*******************************************************************
  // FUNCTION: to_responder_struct()
  // This function packs transaction variables into a alu_in_responder_s
  // structure.  The function returns the handle to the alu_in_responder_struct.
  // This function is defined in alu_in_macros.svh
  `alu_in_TO_RESPONDER_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_responder_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in alu_in_macros.svh
  `alu_in_FROM_RESPONDER_STRUCT_FUNCTION 
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
    // pragma uvmf custom convert2string begin
    // UVMF_CHANGE_ME : Customize format if desired.
    return $sformatf("op:%s a:0x%x b:0x%x ",op,a,b);


    // pragma uvmf custom convert2string end
  endfunction

  //*******************************************************************
  // FUNCTION: do_print()
  // This function is automatically called when the .print() function
  // is called on this class.
  //
  virtual function void do_print(uvm_printer printer);
    // pragma uvmf custom do_print begin
    // UVMF_CHANGE_ME : Current contents of do_print allows for the use of UVM 1.1d, 1.2 or P1800.2.
    // Update based on your own printing preference according to your preferred UVM version
    $display(convert2string());


    // pragma uvmf custom do_print end
  endfunction

  //*******************************************************************
  // FUNCTION: do_compare()
  // This function is automatically called when the .compare() function
  // is called on this class.
  //
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    alu_in_transaction #(
        .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
        ) RHS;
    if (!$cast(RHS,rhs)) return 0;
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.op == RHS.op)
            &&(this.a == RHS.a)
            &&(this.b == RHS.b)
            );
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    alu_in_transaction #(
        .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
        ) RHS;
    assert($cast(RHS,rhs));
    super.do_copy(rhs);
    this.op = RHS.op;
    this.a = RHS.a;
    this.b = RHS.b;
  endfunction

  // ****************************************************************************
  // FUNCTION: add_to_wave()
  // This function is used to display variables in this class in the waveform 
  // viewer.  The start_time and end_time variables must be set before this 
  // function is called.  If the start_time and end_time variables are not set
  // the transaction will be hidden at 0ns on the waveform display.
  // 
  virtual function void add_to_wave(int transaction_viewing_stream_h);
    `ifdef QUESTA
    if (transaction_view_h == 0) begin
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"alu_in_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    case (op)
      add_op :  $add_color(transaction_view_h,"green");
      and_op :  $add_color(transaction_view_h,"orange");
      xor_op :  $add_color(transaction_view_h,"red");
      mul_op :  $add_color(transaction_view_h,"yellow");
      default : $add_color(transaction_view_h,"grey");
    endcase
    $add_attribute( transaction_view_h, op, "op" );
    $add_attribute( transaction_view_h, a, "a" );
    $add_attribute( transaction_view_h, b, "b" );
    super.add_to_wave( transaction_view_h);


    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass
