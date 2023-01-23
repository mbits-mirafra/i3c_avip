//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
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


package alu_parameters_pkg;

  import uvmf_base_pkg_hdl::*;

  // pragma uvmf custom package_imports_additional begin 
  // pragma uvmf custom package_imports_additional end

  parameter int TEST_ALU_IN_OP_WIDTH = 8;
  parameter int TEST_ALU_OUT_RESULT_WIDTH = 16;
  parameter int TEST_APB_ADDR_WIDTH = 32;
  parameter int TEST_APB_WDATA_WIDTH = 32;
  parameter int TEST_APB_RDATA_WIDTH = 32;

  // These parameters are used to uniquely identify each interface.  The monitor_bfm and
  // driver_bfm are placed into and retrieved from the uvm_config_db using these string 
  // names as the field_name. The parameter is also used to enable transaction viewing 
  // from the command line for selected interfaces using the UVM command line processing.
  parameter string uvm_test_top_environment_qvip_agents_env_apb_master_0  = "uvm_test_top.environment.qvip_agents_env.apb_master_0"; /* [0] */
  parameter string alu_in_agent_BFM  = "alu_in_agent_BFM"; /* [1] */
  parameter string alu_out_agent_BFM  = "alu_out_agent_BFM"; /* [2] */

  // pragma uvmf custom package_item_additional begin
  // pragma uvmf custom package_item_additional end

endpackage

