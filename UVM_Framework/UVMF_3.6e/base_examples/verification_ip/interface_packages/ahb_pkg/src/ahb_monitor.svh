//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface UVM monitor
// File            : ahb_monitor.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives ahb transactions observed by the
//     ahb monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class ahb_monitor extends uvmf_monitor_base #(
                    .CONFIG_T(ahb_configuration),
                    .BFM_BIND_T(virtual ahb_monitor_bfm),
                    .TRANS_T(ahb_transaction)
                    );

  `uvm_component_utils( ahb_monitor )

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
          cfg.master_slave
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
                                            input ahb_op_t op,
                                            input bit [15:0] data,
                                            input bit [31:0] addr                              );
    trans = new("trans");                                                                   
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;                                                            
    trans.op = op;
    trans.data = data;
    trans.addr = addr;
    analyze(trans);                                                                         
  endfunction  

endclass
