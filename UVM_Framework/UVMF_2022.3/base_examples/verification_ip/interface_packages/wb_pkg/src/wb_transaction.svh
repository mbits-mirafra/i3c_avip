//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an wb
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class wb_transaction #(
      int WB_ADDR_WIDTH = 32,
      int WB_DATA_WIDTH = 16
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( wb_transaction #(
                           WB_ADDR_WIDTH,
                           WB_DATA_WIDTH
                           ))

  rand wb_op_t op ;
  rand bit [WB_DATA_WIDTH-1:0] data ;
  rand bit [WB_ADDR_WIDTH-1:0] addr ;
  rand bit [(WB_DATA_WIDTH/8)-1:0] byte_select ;

  //Constraints for the transaction variables:

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  //*******************************************************************
  //*******************************************************************
  // Macros that define structs and associated functions are
  // located in wb_macros.svh

  //*******************************************************************
  // Monitor macro used by wb_monitor and wb_monitor_bfm
  // This struct is defined in wb_macros.svh
  `wb_MONITOR_STRUCT
    wb_monitor_s wb_monitor_struct;
  //*******************************************************************
  // FUNCTION: to_monitor_struct()
  // This function packs transaction variables into a wb_monitor_s
  // structure.  The function returns the handle to the wb_monitor_struct.
  // This function is defined in wb_macros.svh
  `wb_TO_MONITOR_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_monitor_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in wb_macros.svh
  `wb_FROM_MONITOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Initiator macro used by wb_driver and wb_driver_bfm
  // to communicate initiator driven data to wb_driver_bfm.
  // This struct is defined in wb_macros.svh
  `wb_INITIATOR_STRUCT
    wb_initiator_s wb_initiator_struct;
  //*******************************************************************
  // FUNCTION: to_initiator_struct()
  // This function packs transaction variables into a wb_initiator_s
  // structure.  The function returns the handle to the wb_initiator_struct.
  // This function is defined in wb_macros.svh
  `wb_TO_INITIATOR_STRUCT_FUNCTION  
  //*******************************************************************
  // FUNCTION: from_initiator_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in wb_macros.svh
  `wb_FROM_INITIATOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Responder macro used by wb_driver and wb_driver_bfm
  // to communicate Responder driven data to wb_driver_bfm.
  // This struct is defined in wb_macros.svh
  `wb_RESPONDER_STRUCT
    wb_responder_s wb_responder_struct;
  //*******************************************************************
  // FUNCTION: to_responder_struct()
  // This function packs transaction variables into a wb_responder_s
  // structure.  The function returns the handle to the wb_responder_struct.
  // This function is defined in wb_macros.svh
  `wb_TO_RESPONDER_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_responder_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in wb_macros.svh
  `wb_FROM_RESPONDER_STRUCT_FUNCTION 
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
    return $sformatf("op:0x%x data:0x%x addr:0x%x byte_select:0x%x ",op,data,addr,byte_select);





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
    wb_transaction #(
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
        .WB_DATA_WIDTH(WB_DATA_WIDTH)
        ) RHS;
    if (!$cast(RHS,rhs)) return 0;
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.data == RHS.data)
            &&(this.addr == RHS.addr)
            &&(this.byte_select == RHS.byte_select)
            );
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    wb_transaction #(
        .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
        .WB_DATA_WIDTH(WB_DATA_WIDTH)
        ) RHS;
    assert($cast(RHS,rhs));
    super.do_copy(rhs);
    this.op = RHS.op;
    this.data = RHS.data;
    this.addr = RHS.addr;
    this.byte_select = RHS.byte_select;
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"wb_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    // UVMF_CHANGE_ME : Color can be applied to transaction entries based on content, example below
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    // UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,op,"op");
    $add_attribute(transaction_view_h,data,"data");
    $add_attribute(transaction_view_h,addr,"addr");
    $add_attribute(transaction_view_h,byte_select,"byte_select");





    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass
