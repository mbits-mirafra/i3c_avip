//----------------------------------------------------------------------
// Created with uvmf_gen version 2021.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records ccs transaction information using
//       a covergroup named ccs_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class ccs_transaction_coverage #(
      int WIDTH = 32
      ) extends uvm_subscriber #(.T(ccs_transaction #(
                                            .WIDTH(WIDTH)
                                            )));

  `uvm_component_param_utils( ccs_transaction_coverage #(
                              WIDTH
                              ))

  T coverage_trans;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup ccs_transaction_cg;
    // pragma uvmf custom covergroup begin
    // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
    option.auto_bin_max=1024;
    option.per_instance=1;
    rtl_data: coverpoint coverage_trans.rtl_data;
    wait_cycles: coverpoint coverage_trans.wait_cycles;
    iteration_count: coverpoint coverage_trans.iteration_count;
    empty: coverpoint coverage_trans.empty;
    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    ccs_transaction_cg=new;
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    ccs_transaction_cg.set_inst_name($sformatf("ccs_transaction_cg_%s",get_full_name()));
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
    ccs_transaction_cg.sample();
  endfunction

endclass
