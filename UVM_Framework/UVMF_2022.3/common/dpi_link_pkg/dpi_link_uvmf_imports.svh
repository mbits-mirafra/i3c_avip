   // Driver DPI Calls
   import "DPI-C" context function void C_configure( string path, input c_bit_array_t );
   import "DPI-C" context function void C_do_response_ready( string path, input   c_bit_array_t );
   import "DPI-C" context task          C_access(string path,  inout c_bit_array_t );
   import "DPI-C" context task          C_response(string path,  inout   c_bit_array_t );

   // Monitor DPI Calls
   import "DPI-C" context function void C_start_monitoring( string path );
   import "DPI-C" context task          C_wait_for_reset(string path);
   import "DPI-C" context task          C_wait_for_num_clocks(string path,  input c_bit_array_t );
   import "DPI-C" context function void C_initialize_monitor(string path);

