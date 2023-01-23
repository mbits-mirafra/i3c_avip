//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface Transaction Coverage
// File            : ahb_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records ahb transaction information using
//       a covergroup named ahb_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class ahb_transaction_coverage extends uvm_subscriber #(.T(ahb_transaction));

  `uvm_component_utils( ahb_transaction_coverage )

  ahb_op_t op;
  bit [15:0] data;
  bit [31:0] addr;

// ****************************************************************************
  covergroup ahb_transaction_cg;
    option.auto_bin_max=1024;
     coverpoint op
     {
        bins ahb_read = {AHB_READ};
        bins ahb_write = {AHB_WRITE};
     }
     coverpoint data;
     coverpoint addr;
     op_x_addr: cross op, addr;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    ahb_transaction_cg=new;
    ahb_transaction_cg.set_inst_name($sformatf("ahb_transaction_cg_%s",get_full_name()));
 endfunction

// ****************************************************************************
// FUNCTION: write (T t)
// This function is automatically executed when a transaction arrives on the
// analysis_export.  It copies values from the variables in the transaction 
// to local variables used to collect functional coverage.  
//
  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    op = t.op;
    data = t.data;
    addr = t.addr;
    ahb_transaction_cg.sample();
  endfunction

endclass
