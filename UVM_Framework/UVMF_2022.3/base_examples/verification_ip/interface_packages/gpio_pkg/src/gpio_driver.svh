//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM 
//        through the bfm handle. This driver
//        passes transactions to the driver BFM through the access
//        task.  
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class gpio_driver  #(
      int READ_PORT_WIDTH = 4,
      int WRITE_PORT_WIDTH = 4
      ) extends uvmf_driver_base #(
                   .CONFIG_T(gpio_configuration  #(
                             .READ_PORT_WIDTH(READ_PORT_WIDTH),
                             .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                             ) ),
                   .BFM_BIND_T(virtual gpio_driver_bfm  #(
                             .READ_PORT_WIDTH(READ_PORT_WIDTH),
                             .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                             ) ),
                   .REQ(gpio_transaction  #(
                             .READ_PORT_WIDTH(READ_PORT_WIDTH),
                             .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                             ) ),
                   .RSP(gpio_transaction  #(
                             .READ_PORT_WIDTH(READ_PORT_WIDTH),
                             .WRITE_PORT_WIDTH(WRITE_PORT_WIDTH)
                             ) ));

  `uvm_component_param_utils( gpio_driver #(
                              READ_PORT_WIDTH,
                              WRITE_PORT_WIDTH
                              ))
//*******************************************************************
// Macros that define structs located in gpio_macros.svh
//*******************************************************************
// Initiator macro used by gpio_driver and gpio_driver_bfm
// to communicate initiator driven data to gpio_driver_bfm.           
`gpio_INITIATOR_STRUCT
  gpio_initiator_s gpio_initiator_struct;
//*******************************************************************
// Responder macro used by gpio_driver and gpio_driver_bfm
// to communicate Responder driven data to gpio_driver_bfm.
`gpio_RESPONDER_STRUCT
  gpio_responder_s gpio_responder_struct;

// pragma uvmf custom class_item_additional begin
   protected REQ read_port_txn; // HANS: BZ 73776
// ****************************************************************************
   virtual function void notify_read_port_change(input bit [READ_PORT_WIDTH-1:0] data);
      this.read_port_txn.read_port = data;    // Place read port value into transaction
      -> this.read_port_txn.read_port_change; // Signal sequence of read port change
   endfunction
// pragma uvmf custom class_item_additional end

// ****************************************************************************
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// This function sends configuration object variables to the driver BFM 
// using the configuration struct.
//
  virtual function void configure(input CONFIG_T cfg);
      bfm.configure( cfg.to_struct() );
  endfunction

// ****************************************************************************
// This function places a handle to this class in the proxy variable in the
// driver BFM.  This allows the driver BFM to call tasks and function within this class.
//
  virtual function void set_bfm_proxy_handle();
    bfm.proxy = this;  endfunction

// **************************************************************************** 
// This task is called by the run_phase in uvmf_driver_base.              
  virtual task access( inout REQ txn );
// pragma uvmf custom access begin
      if ( txn.op == GPIO_WR ) begin
         bfm.write(txn.write_port);
      end
      else if ( txn.op == GPIO_RD ) begin
         // A GPIO_RD comes into this task typically just once to kick off
         // an autonomous read port monitoring process, which then continuously
         // provides read port change notifications that are relayed to upper
         // layer sequences.
         // This is implemented here by having a class member transaction object
         // handle point to the same object as the task inout argument txn.
         // Any read port change notification is then indicated via this shared
         // object using the notify_read_port_change function below, called from
         // the GPIO driver BFM via the 'proxy' backpointer set above.
         this.read_port_txn = txn;
         bfm.start_read_daemon();
      end
// pragma uvmf custom access end
  endtask

endclass
