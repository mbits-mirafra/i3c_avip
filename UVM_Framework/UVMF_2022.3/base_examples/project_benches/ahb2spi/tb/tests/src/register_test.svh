//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
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

class register_test extends test_top;

  `uvm_component_utils( register_test );

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // The factory override below replaces the ahb2spi_bench_sequence_base 
    // sequence with the register_test_sequence.
    ahb2spi_bench_sequence_base::type_id::set_type_override(register_test_sequence::get_type());
    // Execute the build_phase of test_top AFTER all factory overrides have been created.
    super.build_phase(phase);
  endfunction


  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // pragma uvmf custom register_test_scoreboard_control begin
    environment.ahb2wb.ahb2wb_sb.disable_scoreboard();
    environment.ahb2wb.ahb2wb_sb.disable_end_of_test_activity_check();
    environment.ahb2wb.wb2ahb_sb.disable_scoreboard();
    environment.ahb2wb.wb2ahb_sb.disable_end_of_test_activity_check();
    environment.wb2spi.wb2spi_sb.disable_scoreboard();
    environment.wb2spi.wb2spi_sb.disable_end_of_test_activity_check();
    // pragma uvmf custom register_test_scoreboard_control end
  endfunction
endclass

