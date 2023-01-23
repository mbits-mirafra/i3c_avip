USE_VELOCE=0

CCFLAGS_0 = -DQUESTA
CCFLAGS_1 = -I${VELOCE_HOME}/runtime/include
CCFLAGS   = $(CCFLAGS_$(USE_VELOCE))

#velcomp creates the tbxbindings.h that is needed in Veloce mode
build:
	vlib work
	vlog memload_pkg.sv memload.cc -dpiheader dpiheader.h -ccflags "-FPIC -I${MTI_HOME}/include $(CCFLAGS)"

clean:
	rm -rf work comp.log sim.log opt.log visualizer.log .visualizer* .qwave* *.wlf qwave.db design.bin visualizerCore.ses *.vstf certe_dump.xml veloce.log veloce.map veloce.med veloce.wave dpiheader.h
	find .. -name "*~" -delete
