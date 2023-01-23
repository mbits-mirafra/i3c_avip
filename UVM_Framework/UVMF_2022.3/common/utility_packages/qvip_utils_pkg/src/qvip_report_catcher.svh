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
//
//  The code below should be added to the build_phase of test_top before the call to configuration.initialize()
//  This code redirects the QVIP messaging through the UVM messaging mechanism.  
//  Add the following to the vsim command line to enable:
//     +QVIP_UVM_REPORTING
//  This can be done through the UVMF Makefile by adding the following:
//     COMMON_VSIM_ARGS+=+QVIP_UVM_REPORTING
//  Be sure to replace qvip_sub_env_inst_config.qvip_memory_model_config. with the hierarchical path 
//     to the QVIP Configurator generated configuration.
/*
if ($test$plusargs("QVIP_UVM_REPORTING")) begin
  message_handler = new("message_handler");
  configuration.qvip_sub_env_inst_config.qvip_memory_model_config.m_bfm.set_interface(QUESTA_MVC_INTERFACE_CONFIG_ERROR_OUTPUT_ON,0);
  configuration.qvip_sub_env_inst_config.qvip_memory_model_config.m_bfm.register_interface_reporter(message_handler);
  `uvm_info("QVIP_REPORTER",$psprintf("%s.message_handler registered.",configuration.qvip_sub_env_inst_config.qvip_memory_model_config.m_bfm.get_full_name()),UVM_LOW);
  end
*/

class qvip_memory_message_handler extends QUESTA_MVC::questa_mvc_reporter;

  extern function new(string name = "QVIP_MEMORY_MESSAGE_HANDLER");

  extern function void report_message(string category,
                                      string fileName,
                                      int    lineNo,
                                      string objectName,
                                      string instanceName,
                                      string error_no,
                                      string typ,
                                      string mess);
endclass


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

function qvip_memory_message_handler::new(string name = "QVIP_MEMORY_MESSAGE_HANDLER" ) ;
  super.new(name) ;
endfunction // new


function void qvip_memory_message_handler::report_message(string category,
                                                          string fileName,
                                                          int    lineNo,
                                                          string objectName,
                                                          string instanceName,
                                                          string error_no,
                                                          string typ,
                                                          string mess);

  case (typ)
    "ERROR": begin
      `uvm_error({"QVIP/",category,"/",error_no},
                 {mess,"(",objectName," ",instanceName,")"})
    end
    "FATAL": begin
      `uvm_fatal({"QVIP/",category,"/",error_no},
                 {mess,"(",objectName," ",instanceName,")"})
    end
    "WARNING": begin
      `uvm_warning({"QVIP/",category,"/",error_no},
                   {mess,"(",objectName," ",instanceName,")"})
    end
    "CONTINUE","MESSAGE","NOTE": begin
      `uvm_info({"QVIP/",category,"/",error_no},
                {mess,"(",objectName," ",instanceName,")"},UVM_MEDIUM)
    end
  endcase // case (typ)

endfunction
