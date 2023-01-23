//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : AHB to WB Simulation Bench
// Unit            : AHB Random Test
// File            : alu_random_test.svh
//----------------------------------------------------------------------
// Created by      : jonathan_craft@mentor.com
// Creation Date   : 04.17.2014
//----------------------------------------------------------------------
// Description: This test extends test_top but adds a UVM_ERROR in order
//    to make the test fail and invoke VRM's automatic rerun capabilities
//
//----------------------------------------------------------------------
//
class will_always_fail extends test_top;

  `uvm_component_utils( will_always_fail );

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_error("TEST","Forcing an error to invoke VRM rerun")
    super.run_phase(phase);
  endtask

endclass
