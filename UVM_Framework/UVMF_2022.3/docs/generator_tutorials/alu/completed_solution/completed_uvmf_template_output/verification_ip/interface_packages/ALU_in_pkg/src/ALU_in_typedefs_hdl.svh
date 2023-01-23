//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains defines and typedefs to be compiled for use in
// the simulation running on the emulator when using Veloce.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
                                                                               

typedef enum bit[2:0] {no_op = 3'b000, add_op = 3'b001, and_op = 3'b010, xor_op = 3'b011, mul_op = 3'b100, rst_op = 3'b111} alu_in_op_t;

// pragma uvmf custom additional begin
// pragma uvmf custom additional end

