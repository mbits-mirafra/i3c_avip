`ifndef I3C_MASTER_COVERAGE_INCLUDED_
`define I3C_MASTER_COVERAGE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_master_coverage
// i3c_master_coverage determines the how much code is covered for better functionality of the TB.
//--------------------------------------------------------------------------------------------
class i3c_master_coverage extends uvm_subscriber#(i3c_master_tx);
  `uvm_component_utils(i3c_master_coverage)

  // Variable: master_agent_cfg_h
  // Declaring handle for master agent configuration class 
    i3c_master_agent_config i3c_master_agent_cfg_h;
 
  //-------------------------------------------------------
  // Covergroup
  // // TODO(mshariff): Add comments
  // Covergroup consists of the various coverpoints based on the no. of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup master_covergroup with function sample (i3c_master_agent_config cfg, i3c_master_tx packet);
    option.per_instance = 1;

    // Mode of the operation
    

  endgroup : master_covergroup

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_master_coverage", uvm_component parent = null);
  //extern virtual function void build_phase(uvm_phase phase);
  //extern virtual function void connect_phase(uvm_phase phase);
  //extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  //extern virtual task run_phase(uvm_phase phase);
  extern virtual function void write(i3c_master_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_master_coverage


//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_master_coverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_master_coverage::new(string name = "i3c_master_coverage", uvm_component parent = null);
  super.new(name, parent);
  // TODO(mshariff): Create the covergroup
//`uvm_info(get_type_name(),$sformatf(master_cg),UVM_LOW);
//
     master_covergroup = new(); 
//  `uvm_info(get_type_name(),$sformatf(master_cg),UVM_LOW); 
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: write
// // TODO(mshariff): Add comments
// sampiling is done
//--------------------------------------------------------------------------------------------
function void i3c_master_coverage::write(i3c_master_tx t);
//  // TODO(mshariff): 
   master_covergroup.sample(i3c_master_agent_cfg_h,t);     
//   `uvm_info(get_type_name(),$sformatf("master_cg=%0d",master_cg),UVM_LOW);
//
//   `uvm_info(get_type_name(),$sformatf(master_cg),UVM_LOW);
//
endfunction: write

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void i3c_master_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Master Agent Coverage = %0.2f %%",master_covergroup.get_coverage()), UVM_NONE);
//  `uvm_info(get_type_name(), $sformatf("Master Agent Coverage") ,UVM_NONE);
endfunction: report_phase
`endif

