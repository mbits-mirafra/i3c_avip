//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface HDL Typedefs
// File            : FPU_out_typedefs_hdl.svh
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
                                                                               

typedef enum {STATUS_INEXACT, STATUS_OVERFLOW, STATUS_UNDERFLOW, STATUS_DIV_ZERO, STATUS_INFINITY, STATUS_ZERO, STATUS_QNAN, STATUS_SNAN, STATUS_SIZE} status_t;
typedef bit [STATUS_SIZE-1:0] status_vector_t;

