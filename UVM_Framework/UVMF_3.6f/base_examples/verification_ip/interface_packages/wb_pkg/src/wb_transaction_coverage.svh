//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface Transaction Coverage
// File            : wb_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records wb transaction information using
//       a covergroup named wb_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class wb_transaction_coverage  #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends uvm_subscriber #(.T(wb_transaction  #(
                                            .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                                            .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                                            ) ));

  `uvm_component_param_utils( wb_transaction_coverage #(
                              WB_ADDR_WIDTH,
                              WB_DATA_WIDTH
                            ))

  wb_op_t op;
  bit [WB_DATA_WIDTH-1:0] data;
  bit [WB_ADDR_WIDTH-1:0] addr;
  bit [(WB_DATA_WIDTH/8)-1:0] byte_select;

// ****************************************************************************
  covergroup wb_transaction_cg;
    option.auto_bin_max=1024;
    coverpoint op;
    coverpoint data;
    coverpoint addr;
    coverpoint byte_select;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    wb_transaction_cg=new;
    wb_transaction_cg.set_inst_name($sformatf("wb_transaction_cg_%s",get_full_name()));
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
    byte_select = t.byte_select;
    wb_transaction_cg.sample();
  endfunction

endclass
