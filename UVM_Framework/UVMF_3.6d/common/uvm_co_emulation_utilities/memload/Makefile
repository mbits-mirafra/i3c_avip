# Package make targets
CCFLAGS_0 = -DQUESTA
CCFLAGS_1 = -I${VMW_HOME}/runtime/include
CCFLAGS   = $(CCFLAGS_$(USE_VELOCE))

#velcomp creates the tbxbindings.h that is needed in Veloce mode
comp_co_emulation_memload_pkg:
	vlog $(UVMF_HOME)/common/uvm_co_emulation_utilities/memload/memload_pkg.sv $(UVMF_HOME)/common/uvm_co_emulation_utilities/memload/src/memload.cc -dpiheader dpiheader.h -ccflags "-FPIC -I${MTI_HOME}/include $(CCFLAGS)"