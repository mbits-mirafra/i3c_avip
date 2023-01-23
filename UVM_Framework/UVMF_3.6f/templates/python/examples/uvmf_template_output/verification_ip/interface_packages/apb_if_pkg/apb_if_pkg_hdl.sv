//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface HDL Package
// File            : apb_if_pkg_hdl.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that needs to be compiled and synthesized
//    for running on Veloce.
//
// CONTAINS:
//    - <apb_if_typedefs_hdl>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package apb_if_pkg_hdl;
  
  import uvmf_base_pkg_hdl::*;

  `include "src/apb_if_typedefs_hdl.svh"

endpackage

