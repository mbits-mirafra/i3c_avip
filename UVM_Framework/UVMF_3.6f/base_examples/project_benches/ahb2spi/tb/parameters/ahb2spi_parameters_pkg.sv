//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 26
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb2spi Simulation Bench 
// Unit            : Bench level parameters package
// File            : ahb2spi_parameters_pkg.sv
//----------------------------------------------------------------------
// 
//                                         
//----------------------------------------------------------------------
//

package ahb2spi_parameters_pkg;

import uvmf_base_pkg_hdl::*;

// These parameters are used to uniquely identify each interface.  The monitor_bfm and
// driver_bfm are placed into and retrieved from the uvm_config_db using these string 
// names as the field_name. The parameter is also used to enable transaction viewing 
// from the command line for selected interfaces using the UVM command line processing.

parameter string ahb_pkg_ahb_BFM  = "ahb_pkg_ahb_BFM"; /* [0] */
parameter string wb_pkg_wb_BFM  = "wb_pkg_wb_BFM"; /* [1,2]   1 and 2 use shared monitor bfm */
parameter string spi_pkg_spi_BFM  = "spi_pkg_spi_BFM"; /* [3] */

parameter int WB_ADDR_WIDTH = 32;
parameter int WB_DATA_WIDTH = 16;

string interface_names[] = {
    ahb_pkg_ahb_BFM /* ahb     [0] */ , 
    wb_pkg_wb_BFM /* wb     [1] */ , 
    wb_pkg_wb_BFM /* wb     [2] */ , 
    spi_pkg_spi_BFM /* spi     [3] */ 
};

uvmf_active_passive_t interface_activities[] = { 
    ACTIVE /* ahb     [0] */ , 
    PASSIVE /* wb     [1] */ , 
    PASSIVE /* wb     [2] */ , 
    ACTIVE /* spi     [3] */ 
};



endpackage

