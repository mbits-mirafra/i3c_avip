//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Sep 15
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : ahb interface agent
// Unit            : Interface Driver BFM
// File            : ahb_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the ahb signal driving.  It is
//     accessed by the uvm ahb driver through a virtual interface
//     handle in the ahb configuration.  It drives the singals passed
//     in through the port connection named bus of type ahb_if.
//
//     Input signals from the ahb_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within ahb_if based on MASTER/SLAVE and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:                                
//             configure(uvmf_master_slave_t mst_slv);                                       
//                   This function gets configuration attributes from the                    
//                   UVM driver to set any required BFM configuration                        
//                   variables such as 'master_slave'.                                       
//                                                                                           
//             assert_resetn();                                                             
//                   This task performs a reset operation on the bus.                    
//                                                                                           
//             access(
//       event read_complete,
//       ahb_op_t op,
//       bit [15:0] data,
//       bit [31:0] addr );//                   );
//                   This task receives transaction attributes from the                      
//                   UVM driver and then executes the corresponding                          
//                   bus operation on the bus. 
//
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import ahb_pkg_hdl::*;

interface ahb_driver_bfm(ahb_if bus);
// pragma attribute ahb_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

  tri        hclk_i;
  tri        hresetn_i;

// Input signals
  tri         hready_i;
  tri       [15:0]  hrdata_i;
  tri       [1:0]  hresp_i;

// Output signals
  bit       [31:0]  haddr_o;
  bit       [15:0]  hwdata_o;
  bit       [1:0]  htrans_o;
  bit       [2:0]  hburst_o;
  bit       [2:0]  hsize_o;
  bit         hwrite_o;
  bit         hsel_o;

// Bi-directional signals
  

  assign     hclk_i    =   bus.hclk;
  assign     hresetn_i    =   bus.hresetn;
  assign     hready_i = bus.hready;
  assign     hrdata_i = bus.hrdata;
  assign     hresp_i = bus.hresp;

  assign bus.haddr = haddr_o;
  assign bus.hwdata = hwdata_o;
  assign bus.htrans = htrans_o;
  assign bus.hburst = hburst_o;
  assign bus.hsize = hsize_o;
  assign bus.hwrite = hwrite_o;
  assign bus.hsel = hsel_o;

//******************************************************************                         
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_master_slave_t   master_slave
); // pragma tbx xtf                   
   
   endfunction                                                                                                                                                                

// ****************************************************************************
   task do_write(input bit [31:0] addr, 
                 input bit [15:0] data);
      // Address Phase
          haddr_o <= addr;
          hwdata_o <= data;
          htrans_o <= 2'b10;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b1;
          hsel_o <= 1'b1;

      // Data Phase
      do @(posedge hclk_i) ; while ( hready_i == 1'b0 );
          haddr_o <= 'bx;
          hwdata_o <= 'bx;
          htrans_o <= 2'b00;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b0;
   endtask

// ****************************************************************************
   task do_read(input bit [31:0] addr, 
                output bit [15:0] data);
      // Address Phase
          haddr_o <= addr;
          htrans_o <= 2'b10;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b1;

      // Data Phase
      @(posedge hclk_i);
      do @(posedge hclk_i); while ( hready_i == 1'b0 );
          data = hrdata_i;
          haddr_o <= 'bx;
          hwdata_o <= 'bx;
          htrans_o <= 2'b00;
          hburst_o <= 3'b000;
          hsize_o <= 3'b000;
          hwrite_o <= 1'b0;
          hsel_o <= 1'b0;
   endtask

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the access
//   task as inputs.  Some of these may need to be changed to outputs based on
//   protocol needs.
//
  task access(
    input   ahb_op_t op,
    inout   bit [15:0] data,
    input   bit [31:0] addr );
  // pragma tbx xtf                    
  @(posedge hclk_i);                                                                     
  $display("ahb_driver_bfm: Inside access()");
      case (op)
        AHB_WRITE: do_write(addr, data);
        AHB_READ:  do_read(addr, data);
      endcase                                                  
  endtask                                                                                    
  
endinterface
