//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_5
//----------------------------------------------------------------------
// Created by: Vijay Gill
// E-mail:     vijay_gill@mentor.com
// Date:       2019/11/05
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class axi4_2x2_fabric_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( axi4_2x2_fabric_env_sequence_base );

  
  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
  endfunction

endclass

