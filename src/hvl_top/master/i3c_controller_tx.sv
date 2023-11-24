`ifndef I3C_CONTROLLER_TX_INCLUDED_
`define I3C_CONTROLLER_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: i3c_controller_tx
// 
//--------------------------------------------------------------------------------------------

class i3c_controller_tx extends uvm_sequence_item;
  `uvm_object_utils(i3c_controller_tx)

  rand operationType_e operation;
  rand bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress;
  rand bit [DATA_WIDTH-1:0] writeData[];
  rand acknowledge_e readDataStatus[];

       bit [DATA_WIDTH-1:0] readData[];

  rand bit[31:0] size;
  rand bit [REGISTER_ADDRESS_WIDTH-1:0]register_address;

  bit ack;
  
  rand bit [NO_OF_TARGETS-1:0] index; 
  rand bit [7:0] raddr; 
  
  // Receiving data fields
  bit target_add_ack = 1;
  bit reg_add_ack = 1;
  bit writeData_ack[$];

  // MSHA: i3c_controller_agent_config i3c_controller_agent_cfg_h;
  //-------------------------------------------------------
  // Constraints for I3C
  //-------------------------------------------------------
  
  //The register_address_arrayis of the mode of 4 because data width is 32bit 

  //constraint register_addr_c{register_address%4 == 0;} 
  //constraint s_addr_index_c{index inside {[0:NO_OF_targetS-1]};}
  //constraint s_addr_c{targetAddress == i3c_controller_agent_cfg_h.target_address_array[index];solve index before target_address;}
  //constraint s_sb_c{solve index before target_address;}
 
  //constraint r_addr_size_c{raddr inside {[0:7]};}
  //constraint r_addr_c{register_address == i3c_controller_agent_cfg_h.target_register_address_array[raddr];}
  //constraint r_sb_c{solve raddr before register_address;}
  
  // Write Data
  //constraint write_data_c {soft writeData.size() %4 == 0;
  //                              writeData.size() != 0; 
  //                         soft writeData.size() == 4;
  //                              writeData.size() <= MAXIMUM_BYTES; }
  
  
  //constraint target_addr_0{target_address==i3c_controller_agent_cfg_h.target_address_array[0];}
  //constraint target_addr_1{target_address==i3c_controller_agent_cfg_h.target_address_array[1];}
  //constraint target_addr_2{target_address==i3c_controller_agent_cfg_h.target_address_array[2];}
  //constraint target_addr_3{target_address==i3c_controller_agent_cfg_h.target_address_array[3];}

 //                    reg_address.size() < MAXIMUM_BITS/CHAR_LENGTH;}
 // 
 // constraint data{reg_address.size() > 0 ;
 //                    reg_address.size() < MAXIMUM_BITS/CHAR_LENGTH;}
 // 
 // constraint target_address_width_e {target_addr_mode == 1'b0;}
 // 
 // constraint target_addr{
 //                       if(target_addr_mode == 1'b0) 
 //                         {target_address == 7'b101_0100;}
 //                       if(target_addr_mode == 1'b1) 
 //                         {target_address == 10'b10_1010_0101;}
 // }

//   constraint target_addr{i3c_controller_agent_cfg_h.target_address_width.size() > 0 ;
//                     i3c_controller_agent_cfg_h.target_address_width.size() < MAXIMUM_BITS/CHAR_LENGTH;}
 // constraint target_addr_0{
 //   if(i3c_controller_agent_cfg_h.target_address_array[0]==7'b0000000)
 //     target_address==i3c_controller_agent_cfg_h.target_address_array[0];
 //   }

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "i3c_controller_tx");
  extern function void post_randomize();
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer); 
  extern function void do_print(uvm_printer printer);

endclass : i3c_controller_tx

//--------------------------------------------------------------------------------------------
//  Construct: new
//  initializes the class object
//
//  Parameters:
//  name - i3c_controller_tx
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function i3c_controller_tx::new(string name = "i3c_controller_tx");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// do_copy method
//--------------------------------------------------------------------------------------------

function void i3c_controller_tx::do_copy (uvm_object rhs);
  i3c_controller_tx rhs_;
  
  if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);

  targetAddress= rhs_.targetAddress;
  register_address= rhs_.register_address;
  writeData = rhs_.writeData;
  size = rhs_.size;

endfunction : do_copy


//--------------------------------------------------------------------------------------------
// do_compare method
//--------------------------------------------------------------------------------------------
function bit  i3c_controller_tx::do_compare (uvm_object rhs,uvm_comparer comparer);
  i3c_controller_tx rhs_;

  if(!$cast(rhs_,rhs)) begin
  `uvm_fatal("FATAL_I3C_controller_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(rhs,comparer) &&
  targetAddress == rhs_.targetAddress &&
  register_address == rhs_.register_address &&
  size == rhs_.size &&
  writeData == rhs_.writeData;
endfunction : do_compare 
//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void i3c_controller_tx::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_field($sformatf("targetAddress"),this.targetAddress,$bits(targetAddress),UVM_HEX);
  //printer.print_field($sformatf("register_address"),this.register_address,8,UVM_HEX);
  printer.print_string($sformatf("operation"),operation.name());
  printer.print_field($sformatf("Size"),this.size,1,UVM_HEX);
  
  for(int i = 0;i < size;i++) begin
    printer.print_field($sformatf("writeData[%0d]",i),this.writeData[i],8,UVM_HEX);
  end

  //printer.print_field($sformatf("target_add_ack"),this.target_add_ack,1,UVM_BIN);
  //printer.print_field($sformatf("reg_add_ack"),this.reg_add_ack,1,UVM_BIN);
  //foreach(writeData_ack[i]) begin
  //  printer.print_field($sformatf("writeData_ack[%0d]",i),this.writeData_ack[i],1,UVM_HEX);
  //end

endfunction : do_print

//--------------------------------------------------------------------------------------------
// Function: post_randomize
// Used for setting target address value based on the configurations value
//--------------------------------------------------------------------------------------------
function void i3c_controller_tx::post_randomize();
// MSHA:   targetAddress = i3c_controller_agent_cfg_h.targetAddress_array[index];
// MSHA:   `uvm_info("DEBUG_MSHA", $sformatf("index = %0d and targetAddress = %0x", index, targetAddress), UVM_NONE)
endfunction: post_randomize
`endif
