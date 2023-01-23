//----------------------------------------------------------------------
//   Copyright 2013-2021 Siemens Corporation
//   Digital Industries Software
//   Siemens EDA
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
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVM Framework
// Unit            : Port debug policy
// File            : uvmf_standard_port_debug_policy.svh
//----------------------------------------------------------------------
// Created by      : Adam_Rose@mentor.com
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------


// CLASS: uvmf_standard_port_debug_policy
// This class defines a policy used to analyze analysis port connections
// and identify unconnected analysis ports.
class uvmf_standard_port_debug_policy;

  // FUNCTION: debug
  static function void debug( uvm_component c );
    uvm_port_component_base pc;
    assert( c != null );
    if( !$cast( pc , c ) ) return;
    assert( pc != null );
    if( !info_filter( pc ) ) return;
    generate_info( pc );
    if( !warning_filter( pc ) ) return;
    generate_warning( pc );
  endfunction

  // FUNCTION: info_filter
  static function bit info_filter( uvm_port_component_base pc );
    assert( pc != null );
    return pc.is_port();
  endfunction


  // FUNCTION: generate_info
  static function void generate_info( uvm_port_component_base pc );
    `uvm_info("POLICY" , {"Found port: ",pc.get_full_name()} , UVM_MEDIUM );
  endfunction

  // FUNCTION: warning_filter
  static function bit warning_filter( uvm_port_component_base pc );
    uvm_port_list l;
    pc.get_connected_to( l );
    return l.size() == 0;
  endfunction

  // FUNCTION: generate_warning
  static function void generate_warning( uvm_port_component_base pc );
    `uvm_warning( "POLICY" , {"Unconnected port: ",pc.get_full_name()} )
  endfunction

endclass : uvmf_standard_port_debug_policy
