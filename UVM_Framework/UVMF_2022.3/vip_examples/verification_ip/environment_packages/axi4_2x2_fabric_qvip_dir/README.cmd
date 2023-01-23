This README is regarding the use of the .cmd file for regenerating 
the axi4_2x2_fabric_qvip environment using the qvip_configurator.

The .cmd file created by the qvip_configurator lists all commands 
used to create the environment.  This file references the Questa VIP 
release used when generating the environment.  For example, in the 
axi4_2x2_fabric_qvip_dir_2019.4.cmd file you will see the line:

"Configurator" create VIP_instance 2019.4/amba/axi4

Notice the 2019.4.  This references the release used when generating
this environment.   In order to use this .cmd file with qvip_configurator
in other releases, the 2019.4 must be changed to match the release that 
will be used.

For example, to use the .cmd file with 2020.2 release of qvip_configurator:

This line:
"Configurator" create VIP_instance 2019.4/amba/axi4

Will need to be changed to this:
"Configurator" create VIP_instance 2020.2/amba/axi4

This will need to be done for all lines referencing 2019.4
