# Machine Architecture - based on presence of Questa standard env var MTI_VCO_MODE unless
# manually set by user.
ifeq ($(MTI_VCO_MODE),64)
  MACHINE_ARCH ?= -64
else
  MACHINE_ARCH ?= -32
endif

UVMC_VER              ?= 2.3.2
UVM_VER               ?= 1.1d
EXTRA_UVMC_VLOG_ARGS  ?=
EXTRA_SCCOM_ARGS      ?= -Wall -g
EXTRA_SCCOM_LINK_ARGS ?= -g -O0

UVMC_HOME ?= $(QUESTA_HOME)/verilog_src/uvmc-$(UVMC_VER)
UVM_HOME ?= $(QUESTA_HOME)/verilog_src/uvm-$(UVM_VER)

XINCDIRS  = +incdir+$(UVM_HOME)/src
XINCDIRS += +incdir+$(UVMC_HOME)/src/connect/sv
UVMCONNECT_VLOG = $(UVMC_HOME)/src/connect/sv/uvmc_pkg.sv

DINCDIRS  = -I$(UVMC_HOME)/src/connect/sc
UVMCONNECT_CPP = $(UVMC_HOME)/src/connect/sc/uvmc.cpp

compile_uvmc:
	-@echo "Compiling UVMConnect library for platform $(MACHINE_ARCH)"
	vlog   -incr $(EXTRA_UVMC_VLOG_ARGS) $(XINCDIRS) $(UVMCONNECT_VLOG)
	sccom $(MACHINE_ARCH) $(DINCDIRS) $(EXTRA_SCCOM_ARGS) $(UVMCONNECT_CPP)
	sccom $(MACHINE_ARCH) $(DINCDIRS) -DSC_INCLUDE_DYNAMIC_PROCESSES $(EXTRA_SCCOM_LINK_ARGS) -linkshared

