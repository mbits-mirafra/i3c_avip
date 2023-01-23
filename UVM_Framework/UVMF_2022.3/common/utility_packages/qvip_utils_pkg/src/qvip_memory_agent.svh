//----------------------------------------------------------------------
//   Copyright 2020 Mentor Graphics Corporation
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
class qvip_memory_agent #(type CONFIG_T, type TRANS_T) extends uvm_component;

  `uvm_component_param_utils( qvip_memory_agent #(CONFIG_T,TRANS_T) )

  CONFIG_T vip_config_h;

  TRANS_T monitored_transaction;

  string if_name;

  uvm_analysis_port #(TRANS_T) monitored_ap;

function new (string name="", uvm_component parent = null);
   super.new (name,parent);
   monitored_ap = new("monitored_ap", this);
endfunction

function void set_if_name(string if_name);
   this.if_name = if_name;
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  monitored_transaction   = TRANS_T ::type_id::create("monitored_transaction");
  monitored_transaction.m_receive_id = get_stream_id (this);
  vip_config_h = CONFIG_T::type_id::create("vip_config_h");
  if( !uvm_config_db #( virtual mgc_ddr )::get( null , "UVMF_VIRTUAL_INTERFACES" , if_name , vip_config_h.m_bfm ) ) begin
        $stacktrace;
        `uvm_fatal("CFG" , $sformatf("uvm_config_db #( virtual mgc_ddr )::get cannot find interface bfm resource with interface_name %s",if_name ))
        end
endfunction

task run_phase(uvm_phase phase);

  // if(vip_config_h == null)
    // vip_config_h  = CONFIG_T::get_config(this);

  vip_config_h.wait_for_clock();
  vip_config_h.wait_for_reset();

  fork
    forever
    begin
      monitored_transaction.receive(vip_config_h);
      monitored_ap.write(monitored_transaction);
    end
  join

endtask

endclass



