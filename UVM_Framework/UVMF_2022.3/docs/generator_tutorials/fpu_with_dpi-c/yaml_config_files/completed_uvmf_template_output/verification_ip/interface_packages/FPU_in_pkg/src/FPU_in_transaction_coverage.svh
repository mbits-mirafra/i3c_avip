//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface Transaction Coverage
// File            : FPU_in_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records FPU_in transaction information using
//       a covergroup named FPU_in_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_in_transaction_coverage  #(
      int FP_WIDTH = 32                                
      ) extends uvm_subscriber #(.T(FPU_in_transaction  #(
                                            .FP_WIDTH(FP_WIDTH)                                
                                            ) ));

  `uvm_component_param_utils( FPU_in_transaction_coverage #(
                              FP_WIDTH
                            ))

  fpu_op_t op ;
  fpu_rnd_t rmode ;
  bit [FP_WIDTH-1:0] a ;
  bit [FP_WIDTH-1:0] b ;
  bit [FP_WIDTH-1:0] result ;

// ****************************************************************************
  // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
  covergroup FPU_in_transaction_cg;
    option.auto_bin_max=1024;
    option.per_instance=1;
    coverpoint op;
    coverpoint rmode;
    coverpoint a;
    coverpoint b;
    coverpoint result;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    FPU_in_transaction_cg=new;
    FPU_in_transaction_cg.set_inst_name($sformatf("FPU_in_transaction_cg_%s",get_full_name()));
 endfunction

 // ****************************************************************************
// FUNCTION : build_phase()
// This function is the standard UVM build_phase.
//
  function void build_phase(uvm_phase phase);
    FPU_in_transaction_cg.set_inst_name($sformatf("FPU_in_transaction_cg_%s",get_full_name()));
 endfunction

// ****************************************************************************
// FUNCTION: write (T t)
// This function is automatically executed when a transaction arrives on the
// analysis_export.  It copies values from the variables in the transaction 
// to local variables used to collect functional coverage.  
//
  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    op = t.op;
    rmode = t.rmode;
    a = t.a;
    b = t.b;
    result = t.result;
    FPU_in_transaction_cg.sample();
  endfunction

endclass
