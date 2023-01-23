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
// Project         : FLI Package
// Unit            : FLI class
// File            : fli.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class contains utility FLI, foreign language
//    interface, utility functions.
//
//----------------------------------------------------------------------
//
class fli;

//----------------------------------------------------------------------
// This function is used to submit a command string to the Questa simulator.
//     The cmd argument contains the command string as it would be 
//     entered on the Questa command line.  This function returns the 
//     command result as a string.
// 
   static function string send2vsim(string cmd = "" );
      string result;
      chandle interp;
      
      interp = mti_Interp();
      assert (! mti_Cmd(cmd));
      result = Tcl_GetStringResult(interp);
      Tcl_ResetResult(interp);      
      return result;
   endfunction

endclass
