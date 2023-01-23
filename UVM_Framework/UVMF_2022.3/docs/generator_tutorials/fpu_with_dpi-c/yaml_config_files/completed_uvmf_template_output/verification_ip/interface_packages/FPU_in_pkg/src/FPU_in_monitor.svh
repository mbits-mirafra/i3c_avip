//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2018 Dec 07
// Created with uvmf_gen version 3.6h
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : FPU_in interface agent
// Unit            : Interface UVM monitor
// File            : FPU_in_monitor.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives FPU_in transactions observed by the
//     FPU_in monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class FPU_in_monitor  #(
      int FP_WIDTH = 32                                
      ) extends uvmf_monitor_base #(
                    .CONFIG_T(FPU_in_configuration  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ),
                    .BFM_BIND_T(virtual FPU_in_monitor_bfm  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ),
                    .TRANS_T(FPU_in_transaction  #(
                             .FP_WIDTH(FP_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( FPU_in_monitor #(
                              FP_WIDTH
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
                        input fpu_op_t op ,  
                        input fpu_rnd_t rmode ,  
                        input bit [FP_WIDTH-1:0] a ,  
                        input bit [FP_WIDTH-1:0] b ,  
                        input bit [FP_WIDTH-1:0] result  
                        );
    trans = new("trans");                                                                   
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;                                                            
    trans.op = op;
    trans.rmode = rmode;
    trans.a = a;
    trans.b = b;
    trans.result = result;
    analyze(trans);                                                                         
  endfunction  

endclass
