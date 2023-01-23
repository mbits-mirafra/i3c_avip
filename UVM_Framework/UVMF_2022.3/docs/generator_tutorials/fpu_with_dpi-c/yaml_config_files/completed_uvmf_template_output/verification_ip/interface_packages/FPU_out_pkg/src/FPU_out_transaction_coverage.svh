//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface Transaction Coverage
// File            : FPU_out_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records FPU_out transaction information using
//       a covergroup named FPU_out_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_out_transaction_coverage extends uvm_subscriber #(.T(FPU_out_transaction ));

  `uvm_component_utils( FPU_out_transaction_coverage )

  bit ine ;
  bit overflow ;
  bit underflow ;
  bit div_zero ;
  bit inf ;
  bit zero ;
  bit qnan ;
  bit snan ;

// ****************************************************************************
  // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
  covergroup FPU_out_transaction_cg;
    option.auto_bin_max=1024;
    option.per_instance=1;
    coverpoint ine;
    coverpoint overflow;
    coverpoint underflow;
    coverpoint div_zero;
    coverpoint inf;
    coverpoint zero;
    coverpoint qnan;
    coverpoint snan;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    FPU_out_transaction_cg=new;
    FPU_out_transaction_cg.set_inst_name($sformatf("FPU_out_transaction_cg_%s",get_full_name()));
 endfunction

 // ****************************************************************************
// FUNCTION : build_phase()
// This function is the standard UVM build_phase.
//
  function void build_phase(uvm_phase phase);
    FPU_out_transaction_cg.set_inst_name($sformatf("FPU_out_transaction_cg_%s",get_full_name()));
 endfunction

// ****************************************************************************
// FUNCTION: write (T t)
// This function is automatically executed when a transaction arrives on the
// analysis_export.  It copies values from the variables in the transaction 
// to local variables used to collect functional coverage.  
//
  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    ine = t.ine;
    overflow = t.overflow;
    underflow = t.underflow;
    div_zero = t.div_zero;
    inf = t.inf;
    zero = t.zero;
    qnan = t.qnan;
    snan = t.snan;
    FPU_out_transaction_cg.sample();
  endfunction

endclass
