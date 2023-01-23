//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_out interface agent
// Unit            : Interface UVM monitor
// File            : FPU_out_monitor.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives FPU_out transactions observed by the
//     FPU_out monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_out_monitor extends uvmf_monitor_base #(
                    .CONFIG_T(FPU_out_configuration ),
                    .BFM_BIND_T(virtual FPU_out_monitor_bfm ),
                    .TRANS_T(FPU_out_transaction ));

  `uvm_component_utils( FPU_out_monitor )

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
      bfm.proxy = this;   endfunction

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
                        input bit ine ,  
                        input bit overflow ,  
                        input bit underflow ,  
                        input bit div_zero ,  
                        input bit inf ,  
                        input bit zero ,  
                        input bit qnan ,  
                        input bit snan  
                        );
    trans = new("trans");                                                                   
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;                                                            
    trans.ine = ine;
    trans.overflow = overflow;
    trans.underflow = underflow;
    trans.div_zero = div_zero;
    trans.inf = inf;
    trans.zero = zero;
    trans.qnan = qnan;
    trans.snan = snan;
    analyze(trans);                                                                         
  endfunction  

endclass
