//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This test extends test_top and makes 
//    changes to test_top using the UVM factory type_override:
//
//    Test scenario: 
//      This is a template test that can be used to create future tests.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class scatter_gather_dma_err_test extends test_top;

  `uvm_component_utils( scatter_gather_dma_err_test );

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  typedef ccs_transaction #(.WIDTH(1)) ccs_transaction_1_t;
  typedef ccs_transaction_wait_cycles #(.WIDTH(1)) ccs_transaction_wait_cycles_1_t;

  virtual function void build_phase(uvm_phase phase);
    // The factory override below is an example of how to replace the scatter_gather_dma_bench_sequence_base 
    // sequence with the scatter_gather_dma_err_test_sequence.
    scatter_gather_dma_bench_sequence_base::type_id::set_type_override(scatter_gather_dma_err_seq::get_type());
    ccs_transaction_1_t::type_id::set_type_override(ccs_transaction_wait_cycles_1_t::get_type());
    // Execute the build_phase of test_top AFTER all factory overrides have been created.
    super.build_phase(phase);
    // pragma uvmf custom configuration_settings_post_randomize begin
    // UVMF_CHANGE_ME Test specific configuration values can be set here.  
    // The configuration structure has already been randomized.
    // pragma uvmf custom configuration_settings_post_randomize end

    // in addition to factory overrides specified above, now also, post super.build_phase(), update the 
    // mgc_axi4_s0_config_policy to apply updated, per this test, configuration settings.
    // For the moment, these updates only change default delays from axi4 qvip slave to be non-zero.
    mgc_axi4_s0_cov_config_policy::configure(
              configuration.scatter_gather_dma_qvip_subenv_config.mgc_axi4_s0_cfg,
              configuration.scatter_gather_dma_qvip_subenv_config.mgc_axi4_s0_cfg.addr_map
             );

  endfunction

endclass

