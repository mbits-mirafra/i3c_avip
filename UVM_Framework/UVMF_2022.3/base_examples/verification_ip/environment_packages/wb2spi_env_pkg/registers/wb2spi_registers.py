#! /usr/bin/env python

from reg_gen import Field,Block,Reg,Mem,Map

##handle                                reg name                                    width access                                              fields   name                               width offset access   
serial_peripheral_control_reg   =   Reg("serial_peripheral_control_reg",                8,"RW", hdl_path="spcr", has_coverage = True, fields=[Field("serial_peripheral_interrupt_enable",  1,    7,     "RW",  has_coverage=True ),                   #Serial Peripheral Interrupt Enable
                                                                                                                                              Field("serial_peripheral_enable",            1,    6,     "RW",  has_coverage=True ),                   #Serial Peripheral Enable
                                                                                                                                              Field("master_mode_select",                  1,    4,     "RW",  has_coverage=True ,    reset_val = 1), #Master Mode Select
                                                                                                                                              Field("clock_polarity",                      1,    3,     "RW",  has_coverage=True ),                   #Clock Polarity
                                                                                                                                              Field("clock_phase",                         1,    2,     "RW",  has_coverage=True ),                   #Clock Phase
                                                                                                                                              Field("spi_clock_rate_select",               2,    0,     "RW",  has_coverage=True )])                  #SPI Clock Rate Select
serial_peripheral_status_reg    =   Reg("serial_peripheral_status_reg",                 8,"RW", hdl_path="spsr", has_coverage = True, fields=[Field("serial_peripheral_interrupt_flag",    1,    7,     "W1C", has_coverage=True ),                  #Serial Peripheral Interrupt Flag
                                                                                                                                              Field("write_collision",                     1,    6,     "W1C", has_coverage=True ),                  #Write Collision
                                                                                                                                              Field("write_fifo_full",                     1,    3,     "RO",  has_coverage=True ),                   #Write FIFO Full
                                                                                                                                              Field("write_fifo_empty",                    1,    2,     "RO",  has_coverage=True ),                   #Write FIFO Empty
                                                                                                                                              Field("read_fifo_full",                      1,    1,     "RO",  has_coverage=True ),                   #Read FIFO Full
                                                                                                                                              Field("read_fifo_empty",                     1,    0,     "RO",  has_coverage=True )])                  #Read FIFO Empty
serial_peripheral_data_reg      =   Reg("serial_peripheral_data_reg",                   8,"RW")
serial_peripheral_extensions_reg =  Reg("serial_peripheral_extensions_reg",             8,"RW", hdl_path="sper", has_coverage = True, fields=[Field("interrupt_count",                     2,    6,     "RW",  has_coverage=True ),                   #Interrupt Count
                                                                                                                                              Field("extended_spi_clock_rate_sel",         2,    0,     "RW",  has_coverage=True )])                  #Extended SPI Clock Rate Select

## Create block 
wb2spi_reg_model = Block("wb2spi_reg_model", hdl_path="hdl_top.DUT",has_coverage = True)
## Add map to block
bus_map = wb2spi_reg_model.addMap("bus_map")
## Add registers to block and map.  Default is to name each instance as <name>_h unless
## specified explicitly.  The map can be "None" which means that no mapping to this
## sub-element will be applied at this time.  
wb2spi_reg_model.addBlockSub(serial_peripheral_control_reg,     bus_map, 0x0, inst_name = "spcr")
wb2spi_reg_model.addBlockSub(serial_peripheral_status_reg,      bus_map, 0x1, inst_name = "spsr")
wb2spi_reg_model.addBlockSub(serial_peripheral_data_reg,        bus_map, 0x2, inst_name = "spdr")
wb2spi_reg_model.addBlockSub(serial_peripheral_extensions_reg,  bus_map, 0x3, inst_name = "sper")

## This is required
wb2spi_reg_model.elaborate()
## This just produces STDOUT for info
wb2spi_reg_model.disp()
## This is what actually produces the file
wb2spi_reg_model.create(pkgname="wb2spi_reg_pkg",fname="wb2spi_reg_pkg.sv")


