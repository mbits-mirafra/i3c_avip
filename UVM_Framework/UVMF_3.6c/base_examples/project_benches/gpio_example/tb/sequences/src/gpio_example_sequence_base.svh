//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : GPIO Example Project Bench
// Unit            : gpio example sequence base
// File            : gpio_example_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 02.20.2013
//----------------------------------------------------------------------
// Description: This is the sequence base used for the gpio example
//
//----------------------------------------------------------------------
//
class gpio_example_sequence_base #(int READ_PORT_WIDTH=4, int WRITE_PORT_WIDTH=4) extends 
    uvmf_sequence_base #(
        .REQ(gpio_transaction#(READ_PORT_WIDTH, WRITE_PORT_WIDTH)), 
        .RSP(gpio_transaction#(READ_PORT_WIDTH, WRITE_PORT_WIDTH))
    );


  `uvm_object_param_utils( gpio_example_sequence_base #(READ_PORT_WIDTH, WRITE_PORT_WIDTH));

  gpio_gpio_sequence #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_seq;

  uvm_sequencer #(gpio_transaction#(READ_PORT_WIDTH, WRITE_PORT_WIDTH)) gpio_sequencer;

  gpio_configuration #(READ_PORT_WIDTH, WRITE_PORT_WIDTH) gpio_config;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );
     if( !uvm_config_db #( uvm_sequencer #(gpio_transaction#(READ_PORT_WIDTH, WRITE_PORT_WIDTH)) )::get( null , UVMF_SEQUENCERS , "gpio_bfm" , gpio_sequencer ) ) 
             `uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer#(gpio_transaction) )::get cannot find resource gpio_sequencer" )
    if( !uvm_config_db #( gpio_configuration#(READ_PORT_WIDTH, WRITE_PORT_WIDTH) )::get( null ,UVMF_CONFIGURATIONS, "gpio_bfm", gpio_config ) )
            `uvm_error("Config Error" , "uvm_config_db #( gpio_configuration )::get cannot find resource gpio_config" )
  endfunction

// ****************************************************************************
  virtual task body();

     gpio_seq = new("gpio_seq");
     gpio_seq.start(gpio_sequencer);
     gpio_config.wait_for_num_clocks(2);  //#20ns;
     gpio_seq.bus_a = 16'h1234;
     gpio_seq.bus_b = 16'habcd;
     `uvm_info("GPIO", gpio_seq.convert2string(), UVM_MEDIUM)
     gpio_seq.write_gpio();
     gpio_config.wait_for_num_clocks(2);  //#20ns;
     gpio_seq.read_gpio();
     gpio_config.wait_for_num_clocks(2);  //#20ns;
     `uvm_info("GPIO", gpio_seq.convert2string(), UVM_MEDIUM)


  endtask

endclass
