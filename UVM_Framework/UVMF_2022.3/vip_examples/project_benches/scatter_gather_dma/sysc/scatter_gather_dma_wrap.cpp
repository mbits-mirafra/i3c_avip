
#include "scatter_gather_dma_wrap.h"

#ifdef ENABLE_TRACE_HIER
sc_trace_file* trace_file_ptr;
#endif

  void scatter_gather_dma_wrap::check_clock() { check_event.notify(2, SC_PS);} // Let SC and Vlog delta cycles settle.
  
  void scatter_gather_dma_wrap::check_event_method() {
    if (connections_clk.read() == clk.read()) return;
    CCS_LOG("clocks misaligned!:"  << connections_clk.read() << " " << clk.read());
  }

#ifdef MTI_SYSTEMC
  SC_MODULE_EXPORT(scatter_gather_dma_wrap);
#endif
