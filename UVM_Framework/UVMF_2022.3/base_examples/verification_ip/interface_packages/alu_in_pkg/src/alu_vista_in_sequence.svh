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
// Project         : ALU_IN interface agent
// Unit            : Sequence library
// File            : alu_vista_in_sequence.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This sequence generates random alu operations.
//
class alu_vista_in_sequence extends alu_in_sequence_base;

  // declaration macros
  `uvm_object_utils(alu_vista_in_sequence)

    uvmc_vista_stimulus_bridge  m_uvmc_vista_stimulus_bridge;
    alu_in_vista_transaction    req;
    int                         cmd;



//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

//*****************************************************************
  task body();
      if (! uvm_config_db #(uvmc_vista_stimulus_bridge) ::get( null, "", "UVMC_VISTA_STIMULUS_BRIDGE", m_uvmc_vista_stimulus_bridge))
          `uvm_fatal("CFG", " uvm_config_db #(m_uvmc_vista_stimulus_bridge)::get cannot find resource");

      forever begin
          m_uvmc_vista_stimulus_bridge.stimMbx.get(req);
          if (req.cmd == 0) begin
              $display("%t alu_vista_in_sequence.svh:  Vista stimulus: stimMbx[op,a,b]= %d %d %d after_get_num=%d", 
                       $time, req.op, req.a, req.b, m_uvmc_vista_stimulus_bridge.stimMbx.num());
              start_item(req);
              finish_item(req);
          end
          else if (req.cmd == 1) begin
              // End of Stimulus
              $display("alu_vista_in_sequence.svh:  Message recieved from Vista to stop simulation at %t", $time);
              break;
          end
          else begin
              $display("alu_vista_in_sequence.svh:  ERROR: Stimulus from Vista req.cmd not correct %t", $time);
          end

      end

  endtask: body


endclass: alu_vista_in_sequence

