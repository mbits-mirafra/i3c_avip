`ifndef I3C_SCOREBOARD_EXPACTEDTARGETADDRESSNACK_INCLUDED_
`define I3C_SCOREBOARD_EXPACTEDTARGETADDRESSNACK_INCLUDED_

class i3c_scoreboard_expactedTargetAddressNACK extends i3c_scoreboard;
 `uvm_component_utils(i3c_scoreboard_expactedTargetAddressNACK)

  extern function new(string name = "i3c_scoreboard_expactedTargetAddressNACK", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void check_phase (uvm_phase phase);
endclass : i3c_scoreboard_expactedTargetAddressNACK


function i3c_scoreboard_expactedTargetAddressNACK::new(string name = "i3c_scoreboard_expactedTargetAddressNACK",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void i3c_scoreboard_expactedTargetAddressNACK::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void i3c_scoreboard_expactedTargetAddressNACK::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

task i3c_scoreboard_expactedTargetAddressNACK::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
endtask : run_phase

function void i3c_scoreboard_expactedTargetAddressNACK::check_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("--\n--------SCOREBOARD CHECK PHASE----------------"),UVM_HIGH) 
  `uvm_info(get_type_name(),$sformatf(" Scoreboard Check Phase is starting"),UVM_HIGH); 

  if (i3c_controller_tx_count == i3c_target_tx_count ) begin
    `uvm_info (get_type_name(), $sformatf ("controller and target have equal no. of transactions  = %0d",i3c_controller_tx_count),UVM_HIGH);
    `uvm_info (get_type_name(), $sformatf ("i3c_controller_tx_count : %0d",i3c_controller_tx_count ),UVM_HIGH);
    `uvm_info (get_type_name(), $sformatf ("i3c_target_tx_count : %0d",i3c_target_tx_count),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("i3c_controller_tx_count : %0d",i3c_controller_tx_count ),UVM_HIGH);
    `uvm_info (get_type_name(), $sformatf ("i3c_target_tx_count : %0d",i3c_target_tx_count),UVM_HIGH);
    `uvm_error ("SC_CheckPhase", $sformatf ("controller and target doesnot have same no.of transactions"));
  end 

  if(i3c_controller_tx_h.operation == WRITE) begin
    if((writeDataComparisonSuccessCount == 0) && (writeDataComparisonFailedCount == 0)) begin
      `uvm_info (get_type_name(), $sformatf ("controller And target writeData comparisions are equal = %0d",writeDataComparisonSuccessCount),UVM_HIGH);
    end
    else begin
      `uvm_info (get_type_name(), $sformatf ("writeDataComparisonSuccessCount : %0d",
                                              writeDataComparisonSuccessCount),UVM_HIGH);
      `uvm_info (get_type_name(), $sformatf ("writeDataComparisonFailedCount : %0d",
                                              writeDataComparisonFailedCount),UVM_HIGH);
      `uvm_error("SC_CheckPhase", $sformatf ("controller And target writeData comparisions Not equal"));
    end
  end
  else begin
    if((readDataComparisonSuccessCount == 0) && (readDataComparisonFailedCount == 0)) begin
      `uvm_info (get_type_name(), $sformatf ("controller And target readData comparisions are equal = %0d",readDataComparisonSuccessCount),UVM_HIGH);
    end                                      
    else begin
      `uvm_info (get_type_name(), $sformatf ("readDataComparisonSuccessCount : %0d",
                                             readDataComparisonSuccessCount),UVM_HIGH);
      `uvm_info (get_type_name(), $sformatf ("readDataComparisonFailedCount : %0d",
                                             readDataComparisonFailedCount),UVM_HIGH);
      `uvm_error("SC_CheckPhase", $sformatf ("controller And target readData comparisions Not equal"));
    end
  end
  `uvm_info (get_type_name(), $sformatf ("writeDataComparisonSuccessCount :%0d",
                                          writeDataComparisonSuccessCount),UVM_HIGH);
  `uvm_info (get_type_name(), $sformatf ("readDataComparisonSuccessCount :%0d",
                                          readDataComparisonSuccessCount),UVM_HIGH);
    
  if(controller_analysis_fifo.size() == 0)begin
    `uvm_info ("SC_CheckPhase", $sformatf ("I3c Controller analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("i3c Controller analysis_fifo:%0d",controller_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error ("SC_CheckPhase", $sformatf ("i3c Controller analysis FIFO is not empty"));
  end

  if(target_analysis_fifo.size() == 0)begin
    `uvm_info ("SC_CheckPhase", $sformatf ("I3c target analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("i3c target analysis_fifo:%0d",target_analysis_fifo.size() ),UVM_HIGH);
    `uvm_error ("SC_CheckPhase", $sformatf ("i3c target analysis FIFO is not empty"));
  end

  `uvm_info(get_type_name(),$sformatf("--\n-----END OF SCOREBOARD CHECK PHASE-------"),UVM_HIGH)
endfunction : check_phase

`endif

