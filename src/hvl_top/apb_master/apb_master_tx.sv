`ifndef APB_MASTER_TX_INCLUDED_
`define APB_MASTER_TX_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: apb_master_tx.
//  This class holds the data items required to drive stimulus to dut 
//  and also holds methods that manipulate those data items
//--------------------------------------------------------------------------------------------
 class apb_master_tx extends uvm_sequence_item;
  `uvm_object_utils(apb_master_tx)

  //Variable: paddr
  //Address selected in apb_slave
  rand bit [ADDRESS_WIDTH-1:0] paddr;

  //Variable: pprot
  //Used for different access
  rand protection_type_e pprot;

  //Variable: pselx
  //Used to select the slave
  rand slave_no_e pselx;

  //Variable: pwrite
  //Write when pwrite is 1 and read is 0
  rand tx_type_e pwrite;

  //Variable: transfer_size
  //Used to dcide the transfer size of the pwdata
  rand transfer_size_e transfer_size;

  //Variable: pwdata
  //Used to store the wdata
  rand bit [DATA_WIDTH-1:0]pwdata;

  //Variable: pstrb
  //Used to transfer the data to pwdata bus
  rand bit [(DATA_WIDTH/8)-1:0]pstrb;              
    
  //Variable: prdata
  //Used to store the rdata from the slave
  bit [DATA_WIDTH-1:0]prdata;

  //Variable: pslverr
  //Goes high when a transfer fails
  slave_error_e pslverr;

  //Variable: apb_master_agent_cfg_h
  //Instantiation of apb master agent config
  apb_master_agent_config apb_master_agent_cfg_h;

  // Variable: no_of_wait_states_detected
  // Used to keep track of the no of wait states
  int no_of_wait_states_detected;

  // Variable : cont_write_read
  // Used to show the transfer as cont write and read
  rand bit cont_write_read;
 
  //Variable : address
  bit [ADDRESS_WIDTH-1:0]address;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new  (string name = "apb_master_tx");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void post_randomize();

  //-------------------------------------------------------
  // Constraints defined on variables pselx,
  //-------------------------------------------------------
  constraint pselx_c1  { $countones(pselx) == 1; }

  constraint pselx_c2 { pselx >0 && pselx < 2**NO_OF_SLAVES; }

  constraint pwdata_c3 { soft pwdata inside {[0:100]}; }

  //This constraint is used to decide the pwdata size based om transfer size
  constraint transfer_size_c4 {if(transfer_size == BIT_8)
                                  $countones (pstrb) == 1;
                              else if(transfer_size == BIT_16)
                                      $countones (pstrb) == 2;
                              else if(transfer_size == BIT_24)
                                      $countones (pstrb) == 3;
                              else 
                                  $countones (pstrb) == 4;
                             }
endclass : apb_master_tx

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes the class object
//
// Parameters:
//  name - apb_master_tx
//--------------------------------------------------------------------------------------------
function apb_master_tx::new(string name = "apb_master_tx");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_copy
//  Copy method is implemented using handle rhs
//
// Parameters:
//  rhs - uvm_object
//--------------------------------------------------------------------------------------------
function void apb_master_tx::do_copy (uvm_object rhs);
  apb_master_tx apb_master_tx_copy_obj;

  if(!$cast(apb_master_tx_copy_obj,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);

  paddr   = apb_master_tx_copy_obj.paddr;
  pprot   = apb_master_tx_copy_obj.pprot;
  pselx   = apb_master_tx_copy_obj.pselx;
  pwrite  = apb_master_tx_copy_obj.pwrite;
  pwdata  = apb_master_tx_copy_obj.pwdata;
  pstrb   = apb_master_tx_copy_obj.pstrb;
  prdata  = apb_master_tx_copy_obj.prdata;
  pslverr = apb_master_tx_copy_obj.pslverr;

endfunction : do_copy

//--------------------------------------------------------------------------------------------
// Function: do_compare
//  Compare method is implemented using handle rhs
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function bit apb_master_tx::do_compare (uvm_object rhs, uvm_comparer comparer);
  apb_master_tx apb_master_tx_compare_obj;

  if(!$cast(apb_master_tx_compare_obj,rhs)) begin
    `uvm_fatal("FATAL_APB_MASTER_TX_DO_COMPARE_FAILED","cast of the rhs object failed")
    return 0;
  end

  return super.do_compare(apb_master_tx_compare_obj, comparer) &&
  paddr   == apb_master_tx_compare_obj.paddr &&
  pprot   == apb_master_tx_compare_obj.pprot &&
  pselx   == apb_master_tx_compare_obj.pselx &&
  pwrite  == apb_master_tx_compare_obj.pwrite &&
  pwdata  == apb_master_tx_compare_obj.pwdata &&
  pstrb   == apb_master_tx_compare_obj.pstrb &&
  prdata  == apb_master_tx_compare_obj.prdata &&
  pslverr == apb_master_tx_compare_obj.pslverr;

endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
//  Print method can be added to display the data members values
//
// Parameters:
//  printer - uvm_printer
//--------------------------------------------------------------------------------------------
function void apb_master_tx::do_print(uvm_printer printer);
  
  printer.print_string ("pselx",pselx.name());
  printer.print_field  ("paddr",paddr,$bits(paddr),UVM_HEX);
  printer.print_string ("pwrite",pwrite.name());
  printer.print_field  ("pwdata",pwdata,$bits(pwdata),UVM_HEX);
  printer.print_string ("transfer_size",transfer_size.name());
  printer.print_field  ("pstrb",pstrb,4,UVM_BIN);
  printer.print_string ("pprot",pprot.name());
  printer.print_field  ("prdata",prdata,$bits(prdata),UVM_HEX);
  printer.print_string ("pslverr",pslverr.name());
  printer.print_field  ("no_of_wait_states_detected", no_of_wait_states_detected, $bits(no_of_wait_states_detected), UVM_DEC);

endfunction : do_print

//--------------------------------------------------------------------------------------------
// Function : post_randomize
// Selects the address based on the slave selected
//--------------------------------------------------------------------------------------------
function void apb_master_tx::post_randomize();
  int index;

  // Derive the slave number using the index
  for(int i=0; i<NO_OF_SLAVES; i++) begin
    if(pselx[i]) begin
      index = i;
    end
  end
  
  // Randmoly chosing paddr value between a given range
  if (!std::randomize(paddr) with { paddr inside {[apb_master_agent_cfg_h.master_min_addr_range_array[index]:
                                                   apb_master_agent_cfg_h.master_max_addr_range_array[index]]};
    paddr %4 == 0;
  }) begin
    `uvm_fatal("FATAL_STD_RANDOMIZATION_PADDR", $sformatf("Not able to randomize paddr"));
  end

  //Constraint to make pwdata non-zero when pstrb is high for that 8-bit lane
  for(int i=0; i<DATA_WIDTH/8; i++) begin
    `uvm_info(get_type_name(),$sformatf("MASTER-TX-pstrb[%0d]=%0d",i,pstrb[i]),UVM_HIGH);
    if(pstrb[i]) begin
      `uvm_info(get_type_name(),$sformatf("MASTER-TX-pstrb[%0d]=%0d",i,pstrb[i]),UVM_HIGH);
      if(!std::randomize(pwdata) with {pwdata[8*i+7 -: 8] != 0;}) begin
        `uvm_fatal("FATAL_STD_RANDOMIZATION_PWDATA", $sformatf("Not able to randomize pwdata"));
      end
      else begin
        `uvm_info(get_type_name(),$sformatf("MASTER-TX-pwdata[%0d]=%0h",8*i+7,pwdata[8*i+7 +: 8]),UVM_HIGH);
      end 
    end
  end

endfunction : post_randomize

`endif

