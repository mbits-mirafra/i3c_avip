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
// Project         : ALU Example
// Unit            : Predictor
// File            : alu_vista_predictor.svh
//----------------------------------------------------------------------
// Creation Date   : 04.24.2015
//----------------------------------------------------------------------
// Description: This class defines the predictor for the alu environment.  
//    This predictor predicts AHB to WB DUT operation using a Vista model.
//
//----------------------------------------------------------------------
//
import uvmc_pkg::*;

`include "uvm_tlm_target_socket_decl.svh"

// Create Socket classes with specific b_transport names
`uvm_tlm_b_target_socket_decl(_result)

class alu_vista_predictor extends alu_predictor #(.T(alu_in_transaction),.P(alu_out_transaction));
   `uvm_component_utils( alu_vista_predictor );

   // Instantiate UVM sockets
   uvm_tlm_b_target_socket_result #(alu_vista_predictor, uvm_tlm_generic_payload) result_skt;
   uvm_tlm_b_initiator_socket     #(uvm_tlm_generic_payload)                      alu_skt;
   uvm_tlm_time                                                                   gp_delay;

// ****************************************************************************
   function new(string name, uvm_component parent);
      super.new(name, parent);
      // Construct UVMC sockets
      result_skt = new("result_skt", this);
      alu_skt    = new("alu_skt"   , this);
      gp_delay   = new("gp_delay"  , 0);

   endfunction : new

// ****************************************************************************
  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
     // Bind local sockets to UVM-Connect
     // Default data conversion SC <-> SV
     //uvmc_tlm #(uvm_tlm_generic_payload)::connect(result_skt,  ":uvmc_alu_result");
     //uvmc_tlm #(uvm_tlm_generic_payload)::connect(alu_skt,     ":uvmc_alu_data"  );
     // "Fast Packer" data conversion 
     uvmc_tlm #(uvm_tlm_generic_payload, uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter)::connect(result_skt,  ":uvmc_alu_result");
     uvmc_tlm #(uvm_tlm_generic_payload, uvm_tlm_phase_e, uvmc_xl_tlm_gp_converter)::connect(alu_skt,     ":uvmc_alu_data"  );
     super.build_phase(phase);
  endfunction

// ****************************************************************************
  // FUNCTION: connect_phase
  virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
  endfunction

// ****************************************************************************
  // TASK: run_phase
  virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
  endtask

    

// MBMB: We could introduce a get_vista_response() task which waits for b_transport_result() from Vista,
//       This task would simply wait for an event from b_transport_result(), and then call
//       transformed_result_analysis_port.write().  
//       Currently transformed_result_analysis_port.write() causes time advance (blocks) which delays the 
//       return to Vista.  Thus from a Vista perspective, the predicted result takes a long time to be accepted,
//       (not just the usual bus latency).
// ****************************************************************************
    // TASK: monitor result socket from Vista
    virtual task b_transport_result(uvm_tlm_generic_payload tlm_gp, uvm_tlm_time delay);
        bit  [63:0]    addr     = tlm_gp.get_address();   // actually 64 bit address
        int  unsigned  size     = tlm_gp.get_data_length;
        byte unsigned  gpData[] = new[size];
        bit  [31:0]    tmpData  = 0;

        //alu_out_transaction txn;
        P  txn = new;


        if (size != 2) begin
            $display("ERROR:  b_transport_result: %t illegal write size (%d)",$time,size); 
        end

        if(tlm_gp.is_write())
        begin
            tlm_gp.get_data(gpData);
            // byte swap the little endian generic_payload and store
            txn.result = {<< byte{gpData[0:1]}};
            `uvm_info("PRED",{"ALU_RESULT: ",txn.convert2string()},UVM_MEDIUM);

            // MBMB oddly, write to this port takes many cycles...
            //$display("%t Vista predictor b_transport_result START analysis port write",$time);
            transformed_result_analysis_port.write(txn);
            //$display("%t Vista predictor b_transport_result END analysis port write",$time);

        end
        else
        begin
            $display("ERROR:  alu_vista_predictor: b_transport_result() READ operation illegal");
        end

    endtask

// ****************************************************************************
// FUNCTION: transform
//    This function receives data that was presented to the DUT.  This data
//    is submitted to the Vista model for prediction
//
  virtual function P transform ( input T t );

        

      fork
      // Pack t.a and t.b into generic payload

      // Send generic payload to Vista model for prediction.
      // The b_transport call is a task so it must be forked off.
      // The result will be retrieved by the get_vista_response() task
        const int unsigned       gpAluDataBytes    = 3;
        byte unsigned            gpAluData[]       = new[gpAluDataBytes];
        uvm_tlm_generic_payload  gpAlu             = new("gpAlu");

        gpAlu.set_write             ();
        gpAlu.set_address           (0);
        gpAlu.set_byte_enable_length(0);
        gpAlu.set_data_length       (gpAluDataBytes);
        gpAlu.set_streaming_width   (gpAluDataBytes);

        gpAluData[0] = t.a; 
        gpAluData[1] = t.b; 
        gpAluData[2] = t.op; 
        gpAlu.set_data(gpAluData);
      
        `uvm_info("PRED",{"ALU_IN: ",t.convert2string()},UVM_MEDIUM);

         alu_skt.b_transport(gpAlu,gp_delay);
      join_none

      // Return null because we don't have the response from Vista yet.
      // response will be sent by calling the transformed_result_analysis_port.write() function.
      return (null);

  endfunction

endclass

