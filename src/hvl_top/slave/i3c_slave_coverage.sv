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
  i3c_slave_agent_config i3c_slave_agent_cfg_h;

  //-------------------------------------------------------
  // Covergroup
  // Covergroup consists of the various coverpoints based on the no. of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup slave_covergroup with function sample (i3c_slave_agent_config cfg, i3c_slave_tx packet);
  option.per_instance = 1;

    // Mode of the operation
    
    //this coverpoint is to check the slave address width
    SLAVE_ADDRESS_WID_CP : coverpoint cfg.slave_address {
      option.comment = "Width of the the slave address";

      bins SLAVE_ADDRESS_WIDTH_7 = {7};
      bins SLAVE_ADDRESS_WIDTH_10 = {10};
    }

    //this coverpoint is to check the slave_addr_ack 
    //SLAVE_ADDR_ACK_BIT  : coverpoint packet.slave_addr_ack {
    //  option.comment = "slave addr ack bit to dete";

    //  bins SLAVE_ADDR_ACK = {1};
    //  bins SLAVE_ADDR_NACK = {0};
    //}
    //
    ////this coverpoint is to check the slave register address width
    //SLAVE_REGISTER_ADDRESS_WID_CP : coverpoint packet.register_address {
    //  option.comment = "Width of the the slave register address";

    //  bins SLAVE_REGISTER_ADDRESS_WIDTH_8 = {8};
    //}
    
    //this coverpoint is to check the write data width
 //   WR_DATA_WID_CP : coverpoint packet.wr_data.size()*DATA_WIDTH{
 //     option.comment = "Width of the the slave address";

 //     bins WRITE_DATA_WIDTH_8 = {8};
 //     bins WRITE_DATA_WIDTH_16 = {16};
 //     bins WRITE_DATA_WIDTH_24 = {24};
 //     bins WRITE_DATA_WIDTH_32 = {32};
 //     bins WRITE_DATA_WIDTH_MAX = {[48:MAXIMUM_BITS]};
 //   }
    
 //   //this coverpoint is to check the read data width
 //   RD_DATA_WID_CP : coverpoint packet.rd_data.size()*DATA_WIDTH{
 //     option.comment = "Width of the the slave address";

 //     bins READ_DATA_WIDTH_8 = {8};
 //     bins READ_DATA_WIDTH_16 = {16};
 //     bins READ_DATA_WIDTH_24 = {24};
 //     bins READ_DATA_WIDTH_32 = {32};
 //     bins READ_DATA_WIDTH_MAX = {[48:MAXIMUM_BITS]};
 //   }
    //this coverpoint is to check the operation is read or write 
    OPERATION_READ_WRITE_CP : coverpoint read_write_e'(packet.read_write){
      option.comment = "operation is read or write";

      bins READ = {1};
      bins WRITE = {0};
    }

    //this coverpoint is to check the direction of the data transfer 
    SHIFT_DIRECTION_CP : coverpoint shift_direction_e'(cfg.shift_dir){
      option.comment = "shift_direction of i3c MSB or LSB";

      bins LSB_FIRST = {0};
      bins MSB_FIRST = {1};
    }
    
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
 `uvm_info("DEBUG_m_coverage", $sformatf("I3C_SLAVE_TX %0p",t),UVM_NONE);

    slave_covergroup.sample(i3c_slave_agent_cfg_h,t);     
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

