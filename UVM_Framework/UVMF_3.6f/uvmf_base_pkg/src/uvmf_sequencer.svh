class uvmf_sequencer #(type REQ=uvm_sequence_item, RSP=REQ)
                       extends uvm_sequencer #(REQ, RSP);

  typedef uvmf_sequencer #( REQ , RSP) this_type;

  `uvm_component_param_utils(this_type)

  // The sequence_item_stack_trace flag enables observation of sequence_item 
  // origination and ordering through this sequencer for debug purposes.
  // ***
  // *** Default should be 0.  Setting to 1 for testing
  // ***
  bit sequence_item_stack_trace=1; 

  // Functions to simplify sequencer arbitration setting and 
  // provide compatability between uvm-1.1x and uvm-1.2
  // Specifies a sequencer's arbitration mode
  // 
  // From UVM 1.1d uvm_object_globals.svh
  //
  // SEQ_ARB_FIFO          - 0 - Requests are granted in FIFO order (default)
  // SEQ_ARB_WEIGHTED      - 1 - Requests are granted randomly by weight
  // SEQ_ARB_RANDOM        - 2 - Requests are granted randomly
  // SEQ_ARB_STRICT_FIFO   - 3 - Requests at highest priority granted in fifo order
  // SEQ_ARB_STRICT_RANDOM - 4 - Requests at highest priority granted in randomly
  // SEQ_ARB_USER          - 5 - Arbitration is delegated to the user-defined 
  //                         function, user_priority_arbitration. That function
  //                         will specify the next sequence to grant.
  function void set_seq_arb_fifo();
     this.set_arbitration(uvm_sequencer_arb_mode'(0));
  endfunction

  function void set_seq_arb_weighted();
     this.set_arbitration(uvm_sequencer_arb_mode'(1));
  endfunction

  function void set_seq_arb_random();
     this.set_arbitration(uvm_sequencer_arb_mode'(2));
  endfunction

  function void set_seq_arb_strict_fifo();
     this.set_arbitration(uvm_sequencer_arb_mode'(3));
  endfunction

  function void set_seq_arb_strict_random();
     this.set_arbitration(uvm_sequencer_arb_mode'(4));
  endfunction

  function void set_seq_arb_user();
     this.set_arbitration(uvm_sequencer_arb_mode'(5));
  endfunction

  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // send_request is called by finish_item()
  virtual function void send_request(uvm_sequence_base sequence_ptr,
                                     uvm_sequence_item t,
                                     bit rerandomize = 0);

     super.send_request(sequence_ptr, t, rerandomize);

     if ( sequence_item_stack_trace ) begin : trace_seq_item
        `uvm_info("SEQUENCER_TRACE", {" : ",this.get_full_name()},UVM_MEDIUM)
        $stacktrace;
     end : trace_seq_item

  endfunction

endclass
