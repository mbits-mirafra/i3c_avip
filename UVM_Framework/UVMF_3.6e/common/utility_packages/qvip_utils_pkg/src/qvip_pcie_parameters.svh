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
// Project         : QVIP Agent Adapter
// Unit            : Adapter component
// File            : qvip_pcie_parameters.svh
//----------------------------------------------------------------------
// Created by      : David_Aerne@mentor.com
// Creation Date   : 04.21.2014
//----------------------------------------------------------------------
// Description: This class is a container for the parameters used by
//     the PCIe QVIP.  Typedefs of this class can be made to create 
//     frequently used specializations of this class to reduce the
//     number of parameters that need to be set directly.
//
//----------------------------------------------------------------------
class qvip_pcie_parameters #(int LANES = 4,
                             int PIPE_BYTES_MAX = 1,
                             int CONFIG_NUM_OF_FUNCTIONS = 1)
                             extends uvm_object;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

endclass
// Typedefs of the pcie parameter class
typedef qvip_pcie_parameters #(4, 1, 1 ) qvip_pcie_parameters_4_1_1_t;

