//
// File: scatter_gather_dma_qvip_test_pkg.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to 
// ## the python configuration file used by the UVMF environment generator.
// env.addQvipSubEnv('sub_env_instance_name', 'scatter_gather_dma_qvip', ['mgc_axi4_m0', 'mgc_axi4_s0'])
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated test bench.  The addQvipBfm function is added to 
// ## the python configuration file used by the UVMF bench generator.
// ben.addQvipBfm('mgc_axi4_m0', 'scatter_gather_dma_qvip', 'ACTIVE')
// ben.addQvipBfm('mgc_axi4_s0', 'scatter_gather_dma_qvip', 'ACTIVE')
package scatter_gather_dma_qvip_test_pkg;
    import uvm_pkg::*;
    
    `include "uvm_macros.svh"
    
    import addr_map_pkg::*;
    
    import uvmf_base_pkg::*;
    import scatter_gather_dma_qvip_params_pkg::*;
    import mvc_pkg::*;
    import mgc_axi4_v1_0_pkg::*;
    import scatter_gather_dma_qvip_pkg::*;
    
    `include "scatter_gather_dma_qvip_vseq_base.svh"
    `include "scatter_gather_dma_qvip_test_base.svh"
    
endpackage: scatter_gather_dma_qvip_test_pkg
