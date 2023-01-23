//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface HDL Typedefs
// File            : FPU_in_typedefs_hdl.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains defines and typedefs to be compiled for use in
// the simulation running on the emulator when using Veloce.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
                                                                               

typedef enum {add_op, sub_op, mul_op, div_op, sqr_op} fpu_op_t;
typedef enum {even_rnd, zero_rnd, up_rnd, down_rnd} fpu_rnd_t;
typedef struct  {shortreal  a; shortreal  b; fpu_op_t op; fpu_rnd_t round;} reqstruct;
typedef struct  {shortreal  a; shortreal  b; fpu_op_t op; fpu_rnd_t round; shortreal result;} rspstruct;

