/*****************************************************************************
 *
 * Copyright 2007-2020 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
 * MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
 *
 *****************************************************************************/

//------------------------------------------------------------------------------
//
// CLASS: apb_bus_sequence
//
//------------------------------------------------------------------------------
//
// This sequence is conventional apb bus sequence which runs directly on bus
// agent sequencer.  This sequence executes apb read/write bus transactions.
// When explicit prediction is used in the environment, the register database
// gets updated according to bus sequence.  
// 
//------------------------------------------------------------------------------


 class apb3_alu_random_sequence #( int SLAVE_COUNT   = 8,
                                   int ADDRESS_WIDTH = 32,
                                   int WDATA_WIDTH   = 32,
                                   int RDATA_WIDTH   = 32 ) extends mvc_sequence;

  typedef apb3_alu_random_sequence   #(SLAVE_COUNT, 
                                       ADDRESS_WIDTH, 
                                       WDATA_WIDTH, 
                                       RDATA_WIDTH) this_t;

  typedef apb3_vip_config    #(SLAVE_COUNT, 
                               ADDRESS_WIDTH, 
                               WDATA_WIDTH, 
                               RDATA_WIDTH) cfg_t;

  typedef apb3_host_write    #(SLAVE_COUNT, 
                               ADDRESS_WIDTH, 
                               WDATA_WIDTH, 
                               RDATA_WIDTH) write_item_t;

  typedef apb3_host_read     #(SLAVE_COUNT, 
                               ADDRESS_WIDTH, 
                               WDATA_WIDTH, 
                               RDATA_WIDTH) read_item_t;
  

  `uvm_object_param_utils( this_t )

  // Variable: apb3_config
  //
  // Handle to apb3_vip_config.
  cfg_t  apb3_config;

  // Function: new
  //
  // This is the standard UVM function to initialize the start and end address.
  //
  function new(string name = "");
    super.new(name);
  endfunction

  // Task: body
  //
  // This is the standard UVM body task.
  // 
  // It uses write_item and read_item to initiate random write and read
  // transactions.  Write followed by read executed on the same address and
  // slave id.
  //
  task body();

    write_item_t write_item = write_item_t::type_id::create("write_seq");
    read_item_t  read_item = read_item_t::type_id::create("read_seq");

    apb3_config = cfg_t::get_config(m_sequencer);


    apb3_config.wait_for_reset();
    apb3_config.wait_for_clock();

    // Write Operand A through APB
    start_item( write_item );
      if ( !write_item.randomize() with {write_item.addr == 'h0;}
         ) `uvm_error("APB3_ALU_RANDOM_SEQUENCE", "Randomization failure for write transaction")
    finish_item( write_item );

    // Write Operand B through APB
    start_item( write_item );
      if ( !write_item.randomize() with {write_item.addr == 'h4;}
         ) `uvm_error("APB3_ALU_RANDOM_SEQUENCE", "Randomization failure for write transaction")
    finish_item( write_item );

    // Write Operation through APB
    start_item( write_item );
      if ( !write_item.randomize() with {write_item.addr == 'h8;
                                         'h0 < write_item.wr_data && write_item.wr_data <= 'h4;}
         ) `uvm_error("APB3_ALU_RANDOM_SEQUENCE", "Randomization failure for write transaction")
    finish_item( write_item );

    // Write Control Register through APB to perform the Operation
    start_item( write_item );
      if ( !write_item.randomize() with {write_item.addr    == 'h10;
                                         write_item.wr_data == 'h1;}
         ) `uvm_error("APB3_ALU_RANDOM_SEQUENCE", "Randomization failure for write transaction")
    finish_item( write_item );

    // Execute write followed by read to the same address and slave ID
    start_item( write_item );
      if ( !write_item.randomize() with {
                                         'h10 <= write_item.addr && write_item.addr < 'h1000;
                                        }
         ) `uvm_error("APB3_ALU_RANDOM_SEQUENCE",
                      "Randomization failure for write transaction")
    finish_item( write_item );
    start_item  ( read_item );
      if ( !read_item.randomize() with {
                                        read_item.addr     == write_item.addr;
                                        read_item.slave_id == write_item.slave_id;
                                       }
         ) `uvm_error("APB3_ALU_RANDOM_SEQUENCE",
                      "Randomization failure for read transaction")
    finish_item ( read_item );
 
  endtask

endclass
