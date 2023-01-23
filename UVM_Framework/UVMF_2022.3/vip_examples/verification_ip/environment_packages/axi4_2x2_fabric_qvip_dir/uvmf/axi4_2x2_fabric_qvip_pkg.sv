//
// File: axi4_2x2_fabric_qvip_pkg.sv
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to 
// ## the python configuration file used by the UVMF environment generator.
// env.addQvipSubEnv('sub_env_instance_name', 'axi4_2x2_fabric_qvip', ['mgc_axi4_m0', 'mgc_axi4_m1', 'mgc_axi4_s0', 'mgc_axi4_s1'])
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated test bench.  The addQvipBfm function is added to 
// ## the python configuration file used by the UVMF bench generator.
// ben.addQvipBfm('mgc_axi4_m0', 'axi4_2x2_fabric_qvip', 'ACTIVE')
// ben.addQvipBfm('mgc_axi4_m1', 'axi4_2x2_fabric_qvip', 'ACTIVE')
// ben.addQvipBfm('mgc_axi4_s0', 'axi4_2x2_fabric_qvip', 'ACTIVE')
// ben.addQvipBfm('mgc_axi4_s1', 'axi4_2x2_fabric_qvip', 'ACTIVE')
package axi4_2x2_fabric_qvip_pkg;
    import uvm_pkg::*;
    
    `include "uvm_macros.svh"
    
    import addr_map_pkg::*;
    
    import uvmf_base_pkg::*;
    import axi4_2x2_fabric_qvip_params_pkg::*;
    import mvc_pkg::*;
    import mgc_axi4_v1_0_pkg::*;
    
    `include "axi4_2x2_fabric_qvip_env_configuration.svh"
    `include "axi4_2x2_fabric_qvip_environment.svh"
    `include "axi4_2x2_fabric_qvip_vseq_base.svh"
    `include "axi4_2x2_fabric_qvip_test_base.svh"
endpackage: axi4_2x2_fabric_qvip_pkg
