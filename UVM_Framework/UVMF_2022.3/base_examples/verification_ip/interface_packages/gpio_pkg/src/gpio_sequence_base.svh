//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains the class used as the base class for all sequences
// for this interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class gpio_sequence_base #(
      int READ_PORT_WIDTH = 4,
      int WRITE_PORT_WIDTH = 4
      )   extends uvmf_sequence_base #(
                             .REQ(gpio_transaction  #(
                                 .READ_PORT_WIDTH(READ_PORT_WIDTH),
                                 .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                                 )),
                             .RSP(gpio_transaction  #(
                                 .READ_PORT_WIDTH(READ_PORT_WIDTH),
                                 .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                                 )));

  `uvm_object_param_utils( gpio_sequence_base #(
                           READ_PORT_WIDTH,
                           WRITE_PORT_WIDTH
                           ))

  // variables
  typedef gpio_transaction #(
                     .READ_PORT_WIDTH(READ_PORT_WIDTH),
                     .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                     ) gpio_transaction_req_t;
  gpio_transaction_req_t req;
  typedef gpio_transaction #(
                     .READ_PORT_WIDTH(READ_PORT_WIDTH),
                     .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                     ) gpio_transaction_rsp_t;
  gpio_transaction_rsp_t rsp;

  // Event for identifying when a response was received from the sequencer
  event new_rsp;


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  // TASK : get_responses()
  // This task recursively gets sequence item responses from the sequencer.
  //
  virtual task get_responses();
    fork
      begin
        // Block until new rsp available
        get_response(rsp);
        // New rsp received.  Indicate to sequence using event.
        ->new_rsp;
        // Display the received response transaction
        `uvm_info("SEQ", {"New response transaction:",rsp.convert2string()}, UVM_MEDIUM)
      end
    join_none
  endtask

  // ****************************************************************************
  // TASK : pre_body()
  // This task is called automatically when start is called with call_pre_post set to 1 (default).
  // By calling get_responses() within pre_body() any derived sequences are automatically 
  // processing response transactions.
  //
  virtual task pre_body();
    // pragma uvmf custom pre_body begin
    get_responses();
    // pragma uvmf custom pre_body end
  endtask

  // ****************************************************************************
  // TASK : body()
  // This task is called automatically when start is called.  This sequence sends
  // a req sequence item to the sequencer identified as an argument in the call
  // to start.
  //
  virtual task body();
    // pragma uvmf custom body begin
  	start_item(req);
  	finish_item(req);
    // pragma uvmf custom body end
  endtask

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new( string name ="");
    super.new( name );
    // pragma uvmf custom new begin
    req = gpio_transaction_req_t::type_id::create("req");
    rsp = gpio_transaction_rsp_t::type_id::create("rsp");
    // pragma uvmf custom new end
  endfunction

endclass
