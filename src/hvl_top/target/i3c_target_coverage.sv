`ifndef I3C_TARGET_COVERAGE_INCLUDED_
`define I3C_TARGET_COVERAGE_INCLUDED_

class i3c_target_coverage extends uvm_subscriber#(i3c_target_tx);
  `uvm_component_utils(i3c_target_coverage)

  i3c_target_tx target_tx_cov_data;

  i3c_target_agent_config i3c_target_agent_cfg_h;

  //-------------------------------------------------------
  // Covergroup
  // Covergroup consists of the various coverpoints based on the no. of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup target_covergroup with function sample (i3c_target_agent_config cfg, i3c_target_tx packet);
  option.per_instance = 1;

    // Mode of the operation
    
    //this coverpoint is to check the target address width
    TARGET_ADDRESS_WID_CP : coverpoint cfg.targetAddress {
      option.comment = "Width of the the target address";

      bins TARGET_ADDRESS_WIDTH_7 = {7};
      bins TARGET_ADDRESS_WIDTH_10 = {10};
    }

    //this coverpoint is to check the target_addr_ack 
    //target_ADDR_ACK_BIT  : coverpoint packet.target_addr_ack {
    //  option.comment = "target addr ack bit to dete";

    //  bins target_ADDR_ACK = {1};
    //  bins target_ADDR_NACK = {0};
    //}
    //
    ////this coverpoint is to check the target register address width
    //target_REGISTER_ADDRESS_WID_CP : coverpoint packet.register_address {
    //  option.comment = "Width of the the target register address";

    //  bins target_REGISTER_ADDRESS_WIDTH_8 = {8};
    //}
    
    //this coverpoint is to check the write data width
 //   WR_DATA_WID_CP : coverpoint packet.wr_data.size()*DATA_WIDTH{
 //     option.comment = "Width of the the target address";

 //     bins WRITE_DATA_WIDTH_8 = {8};
 //     bins WRITE_DATA_WIDTH_16 = {16};
 //     bins WRITE_DATA_WIDTH_24 = {24};
 //     bins WRITE_DATA_WIDTH_32 = {32};
 //     bins WRITE_DATA_WIDTH_MAX = {[48:MAXIMUM_BITS]};
 //   }
    
 //   //this coverpoint is to check the read data width
 //   RD_DATA_WID_CP : coverpoint packet.rd_data.size()*DATA_WIDTH{
 //     option.comment = "Width of the the target address";

 //     bins READ_DATA_WIDTH_8 = {8};
 //     bins READ_DATA_WIDTH_16 = {16};
 //     bins READ_DATA_WIDTH_24 = {24};
 //     bins READ_DATA_WIDTH_32 = {32};
 //     bins READ_DATA_WIDTH_MAX = {[48:MAXIMUM_BITS]};
 //   }
    //this coverpoint is to check the operation is read or write 
    OPERATION_READ_WRITE_CP : coverpoint operationType_e'(packet.operation){
      option.comment = "operation is read or write";

      bins READ = {1};
      bins WRITE = {0};
    }

    //this coverpoint is to check the direction of the data transfer 
    DATA_TRANSFER_DIRECTION_CP : coverpoint dataTransferDirection_e'(cfg.DataTransferdirection){
      option.comment = "shift_direction of i3c MSB or LSB";

      bins LSB_FIRST = {0};
      bins MSB_FIRST = {1};
    }
    
  endgroup :target_covergroup


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_target_coverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_target_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_target_coverage

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - i3c_target_coverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_target_coverage::new(string name = "i3c_target_coverage", uvm_component parent = null);
  super.new(name, parent);
   target_covergroup = new(); 
endfunction : new

//--------------------------------------------------------------------------------------------
// Contains the display statements 
//--------------------------------------------------------------------------------------------
function void i3c_target_coverage::display();
  $display("");
  $display("--------------------------------------");
  $display("target COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display
//--------------------------------------------------------------------------------------------
// Function: write
// To acess the subscriber write function is required with default parameter as t
//--------------------------------------------------------------------------------------------
function void i3c_target_coverage::write(i3c_target_tx t);
 `uvm_info("DEBUG_m_coverage", $sformatf("I3C_target_TX %0p",t),UVM_NONE);

    target_covergroup.sample(i3c_target_agent_cfg_h,t);     
endfunction: write

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void i3c_target_coverage::report_phase(uvm_phase phase);
  display();
  `uvm_info(get_type_name(), $sformatf("target Agent Coverage = %0.2f %%",
                                       target_covergroup.get_coverage()), UVM_NONE);
endfunction: report_phase
`endif

