# Accelerated VIP for I3C Protocol
The idea of using Accelerated VIP is to push the synthesizable part of the testbench into the separate top module along with the interface and it is named as HDL TOP and the unsynthesizable part is pushed into the HVL TOP. This setup provides the ability to run the longer tests quickly. This particular testbench can be used for the simulation as well as the emulation based on mode of operation.


# Key Features of RTL 
1. It supports a two-wire serial interface up to 12.5 MHz.
2. Supports all MIPI I3C device types. 
3. Supports all topologies
4. Legacy I2C Device coexistence on the same bus.
5. Supports Dynamic Address Assignment(DAA) including static addressing for legacy I2C devices. 
6. 7-bit configurable Target Address
7. Supports I3C address arbitration.
8.Supports Single Data Rate(SDR) messaging

   
# Testbench Architecture Diagram
![image](https://github.com/mbits-mirafra/i3c_avip/assets/106074838/32227a76-6131-42aa-8a01-6db2b224aba1)


# Developers, Welcome
We believe in growing together and if you'd like to contribute, please do check out the contributing guide below:  
https://github.com/mbits-mirafra/i3c_avip/blob/production/contribution_guidelines.md

# Installation - Get the VIP collateral from the GitHub repository

```
# Checking for git software, open the terminal type the command
git version

# Get the VIP collateral
git clone git@github.com/mbits-mirafra/i3c_avip.git
```

# Running the test

### Using Mentor's Questasim simulator 

```
cd i3c_avip/sim/questasim

# Compilation:  
make compile

# Simulation:
make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>

ex: make simulate test=i3c_writeOperationWith8bitsData_test uvm_verbosity=UVM_HIGH

# Note: You can find all the test case names in the path given below
i3c_avip/src/hvl_top/testlists/i3c_standard_mode_regression.list 

# Wavefrom:  
vsim -view <test_name>/waveform.wlf &

ex: vsim -view i3c_writeOperationWith8bitsData_test/waveform.wlf &

# Regression:
make regression testlist_name=<regression_testlist_name.list>
ex: make regression testlist_name=i3c_standard_mode_regression.list

# Coverage: 
 ## Individual test:
 firefox <test_name>/html_cov_report/index.html &
 ex: firefox i3c_writeOperationWith8bitsData_test/html_cov_report/index.html &

 ## Regression:
 firefox merged_cov_html_report/index.html &

```

### Using Cadence's Xcelium simulator 

```
cd i3c_avip/sim/cadence_sim

# Compilation:  
make compile
ex: make simulate test=i3c_writeOperationWith8bitsData_test uvm_verbosity=UVM_HIGH

# Note: You can find all the test case names in the path given below   
i3c_avip/src/hvl_top/testlists/i3c_standard_mode_regression.list

# Wavefrom:  
simvision waves.shm/ &

# Regression:
make regression testlist_name=<regression_testlist_name.list>
ex: make regression testlist_name=i3c_standard_mode_regression.list

# Coverage:   
imc -load cov_work/scope/test/ &
```
## Technical Document 
https://docs.google.com/document/d/1UH9p83ARZM5K0v1wrA2lv7KpHbaGHC3u/

## Contact Mirafra Team  
You can reach out to us over mbits@mirafra.com

For more information regarding Mirafra Technologies please do checkout our officail website:  
https://mirafra.com/

# Document for protocol reference 
https://drive.google.com/file/d/1kavChSV3h3A9llmkulMV73k_sLxQnwYS/view?usp=sharing

# Refer to timing diagrams
https://github.com/mbits-mirafra/i3c_avip/blob/production/doc/I2CMasterwithWISHBONEBusInterface-Documentation.pdf

# Refer for electrical signal requirements
https://espace.cern.ch/CMS-MPA/SiteAssets/SitePages/Documents/I2C_bus_specifications_V2_0.pdf

# Good APIs examples
https://www.infineon.com/dgdl/Infineon-Component_I2C_V3.0-Software%20Module%20Datasheets-v03_05-EN.pdf?fileId=8ac78c8c7d0d8da4017d0e952b3f1fbe

# APIs for I2C sequences 
https://www.robot-electronics.co.uk/i2c-tutorial

# In the below link will tell about the I3C Project verification using the i2c dut
https://github.com/mbits-mirafra/pulpino__i2c_master__ip_verification
