//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records alu_in transaction information using
//       a covergroup named alu_in_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class alu_in_transaction_coverage #(
      int ALU_IN_OP_WIDTH = 8
      ) extends uvm_subscriber #(.T(alu_in_transaction #(
                                            .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
                                            )));

  `uvm_component_param_utils( alu_in_transaction_coverage #(
                              ALU_IN_OP_WIDTH
                              ))

  T coverage_trans;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup alu_in_transaction_cg;
    // pragma uvmf custom covergroup begin
     option.auto_bin_max=1024;
     op: coverpoint coverage_trans.op;
     a:  coverpoint coverage_trans.a;
     b:  coverpoint coverage_trans.b;
     op_x_a_x_b: cross op, a, b;


    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    alu_in_transaction_cg=new;
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    alu_in_transaction_cg.set_inst_name($sformatf("alu_in_transaction_cg_%s",get_full_name()));
  endfunction

  // ****************************************************************************
  // FUNCTION: write (T t)
  // This function is automatically executed when a transaction arrives on the
  // analysis_export.  It copies values from the variables in the transaction 
  // to local variables used to collect functional coverage.  
  //
  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    coverage_trans = t;
    alu_in_transaction_cg.sample();
  endfunction

endclass
