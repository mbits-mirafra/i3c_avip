//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : spi interface agent
// Unit            : spi interface configuration
// File            : spi_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This class contains all variables and functions used
//      to configure the spi agent and its bfm's.  It makes the
//      bfm's available to the agent through the uvm_config_db.  The
//      configuration serves as a proxy to the tasks contained in the
//      bfm for the agent.  
//
//      Configuration utility function:
//             initialize:
//                   This function causes the configuration to retrieve
//                   its virtual interface handle from the uvm_config_db.
//                   This function also makes itself available to its
//                   agent through the uvm_config_db.
//
//                Arguments:
//                   uvmf_active_passive_t activity:
//                        This argument identifies the simulation level
//                        as either BLOCK, CHIP, SIMULATION, etc.
//
//                   agent_path:
//                        This argument identifies the path to this
//                        configurations agent.  This configuration
//                        makes itself available to the agent specified
//                        by agent_path by placing itself into the
//                        uvm_config_db.
//
//                   interface_name:
//                        This argument identifies the string name of
//                        this configuration's driver and monitor BFMs.
//                        This string name is used to retrieve these 
//                        BFMs from the uvm_config_db.
//
//             to_struct() / from_struct():
//                   These functions are conversion utilities between
//                   this class and a corresponding packed struct data
//                   representation, useful for co-emulation (see package
//                   spi_typedefs_hdl in file spi_typedefs_hdl.svh).
//
//----------------------------------------------------------------------
//
class spi_configuration  extends uvmf_parameterized_agent_configuration_base#(
   .DRIVER_BFM_BIND_T(virtual spi_driver_bfm),
   .MONITOR_BFM_BIND_T(virtual spi_monitor_bfm)
);

   `uvm_object_utils( spi_configuration )

// SPCR : Serial Peripheral Control Register
        bit       SPCR_SPIE = 0;     // Serial Peripheral Interrupt Enable
        bit       SPCR_SPE = 0;      // Serial Peripheral Enable
        bit       SPCR_RESERVED = 0; // Reserved field
        bit       SPCR_MSTR = 1;     // Master Mode Select
   rand bit       SPCR_CPOL = 0;     // Clock Polarity
   rand bit       SPCR_CPHA = 0;     // Clock Phase
   rand bit [1:0] SPCR_SPR = 0;      // SPI Clock Rate Select

// SPER : Serial Peripheral Extensions Register
        bit [1:0] SPER_ICNT = 0;     // Serial Peripheral Interrupt Count
        bit [3:0] SPER_RESERVED = 0; // Reserved field
   rand bit [1:0] SPER_ESPR = 0;     // Extended SPI Clock Rate Select

// ****************************************************************************
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
   virtual function void initialize(uvmf_active_passive_t activity,
                                         string agent_path,
                                         string interface_name);

   super.initialize( activity, agent_path, interface_name);

   uvm_config_db #( spi_configuration )::set( null ,agent_path,       UVMF_AGENT_CONFIG, this );
   uvm_config_db #( spi_configuration )::set( null ,UVMF_CONFIGURATIONS, interface_name, this );

   endfunction


// ****************************************************************************
   virtual task wait_for_reset();
      //Not implemented
   endtask

// ****************************************************************************
   virtual task wait_for_num_clocks(int clocks);
      monitor_bfm.wait_for_sck(clocks);
   endtask

// ****************************************************************************
   function spi_configuration_s to_struct();
     spi_configuration_s s;
     s.uvmf_cfg = super.to_struct();
     {s.SPCR_SPIE, s.SPCR_SPE, s.SPCR_MSTR, s.SPCR_CPOL, s.SPCR_CPHA, s.SPCR_SPR} =
        {this.SPCR_SPIE, this.SPCR_SPE, this.SPCR_MSTR, this.SPCR_CPOL, this.SPCR_CPHA, this.SPCR_SPR};
     {s.SPER_ESPR} = {this.SPER_ESPR};
     return s;
   endfunction
 
// ****************************************************************************
   function void from_struct(spi_configuration_s s);
     super.from_struct(s.uvmf_cfg);
     {this.SPCR_SPIE, this.SPCR_SPE, this.SPCR_MSTR, this.SPCR_CPOL, this.SPCR_CPHA, this.SPCR_SPR} =
        {s.SPCR_SPIE, s.SPCR_SPE, s.SPCR_MSTR, s.SPCR_CPOL, s.SPCR_CPHA, s.SPCR_SPR};
     {this.SPER_ESPR} = {s.SPER_ESPR};
   endfunction
endclass
