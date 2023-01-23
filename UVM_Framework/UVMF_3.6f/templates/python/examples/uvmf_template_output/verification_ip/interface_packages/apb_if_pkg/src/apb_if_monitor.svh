//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : shwetapatil
// Creation Date   : 2022 Jun 06
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : apb_if interface agent
// Unit            : Interface UVM monitor
// File            : apb_if_monitor.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives apb_if transactions observed by the
//     apb_if monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class apb_if_monitor  #(
      int DATA_WIDTH = 32,                                
      int ADDR_WIDTH = 32                                
      ) extends uvmf_monitor_base #(
                    .CONFIG_T(apb_if_configuration  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ),
                    .BFM_BIND_T(virtual apb_if_monitor_bfm  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ),
                    .TRANS_T(apb_if_transaction  #(
                             .DATA_WIDTH(DATA_WIDTH),                                
                             .ADDR_WIDTH(ADDR_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( apb_if_monitor #(
                              DATA_WIDTH,
                              ADDR_WIDTH
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
          ,cfg.transfer_size
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
                        input bit [DATA_WIDTH-1:0] prdata,  
                        input bit [DATA_WIDTH-1:0] pwdata,  
                        input bit [ADDR_WIDTH-1:0] paddr,  
                        input bit [2:0] pprot,  
                        input int pselx 
                        );
    trans = new("trans");                                                                   
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;                                                            
    trans.prdata = prdata;
    trans.pwdata = pwdata;
    trans.paddr = paddr;
    trans.pprot = pprot;
    trans.pselx = pselx;
    analyze(trans);                                                                         
  endfunction  

endclass
