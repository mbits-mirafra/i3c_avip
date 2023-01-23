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
// Project         : gpio interface agent
// Unit            : gpio interface configuration
// File            : gpio_agent.svh
//----------------------------------------------------------------------
// Creation Date   : 11.30.2016
//----------------------------------------------------------------------
// Description: This class defines the parameterized gpio agent.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class gpio_agent #( int READ_PORT_WIDTH = 240, int WRITE_PORT_WIDTH = 230)extends uvmf_parameterized_agent #(
                    .CONFIG_T(gpio_configuration #(.READ_PORT_WIDTH(READ_PORT_WIDTH),.WRITE_PORT_WIDTH(WRITE_PORT_WIDTH))),
                    .DRIVER_T(gpio_driver #(.READ_PORT_WIDTH(READ_PORT_WIDTH),.WRITE_PORT_WIDTH(WRITE_PORT_WIDTH))),
                    .MONITOR_T(gpio_monitor #(.READ_PORT_WIDTH(READ_PORT_WIDTH),.WRITE_PORT_WIDTH(WRITE_PORT_WIDTH))),
                    .COVERAGE_T(gpio_transaction_coverage #(.READ_PORT_WIDTH(READ_PORT_WIDTH),.WRITE_PORT_WIDTH(WRITE_PORT_WIDTH))),
                    .TRANS_T(gpio_transaction #(.READ_PORT_WIDTH(READ_PORT_WIDTH),.WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)))
                    );

  `uvm_component_param_utils (gpio_agent #(READ_PORT_WIDTH,WRITE_PORT_WIDTH) )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
