`ifndef I3C_SCOREBOARD_INCLUDED_
`define I3C_SCOREBOARD_INCLUDED_

class i3c_scoreboard extends uvm_component;
 `uvm_component_utils(i3c_scoreboard)

  i3c_controller_tx i3c_controller_tx_h;

  i3c_target_tx i3c_target_tx_h;
  
  i3c_env_config i3c_env_cfg_h;

  uvm_tlm_analysis_fifo#(i3c_controller_tx)controller_analysis_fifo;

  uvm_tlm_analysis_fifo#(i3c_target_tx)target_analysis_fifo;

  int i3c_controller_tx_count = 0;
  int i3c_target_tx_count = 0;

  extern function new(string name = "i3c_scoreboard", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void check_phase (uvm_phase phase);
endclass : i3c_scoreboard

function i3c_scoreboard::new(string name = "i3c_scoreboard",
                                 uvm_component parent = null);
  super.new(name, parent);
  controller_analysis_fifo=new("controller_analysis_fifo",this);
  target_analysis_fifo=new("target_analysis_fifo",this);
endfunction : new

function void i3c_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void i3c_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

task i3c_scoreboard::run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
 `uvm_info(get_type_name(),$sformatf("before calling controller's analysis fifo get method"),UVM_HIGH)
 controller_analysis_fifo.get(i3c_controller_tx_h);
  i3c_controller_tx_count++;

  `uvm_info(get_type_name(),$sformatf("after calling controller's analysis fifo get method"),UVM_HIGH) 
  `uvm_info(get_type_name(),$sformatf("printing i3c_controller_tx_h, \n %s",i3c_controller_tx_h.sprint()),UVM_HIGH)

 `uvm_info(get_type_name(),$sformatf("before calling target analysis fifo get method"),UVM_HIGH)
  target_analysis_fifo.get(i3c_target_tx_h);
  i3c_target_tx_count++;

  `uvm_info(get_type_name(),$sformatf("after calling target's analysis fifo get method"),UVM_HIGH)
  `uvm_info(get_type_name(),$sformatf("printing i3c_target_tx_h, \n %s",i3c_target_tx_h.sprint()),UVM_HIGH)
 
  `uvm_info(get_type_name(),$sformatf("--\n------SCOREBOARD COMPARISIONS-----"),UVM_HIGH)
  if(i3c_controller_tx_h.targetAddress == i3c_target_tx_h.targetAddress) begin
   `uvm_info(get_type_name(),$sformatf("i3c_targetAddress from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_TARGETADDRESS_MATCHED", $sformatf("Controller targetAddress = %d and Target targetAddress = %d",i3c_controller_tx_h.targetAddress, i3c_target_tx_h.targetAddress),UVM_HIGH);
 end
 else begin
   `uvm_info(get_type_name(),$sformatf("i3c_targetAddress from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_TARGETADDRESS_MISMATCHED", $sformatf("Controller targetAddress = %d and Target targetAddress = %d",i3c_controller_tx_h.targetAddress, i3c_target_tx_h.targetAddress),UVM_HIGH);
 end
 
  if(i3c_controller_tx_h.operation == i3c_target_tx_h.operation) begin
  `uvm_info(get_type_name(),$sformatf("i3c_operation from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_OPERATION_MATCHED", $sformatf("Controller OPERATION = %s and Target OPERATION = %s",i3c_controller_tx_h.operation, i3c_target_tx_h.operation), UVM_HIGH);
end
 else begin
  `uvm_info(get_type_name(), $sformatf("i3c_operation from controller and target is Not equal"),UVM_HIGH);
   `uvm_info("SB_OPERATION_MISMATCHED", $sformatf("Controller OPERATION = %s, and Target OPERATION =%s",i3c_controller_tx_h.operation,i3c_target_tx_h.operation), UVM_HIGH);
 end

 if(i3c_controller_tx_h.operation == 0) begin
  if(i3c_controller_tx_h.writeData[0] == i3c_target_tx_h.writeData[0]) begin
   `uvm_info(get_type_name(),$sformatf("i3c_writeData from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_WRITEDATA_MATCHED", $sformatf("Controller writeData = %0b and Target writeData = %0b",i3c_controller_tx_h.writeData, i3c_target_tx_h.writeData), UVM_HIGH);
 end
 else begin
   `uvm_info(get_type_name(),$sformatf("i3c_writeData from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_WRITEDATA_MISMATCHED", $sformatf("Controller writeData = %0b and Target writeData = %0b",i3c_controller_tx_h.writeData, i3c_target_tx_h.writeData), UVM_HIGH); 
 end
 end
 else begin
  if(i3c_controller_tx_h.readData[0] == i3c_target_tx_h.readData[0]) begin
   `uvm_info(get_type_name(),$sformatf("i3c_readData from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_READDATA_MATCHED", $sformatf("Controller readData = %0b and Target readData = %0b",i3c_controller_tx_h.readData, i3c_target_tx_h.readData), UVM_HIGH);
 end
 else begin
   `uvm_info(get_type_name(),$sformatf("i3c_readData from controller and target is equal"),UVM_HIGH);
   `uvm_info("SB_READDATA_MISMATCHED", $sformatf("Controller readData = %0b and Target readData = %0b",i3c_controller_tx_h.readData, i3c_target_tx_h.readData), UVM_HIGH); 
 end
  end 

end
endtask : run_phase

function void i3c_scoreboard::check_phase(uvm_phase phase);
  super.check_phase(phase);
 `uvm_info(get_type_name(),$sformatf("--\n--------SCOREBOARD CHECK PHASE----------------"),UVM_HIGH) 
 `uvm_info(get_type_name(),$sformatf(" Scoreboard Check Phase is starting"),UVM_HIGH); 
  if (i3c_controller_tx_count == i3c_target_tx_count ) begin
  `uvm_info (get_type_name(), $sformatf ("controller and target have equal no. of transactions"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("i3c_controller_tx_count : %0d",i3c_controller_tx_count ),UVM_HIGH);
    `uvm_info (get_type_name(), $sformatf ("i3c_target_tx_count : %0d",i3c_target_tx_count),UVM_HIGH);
    `uvm_error ("SC_CheckPhase", $sformatf ("controller and target doesnot have same no.of transactions"));
  end 

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

