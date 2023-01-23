//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2016 Oct 16
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Simulation Bench 
// Unit            : Bench level parameters package
// File            : axi4_2x2_fabric_parameters_pkg.sv
//----------------------------------------------------------------------
// 
//                                         
//----------------------------------------------------------------------
//

package axi4_2x2_fabric_parameters_pkg;

import uvmf_base_pkg_hdl::*;


// These parameters are used to uniquely identify each interface.  The monitor_bfm and
// driver_bfm are placed into and retrieved from the uvm_config_db using these string 
// names as the field_name. The parameter is also used to enable transaction viewing 
// from the command line for selected interfaces using the UVM command line processing.

parameter string axi4_2x2_fabric_qvip_pkg_mgc_axi4_m0_BFM  = "mgc_axi4_m0"; /* [0] */
parameter string axi4_2x2_fabric_qvip_pkg_mgc_axi4_m1_BFM  = "mgc_axi4_m1"; /* [1] */
parameter string axi4_2x2_fabric_qvip_pkg_mgc_axi4_s0_BFM  = "mgc_axi4_s0"; /* [2] */
parameter string axi4_2x2_fabric_qvip_pkg_mgc_axi4_s1_BFM  = "mgc_axi4_s1"; /* [3] */

string interface_names[] = {
    axi4_2x2_fabric_qvip_pkg_mgc_axi4_m0_BFM /* mgc_axi4_m0     [0] */ , 
    axi4_2x2_fabric_qvip_pkg_mgc_axi4_m1_BFM /* mgc_axi4_m1     [1] */ , 
    axi4_2x2_fabric_qvip_pkg_mgc_axi4_s0_BFM /* mgc_axi4_s0     [2] */ , 
    axi4_2x2_fabric_qvip_pkg_mgc_axi4_s1_BFM /* mgc_axi4_s1     [3] */ 
};

uvmf_active_passive_t interface_activities[] = { 
    ACTIVE /* mgc_axi4_m0     [0] */ , 
    ACTIVE /* mgc_axi4_m1     [1] */ , 
    ACTIVE /* mgc_axi4_s0     [2] */ , 
    ACTIVE /* mgc_axi4_s1     [3] */ 
};



endpackage

