//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface Transaction Coverage
// File            : apb_if_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records apb_if transaction information using
//       a covergroup named apb_if_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class apb_if_transaction_coverage  #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends uvm_subscriber #(.T(apb_if_transaction  #(
                                            .DATA_WIDTH(DATA_WIDTH),                                
                                            .ADDR_WIDTH(ADDR_WIDTH)                                
                                            ) ));

  `uvm_component_param_utils( apb_if_transaction_coverage #(
                              DATA_WIDTH,
                              ADDR_WIDTH
                            ))

  bit [DATA_WIDTH-1:0] prdata;
  bit [DATA_WIDTH-1:0] pwdata;
  bit [ADDR_WIDTH-1:0] paddr;
  bit [2:0] pprot;
  int pselx;

// ****************************************************************************
  // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
  covergroup apb_if_transaction_cg;
    option.auto_bin_max=1024;
    coverpoint prdata;
    coverpoint pwdata;
    coverpoint paddr;
    coverpoint pprot;
    coverpoint pselx;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    apb_if_transaction_cg=new;
    apb_if_transaction_cg.set_inst_name($sformatf("apb_if_transaction_cg_%s",get_full_name()));
 endfunction

// ****************************************************************************
// FUNCTION: write (T t)
// This function is automatically executed when a transaction arrives on the
// analysis_export.  It copies values from the variables in the transaction 
// to local variables used to collect functional coverage.  
//
  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    prdata = t.prdata;
    pwdata = t.pwdata;
    paddr = t.paddr;
    pprot = t.pprot;
    pselx = t.pselx;
    apb_if_transaction_cg.sample();
  endfunction

endclass
