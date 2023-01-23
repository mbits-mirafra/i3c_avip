aThe print_uvm_reg_acc_pkg.sv file contains code for generating a "reg_acc.f"
file for use with Questa, a "forcesetget_nets.sigs" file for use with Veloce
to preserve access to registers when using the UVM Register backdoor 
capability, and/or a "vis_regs.tcl" file for use with the Visualizer Register
Viewer.


"reg_acc.f" is provided to vopt with a -f switch:

vopt -f reg_acc.f ...


"forcesetget_nets.sigs" is used by adding 
"rtlc -forceset_nets_file forcesetget_nets.sigs" and 
"rtlc -get_nets_file forcesetget_nets.sigs" to your veloce.config

"vis_regs.tcl" is used with these steps:
1) Open Visualizer 
2) Execute "do vis_regs.tcl" at the Visualizer prompt
3) Go to View -> Register Viewer -> UVM Registers to open the reg window