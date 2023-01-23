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
// Unit            : Analysis port debug
// File            : uvmf_analysis_debug.svh
//----------------------------------------------------------------------
// Created by      : Adam_Rose@mentor.com
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------

// CLASS: uvmf_analysis_debug
// This class applies a debug policy to the component hiearchy.
//
// PARAMETERS:
//      POLICY - The standard debug policy.

class uvmf_analysis_debug #( type POLICY = uvmf_standard_port_debug_policy );

  // FUNCTION: uvmf_analysis_debug
  static function void uvmf_analysis_debug( uvm_component parent );
    uvm_component child;
    string name;
    bit ok;

    for( ok = parent.get_first_child( name ); ok; ok =  parent.get_next_child( name ) ) begin
      child = parent.get_child( name );
      POLICY::debug( child );
      uvmf_analysis_debug( child );
    end
  endfunction
endclass
