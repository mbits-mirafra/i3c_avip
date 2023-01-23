//----------------------------------------------------------------------
// Created with uvmf_gen version 2022.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an i3c_m
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i3c_m_transaction  extends uvmf_transaction_base;

  `uvm_object_utils( i3c_m_transaction )

  rand read_write_e read_write ;
  bit scl ;
  rand bit sda ;
  rand bit [DATA_WIDTH-1:0] wr_data ;
  rand bit [DATA_WIDTH-1:0]  rd_data ;
  rand bit [SLAVE_ADDRESS_WIDTH-1:0] slave_address ;
  rand bit [REGISTER_ADDRESS_WIDTH-1:0] register_address ;
  rand bit [31:0] size ;
  bit ack ;
  rand bit [NO_OF_SLAVES-1:0] index ;
  rand bit [7:0] raddr ;
  rand bit slave_add_ack ;
  rand bit reg_add_ack ;
  bit wr_data_ack ;

  //Constraints for the transaction variables:
  constraint sl_ack_con { slave_add_ack==1; }
  constraint reg_ack_con { reg_add_ack==1; }

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  //*******************************************************************
  //*******************************************************************
  // Macros that define structs and associated functions are
  // located in i3c_m_macros.svh

  //*******************************************************************
  // Monitor macro used by i3c_m_monitor and i3c_m_monitor_bfm
  // This struct is defined in i3c_m_macros.svh
  `i3c_m_MONITOR_STRUCT
    i3c_m_monitor_s i3c_m_monitor_struct;
  //*******************************************************************
  // FUNCTION: to_monitor_struct()
  // This function packs transaction variables into a i3c_m_monitor_s
  // structure.  The function returns the handle to the i3c_m_monitor_struct.
  // This function is defined in i3c_m_macros.svh
  `i3c_m_TO_MONITOR_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_monitor_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in i3c_m_macros.svh
  `i3c_m_FROM_MONITOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Initiator macro used by i3c_m_driver and i3c_m_driver_bfm
  // to communicate initiator driven data to i3c_m_driver_bfm.
  // This struct is defined in i3c_m_macros.svh
  `i3c_m_INITIATOR_STRUCT
    i3c_m_initiator_s i3c_m_initiator_struct;
  //*******************************************************************
  // FUNCTION: to_initiator_struct()
  // This function packs transaction variables into a i3c_m_initiator_s
  // structure.  The function returns the handle to the i3c_m_initiator_struct.
  // This function is defined in i3c_m_macros.svh
  `i3c_m_TO_INITIATOR_STRUCT_FUNCTION  
  //*******************************************************************
  // FUNCTION: from_initiator_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in i3c_m_macros.svh
  `i3c_m_FROM_INITIATOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Responder macro used by i3c_m_driver and i3c_m_driver_bfm
  // to communicate Responder driven data to i3c_m_driver_bfm.
  // This struct is defined in i3c_m_macros.svh
  `i3c_m_RESPONDER_STRUCT
    i3c_m_responder_s i3c_m_responder_struct;
  //*******************************************************************
  // FUNCTION: to_responder_struct()
  // This function packs transaction variables into a i3c_m_responder_s
  // structure.  The function returns the handle to the i3c_m_responder_struct.
  // This function is defined in i3c_m_macros.svh
  `i3c_m_TO_RESPONDER_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_responder_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in i3c_m_macros.svh
  `i3c_m_FROM_RESPONDER_STRUCT_FUNCTION 
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
    return $sformatf("read_write:0x%x scl:0x%x sda:0x%x wr_data:0x%x rd_data:0x%x slave_address:0x%x register_address:0x%x size:0x%x ack:0x%x index:0x%x raddr:0x%x slave_add_ack:0x%x reg_add_ack:0x%x wr_data_ack:0x%x ",read_write,scl,sda,wr_data,rd_data,slave_address,register_address,size,ack,index,raddr,slave_add_ack,reg_add_ack,wr_data_ack);
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
    i3c_m_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
    // pragma uvmf custom do_compare begin
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.read_write == RHS.read_write)
            &&(this.scl == RHS.scl)
            &&(this.sda == RHS.sda)
            &&(this.wr_data == RHS.wr_data)
            &&(this.rd_data == RHS.rd_data)
            &&(this.slave_address == RHS.slave_address)
            &&(this.register_address == RHS.register_address)
            &&(this.size == RHS.size)
            &&(this.ack == RHS.ack)
            &&(this.index == RHS.index)
            &&(this.raddr == RHS.raddr)
            &&(this.slave_add_ack == RHS.slave_add_ack)
            &&(this.reg_add_ack == RHS.reg_add_ack)
            &&(this.wr_data_ack == RHS.wr_data_ack)
            );
    // pragma uvmf custom do_compare end
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    i3c_m_transaction  RHS;
    assert($cast(RHS,rhs));
    // pragma uvmf custom do_copy begin
    super.do_copy(rhs);
    this.read_write = RHS.read_write;
    this.scl = RHS.scl;
    this.sda = RHS.sda;
    this.wr_data = RHS.wr_data;
    this.rd_data = RHS.rd_data;
    this.slave_address = RHS.slave_address;
    this.register_address = RHS.register_address;
    this.size = RHS.size;
    this.ack = RHS.ack;
    this.index = RHS.index;
    this.raddr = RHS.raddr;
    this.slave_add_ack = RHS.slave_add_ack;
    this.reg_add_ack = RHS.reg_add_ack;
    this.wr_data_ack = RHS.wr_data_ack;
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"i3c_m_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    // UVMF_CHANGE_ME : Color can be applied to transaction entries based on content, example below
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    // UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,read_write,"read_write");
    $add_attribute(transaction_view_h,scl,"scl");
    $add_attribute(transaction_view_h,sda,"sda");
    $add_attribute(transaction_view_h,wr_data,"wr_data");
    $add_attribute(transaction_view_h,rd_data,"rd_data");
    $add_attribute(transaction_view_h,slave_address,"slave_address");
    $add_attribute(transaction_view_h,register_address,"register_address");
    $add_attribute(transaction_view_h,size,"size");
    $add_attribute(transaction_view_h,ack,"ack");
    $add_attribute(transaction_view_h,index,"index");
    $add_attribute(transaction_view_h,raddr,"raddr");
    $add_attribute(transaction_view_h,slave_add_ack,"slave_add_ack");
    $add_attribute(transaction_view_h,reg_add_ack,"reg_add_ack");
    $add_attribute(transaction_view_h,wr_data_ack,"wr_data_ack");
    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

