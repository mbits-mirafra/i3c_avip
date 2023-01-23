//
// File: qvip_agents_pkg.sv
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to 
// ## the python configuration file used by the UVMF environment generator.
// env.addQvipSubEnv('sub_env_instance_name', 'qvip_agents', ['pcie_ep', 'axi4_master_0', 'axi4_master_1', 'axi4_slave', 'apb3_config_master'])
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated test bench.  The addQvipBfm function is added to 
// ## the python configuration file used by the UVMF bench generator.
// ben.addQvipBfm('pcie_ep', 'qvip_agents', 'ACTIVE')
// ben.addQvipBfm('axi4_master_0', 'qvip_agents', 'ACTIVE')
// ben.addQvipBfm('axi4_master_1', 'qvip_agents', 'ACTIVE')
// ben.addQvipBfm('axi4_slave', 'qvip_agents', 'ACTIVE')
// ben.addQvipBfm('apb3_config_master', 'qvip_agents', 'ACTIVE')
package qvip_agents_pkg;
    import uvm_pkg::*;
    
    `include "uvm_macros.svh"
    
    import addr_map_pkg::*;
    
    import uvmf_base_pkg::*;
    import qvip_agents_params_pkg::*;
    import mvc_pkg::*;
    import mgc_apb3_v1_0_pkg::*;
    import mgc_pcie_v2_0_pkg::*;
    import mgc_axi4_v1_0_pkg::*;
    
    `include "qvip_agents_env_configuration.svh"
    `include "qvip_agents_environment.svh"
endpackage: qvip_agents_pkg
