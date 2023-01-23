//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: This package contains test level parameters
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//


package scatter_gather_dma_parameters_pkg;

  import uvmf_base_pkg_hdl::*;

  // pragma uvmf custom package_imports_additional begin 
  // pragma uvmf custom package_imports_additional end


  // These parameters are used to uniquely identify each interface.  The monitor_bfm and
  // driver_bfm are placed into and retrieved from the uvm_config_db using these string 
  // names as the field_name. The parameter is also used to enable transaction viewing 
  // from the command line for selected interfaces using the UVM command line processing.
  parameter string uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_m0  = "uvm_test_top.environment.scatter_gather_dma_qvip_subenv.mgc_axi4_m0"; /* [0] */
  parameter string uvm_test_top_environment_scatter_gather_dma_qvip_subenv_mgc_axi4_s0  = "uvm_test_top.environment.scatter_gather_dma_qvip_subenv.mgc_axi4_s0"; /* [1] */
  parameter string dma_done_rsc_BFM  = "dma_done_rsc_BFM"; /* [2] */

  // pragma uvmf custom package_item_additional begin
  // pragma uvmf custom package_item_additional end

endpackage

