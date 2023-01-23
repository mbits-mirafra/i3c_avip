//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU Simulation Bench 
// Unit            : Bench level parameters package
// File            : FPU_parameters_pkg.sv
//----------------------------------------------------------------------
// 
//                                         
//----------------------------------------------------------------------
//


package FPU_parameters_pkg;

import uvmf_base_pkg_hdl::*;


// These parameters are used to uniquely identify each interface.  The monitor_bfm and
// driver_bfm are placed into and retrieved from the uvm_config_db using these string 
// names as the field_name. The parameter is also used to enable transaction viewing 
// from the command line for selected interfaces using the UVM command line processing.

parameter string FPU_in_agent_BFM  = "FPU_in_agent_BFM"; /* [0] */
parameter string FPU_out_agent_BFM  = "FPU_out_agent_BFM"; /* [1] */


endpackage

