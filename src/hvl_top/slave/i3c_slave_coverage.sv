`ifndef I3C_SLAVE_COVERAGE_INCLUDED_
`define I3C_SLAVE_COVERAGE_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: i3c_slave_coverage
// i3c_slave_coverage determines the how much code is covered for better functionality of the TB.
//--------------------------------------------------------------------------------------------
class i3c_slave_coverage extends uvm_subscriber#(i3c_slave_tx);
  `uvm_component_utils(i3c_slave_coverage)

  //creating handle for slave transaction coverage
  i3c_slave_tx slave_tx_cov_data;

  // Variable: master_agent_cfg_h
  // Declaring handle for master agent configuration class 
  i3c_slave_agent_config slave_agent_cfg_h;

  //-------------------------------------------------------
  // Covergroup
  // Covergroup consists of the various coverpoints based on the no. of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup slave_covergroup with function sample (i3c_slave_agent_config cfg, i3c_slave_tx packet);
  option.per_instance = 1;

  endgroup :slave_covergroup


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_slave_coverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_slave_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_slave_coverage

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_slave_coverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_slave_coverage::new(string name = "i3c_slave_coverage", uvm_component parent = null);
  super.new(name, parent);
   slave_covergroup = new(); 
endfunction : new

//--------------------------------------------------------------------------------------------
// Contains the display statements 
//--------------------------------------------------------------------------------------------
function void i3c_slave_coverage::display();
  $display("");
  $display("--------------------------------------");
  $display("SLAVE COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display
//--------------------------------------------------------------------------------------------
// Function: write
// To acess the subscriber write function is required with default parameter as t
//--------------------------------------------------------------------------------------------
function void i3c_slave_coverage::write(i3c_slave_tx t);
    slave_covergroup.sample(slave_agent_cfg_h,t);     
endfunction: write

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void i3c_slave_coverage::report_phase(uvm_phase phase);
  display();
  `uvm_info(get_type_name(), $sformatf("Slave Agent Coverage = %0.2f %%",
                                       slave_covergroup.get_coverage()), UVM_NONE);
endfunction: report_phase
`endif

