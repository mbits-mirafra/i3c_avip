`ifndef APB_MASTER_ADAPTER_INCLUDED_
`define APB_MASTER_ADAPTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: apb_master_adapter
// Converts register transactions to APB transactions and vice-versa
//--------------------------------------------------------------------------------------------
class apb_master_adapter extends uvm_reg_adapter;
  `uvm_object_utils(apb_master_adapter)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "apb_master_adapter");
  extern function uvm_sequence_item reg2bus( const ref uvm_reg_bus_op rw );
  extern function void bus2reg( uvm_sequence_item bus_item,
                              ref uvm_reg_bus_op rw );
endclass : apb_master_adapter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - apb_master_adapter
//--------------------------------------------------------------------------------------------
function apb_master_adapter::new(string name = "apb_master_adapter");
  super.new(name);

  // Set default values for the two variables based on bus protocol
  // APB does not support either, so both are turned off
  supports_byte_enable = 0;
  provides_responses   = 0;
endfunction : new

//--------------------------------------------------------------------------------------------
// Function : reg2bus
// Used for converting register sequences to apb bus transactions
//--------------------------------------------------------------------------------------------
function uvm_sequence_item apb_master_adapter::reg2bus( const ref uvm_reg_bus_op rw );
  apb_master_tx apb_tx
            = apb_master_tx::type_id::create("apb_master_tx");

  if ( rw.kind == UVM_READ )
  begin
    apb_tx.pwrite = READ;
  end
  else if ( rw.kind == UVM_WRITE ) 
  begin 
    apb_tx.pwrite = WRITE;
    apb_tx.pwdata = rw.data;
    apb_tx.pstrb  = 4'b1111; //4bytes 
  end

  apb_tx.paddr = rw.addr;

  // Assuming these address range falls in the slave0 domain
  // TODO(mshariff): Need to add more logic to be intelligent to pick correct pselx value
  apb_tx.pselx = SLAVE_0; 

  `uvm_info(get_type_name(), $sformatf("The converted reg2bus packet is %s\n",apb_tx.sprint()), UVM_HIGH);

  return apb_tx;
endfunction: reg2bus

//--------------------------------------------------------------------------------------------
// Function: bus2reg
// Used for converting apb bus transactions into register transactions
//--------------------------------------------------------------------------------------------
function void apb_master_adapter::bus2reg( uvm_sequence_item bus_item,
                                          ref uvm_reg_bus_op rw );
  // MSHA:jelly_bean_transaction jb_tx;
  apb_master_tx apb_tx; 

  if ( ! $cast( apb_tx, bus_item ) ) begin
     `uvm_fatal( get_name(),
                 "bus_item is not of the apb_master_tx type." )
     return;
  end

  // Assuming these address range falls in the slave0 domain
  // TODO(mshariff): Need to add more logic to be intelligent to pick correct pselx value
  apb_tx.pselx = SLAVE_0; 

  rw.kind = ( apb_tx.pwrite == READ ) ? UVM_READ : UVM_WRITE;
  rw.addr = apb_tx.paddr;
  rw.data = apb_tx.prdata;
  rw.status = UVM_IS_OK;

  `uvm_info(get_type_name(), $sformatf("The converted bus2reg packet is %s\n",apb_tx.sprint()), UVM_HIGH);

endfunction: bus2reg

`endif

