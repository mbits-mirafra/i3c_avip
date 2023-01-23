//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an ccs
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class ccs_transaction #(
      int WIDTH = 32
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( ccs_transaction #(
                           WIDTH
                           ))

  rand bit [WIDTH-1:0] rtl_data ;
  rand int unsigned wait_cycles ;
  int unsigned iteration_count ;
  bit empty ;

  //Constraints for the transaction variables:
  constraint wait_cycles_c { wait_cycles <= 0; } // Constrain wait_cycles to be 0 cycles (no delay) for base test

  // pragma uvmf custom class_item_additional begin
  // ****************************************************************************
  // FUNCTION: to_gp()
  // This function is used to convert this transaction into a TLM2 Generic
  // Payload. It is specific to Catapult "wire" transactions.
  //
  function uvm_tlm_generic_payload to_gp();
    int unsigned no_of_bytes_per_line;
    int unsigned remainder;
    byte dbyte;    // slice of dataword to put into GP
  
    remainder = WIDTH % 8;
    no_of_bytes_per_line = (WIDTH-remainder)/8;
  
    // round up if needed
    if (remainder > 0) begin
      `uvm_info(get_type_name(),$psprintf("Rounding up byte count to include %0d remaining bits",remainder),UVM_MEDIUM);
       no_of_bytes_per_line++;
    end
    to_gp = uvm_tlm_generic_payload::type_id::create("to_gp");
    assert(to_gp.randomize() with { m_address == 0;
                                    m_byte_enable_length == 0;
                                    m_length == no_of_bytes_per_line;
                                    m_data.size() == m_length;
                                    m_streaming_width == 0;
                                    m_response_status == UVM_TLM_OK_RESPONSE;
                                    m_command == UVM_TLM_WRITE_COMMAND;} );
    // Put the data into generic payload transaction
    for (int n = 0; n < no_of_bytes_per_line; n++) begin
      for (int j = 0; j <8; j++) begin
        if (n*8+j > WIDTH)
          dbyte[j] = 2'b0;
        else
          dbyte[j] = rtl_data[n*8+j];
      end
      to_gp.m_data[n] = dbyte;
    end
  endfunction // to_gp
  
  // ****************************************************************************
  // FUNCTION: from_gp()
  // This function is used to convert copy the contents of the TLM Generic
  // Payload into this transaction. It is specific to Catapult "wire" transactions.
  //
  function void from_gp(uvm_tlm_generic_payload gp);
    int unsigned i;
    byte dbyte;    // slice of dataword to put into GP
    bit [63:0] addr = gp.get_address(); // actually 64 bit address
    int unsigned size = gp.get_data_length;
    byte unsigned gpData[] = new[size];
  
    // assert that WIDTH and gp.m_length*8 match (within a byte)
    assert( (size*8 >= WIDTH) && (size*8 <= WIDTH+8));
  
    // Copy data into ourselves
    gp.get_data(gpData);
    for (i = 0; i < size; i++) begin
      dbyte = gpData[i];
      for (int j = 0; j <8; j++) begin
        if (i*8+j < WIDTH) rtl_data[i*8+j] = dbyte[j];
      end
    end
  endfunction // to_gp
  // pragma uvmf custom class_item_additional end

  //*******************************************************************
  //*******************************************************************
  // Macros that define structs and associated functions are
  // located in ccs_macros.svh

  //*******************************************************************
  // Monitor macro used by ccs_monitor and ccs_monitor_bfm
  // This struct is defined in ccs_macros.svh
  `ccs_MONITOR_STRUCT
    ccs_monitor_s ccs_monitor_struct;
  //*******************************************************************
  // FUNCTION: to_monitor_struct()
  // This function packs transaction variables into a ccs_monitor_s
  // structure.  The function returns the handle to the ccs_monitor_struct.
  // This function is defined in ccs_macros.svh
  `ccs_TO_MONITOR_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_monitor_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in ccs_macros.svh
  `ccs_FROM_MONITOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Initiator macro used by ccs_driver and ccs_driver_bfm
  // to communicate initiator driven data to ccs_driver_bfm.
  // This struct is defined in ccs_macros.svh
  `ccs_INITIATOR_STRUCT
    ccs_initiator_s ccs_initiator_struct;
  //*******************************************************************
  // FUNCTION: to_initiator_struct()
  // This function packs transaction variables into a ccs_initiator_s
  // structure.  The function returns the handle to the ccs_initiator_struct.
  // This function is defined in ccs_macros.svh
  `ccs_TO_INITIATOR_STRUCT_FUNCTION  
  //*******************************************************************
  // FUNCTION: from_initiator_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in ccs_macros.svh
  `ccs_FROM_INITIATOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Responder macro used by ccs_driver and ccs_driver_bfm
  // to communicate Responder driven data to ccs_driver_bfm.
  // This struct is defined in ccs_macros.svh
  `ccs_RESPONDER_STRUCT
    ccs_responder_s ccs_responder_struct;
  //*******************************************************************
  // FUNCTION: to_responder_struct()
  // This function packs transaction variables into a ccs_responder_s
  // structure.  The function returns the handle to the ccs_responder_struct.
  // This function is defined in ccs_macros.svh
  `ccs_TO_RESPONDER_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_responder_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in ccs_macros.svh
  `ccs_FROM_RESPONDER_STRUCT_FUNCTION 
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
    return $sformatf("rtl_data:0x%x wait_cycles:0x%x iteration_count:0x%x empty:0x%x ",rtl_data,wait_cycles,iteration_count,empty);
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
    ccs_transaction #(
        .WIDTH(WIDTH)
        ) RHS;
    if (!$cast(RHS,rhs)) return 0;
    // pragma uvmf custom do_compare begin
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.rtl_data == RHS.rtl_data)
            );
    // pragma uvmf custom do_compare end
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    ccs_transaction #(
        .WIDTH(WIDTH)
        ) RHS;
    assert($cast(RHS,rhs));
    // pragma uvmf custom do_copy begin
    super.do_copy(rhs);
    this.rtl_data = RHS.rtl_data;
    this.wait_cycles = RHS.wait_cycles;
    this.iteration_count = RHS.iteration_count;
    this.empty = RHS.empty;
    // pragma uvmf custom do_copy end
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"ccs_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    // UVMF_CHANGE_ME : Color can be applied to transaction entries based on content, example below
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    // UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,rtl_data,"rtl_data");
    $add_attribute(transaction_view_h,wait_cycles,"wait_cycles");
    $add_attribute(transaction_view_h,iteration_count,"iteration_count");
    $add_attribute(transaction_view_h,empty,"empty");
    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass
