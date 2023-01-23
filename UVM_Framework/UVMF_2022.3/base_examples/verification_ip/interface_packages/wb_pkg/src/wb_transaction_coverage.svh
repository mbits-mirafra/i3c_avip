//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records wb transaction information using
//       a covergroup named wb_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class wb_transaction_coverage #(
      int WB_ADDR_WIDTH = 32,
      int WB_DATA_WIDTH = 16
      ) extends uvm_subscriber #(.T(wb_transaction #(
                                            .WB_ADDR_WIDTH(WB_ADDR_WIDTH),
                                            .WB_DATA_WIDTH(WB_DATA_WIDTH)
                                            )));

  `uvm_component_param_utils( wb_transaction_coverage #(
                              WB_ADDR_WIDTH,
                              WB_DATA_WIDTH
                              ))

  T coverage_trans;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup wb_transaction_cg;
    // pragma uvmf custom covergroup begin
    // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
    option.auto_bin_max=1024;
    option.per_instance=1;
    op: coverpoint coverage_trans.op;
    data: coverpoint coverage_trans.data;
    addr: coverpoint coverage_trans.addr;
    byte_select: coverpoint coverage_trans.byte_select;





    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    wb_transaction_cg=new;
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    wb_transaction_cg.set_inst_name($sformatf("wb_transaction_cg_%s",get_full_name()));
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
    wb_transaction_cg.sample();
  endfunction

endclass
