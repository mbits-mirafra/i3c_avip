package memload_pkg;
  
  import "DPI-C" function void memLoad(input bit[128*8-1:0]  fname_in,
                                       input bit [128*8-1:0] path_in,
                                       input int             startAddr,
                                       input int             endAddr,
                                       input bit [3*8-1:0]   format_in);

endpackage : memload_pkg