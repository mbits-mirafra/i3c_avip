

this bench also provides ability to run HLS-ready SystemC model as the DUT.
All other options are supported including debug of SystemC DUT within Visualizer (2020.4)

1. set MGC_HOME env variable to a Catapult install, as shown below for WV network
export MGC_HOME /wv/hlsb/CATAPULT/10.6/PRODUCTION/aol/Mgc_home

2. add SCATTER_GATHER_DMA_RTL=0 as argument to make cli as shown here,
make clean cli SCATTER_GATHER_DMA_RTL=0 USE_VIS=1

3. then can run typical/normal commands as for example shown below, though have instantiated SystemC model as DUT!
make cli_run TEST_NAME=scatter_gather_dma_sg_test USE_VIS=1
make vis

