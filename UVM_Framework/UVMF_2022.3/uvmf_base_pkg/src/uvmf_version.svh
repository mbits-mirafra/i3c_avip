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
// Unit            : Base class library
// File            : uvmf_version.svh
//----------------------------------------------------------------------
// Creation Date   : 04.13.2014
//----------------------------------------------------------------------

// CLASS: uvmf_version
// This class contains classes used to maintain and display the UVM Framework
// revision number and notes.
//
// Define the major and minor UVMF release number
`define UVMF_MAJOR_VERSION 2022
`define UVMF_MINOR_VERSION 3
`define UVMF_PATCH_VERSION ""

class uvmf_version;
  static bit b = print_version();

  // FUNCTION: print_version
  // Prints the header with UVM Framework version.
  //
  // RETURNS:
  //     bit - Used to print this header. Once run, it's set and isn't run again.
  static function bit print_version();
    $display("----------------------------------------------------------------");
    $display("//  UVM Framework ");
    $display("//  Version %0d.%0d%s" , `UVMF_MAJOR_VERSION , `UVMF_MINOR_VERSION, `UVMF_PATCH_VERSION);
    $display("//  (C) 2013-2022 Siemens Corporation");
    $display("//  Digital Industries Software");
    $display("//  Siemens EDA");
    $display("//  All Rights Reserved.");
    $display("----------------------------------------------------------------");
    $display("\n");
    return 1;
  endfunction
endclass

