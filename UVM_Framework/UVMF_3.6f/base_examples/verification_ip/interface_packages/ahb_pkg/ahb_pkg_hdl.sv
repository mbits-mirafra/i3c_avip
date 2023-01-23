//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface HDL Package
// File            : ahb_pkg_hdl.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that needs to be compiled and synthesized
//    for running on Veloce.
//
// CONTAINS:
//    - <ahb_typedefs_hdl>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package ahb_pkg_hdl;
  
  import uvmf_base_pkg_hdl::*;

  `include "src/ahb_typedefs_hdl.svh"

endpackage

