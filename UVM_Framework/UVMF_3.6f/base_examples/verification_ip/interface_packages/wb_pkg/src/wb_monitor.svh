//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : jcraft
// Creation Date   : 2016 Nov 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : wb interface agent
// Unit            : Interface UVM monitor
// File            : wb_monitor.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives wb transactions observed by the
//     wb monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class wb_monitor  #(
      int WB_ADDR_WIDTH = 32,                                
      int WB_DATA_WIDTH = 16                                
      ) extends uvmf_monitor_base #(
                    .CONFIG_T(wb_configuration  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ),
                    .BFM_BIND_T(virtual wb_monitor_bfm  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ),
                    .TRANS_T(wb_transaction  #(
                             .WB_ADDR_WIDTH(WB_ADDR_WIDTH),                                
                             .WB_DATA_WIDTH(WB_DATA_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( wb_monitor #(
                              WB_ADDR_WIDTH,
                              WB_DATA_WIDTH
                            ))

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(

          cfg.active_passive,
          cfg.initiator_responder
);                    
   
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;
   endfunction

 // ****************************************************************************              
  virtual task run_phase(uvm_phase phase);                                                   
  // Start monitor BFM thread and don't call super.run() in order to                       
  // override the default monitor proxy 'pull' behavior with the more                      
  // emulation-friendly BFM 'push' approach using the notify_transaction                   
  // function below                                                                        
  bfm.start_monitoring();                                                   
  endtask                                                                                    
  
  // ****************************************************************************              
  virtual function void notify_transaction(
                        input wb_op_t op,  
                        input bit [WB_DATA_WIDTH-1:0] data,  
                        input bit [WB_ADDR_WIDTH-1:0] addr,  
                        input bit [(WB_DATA_WIDTH/8)-1:0] byte_select 
                        );
    trans = new("trans");                                                                   
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;                                                            
    trans.op = op;
    trans.data = data;
    trans.addr = addr;
    trans.byte_select = byte_select;
    analyze(trans);                                                                         
  endfunction  

endclass
