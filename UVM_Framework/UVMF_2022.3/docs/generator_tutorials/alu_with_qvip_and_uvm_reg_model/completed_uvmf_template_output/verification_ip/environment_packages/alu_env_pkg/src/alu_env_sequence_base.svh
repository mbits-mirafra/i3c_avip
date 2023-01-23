//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
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
class alu_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( alu_env_sequence_base );

  // Handle to the environments register model
// This handle needs to be set before use.
  alu_reg_model  reg_model;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
  endfunction

endclass

