interface sync_reset_bfm #(bit RESET_POLARITY = 1,
                           int INITIAL_IDLE_CYCLES = 0,
                           int RESET_ACTIVE_CYCLES = 10)
  (
   input bit    clock,
   output logic reset
  );  
  // pragma attribute sync_reset_bfm partition_interface_xif
  
  timeunit 1ps;
  timeprecision 1ps;

  reset_pkg::reset_ctrl_base proxy;

  event         initiate_toggle;
  int unsigned  initial_idle_cycles = INITIAL_IDLE_CYCLES;
  int unsigned  reset_active_cycles = RESET_ACTIVE_CYCLES;

  /////////////////////////////////////////////////////////////////////////////
  //Synchronous Reset Generation Logic
  /////////////////////////////////////////////////////////////////////////////
  
  initial begin
    reset = ~RESET_POLARITY;
    //if (initial_idle_cycles == 0) @(posedge clock);
    @(posedge clock );
    
    forever begin
      repeat(initial_idle_cycles) @(posedge clock);
      reset = RESET_POLARITY;
      proxy.notify_reset_edge(1);

      repeat(reset_active_cycles) @(posedge clock);
      reset = ~RESET_POLARITY;
      proxy.notify_reset_edge(0);
      
      @initiate_toggle;
      @(posedge clock );
    end
  end

  /////////////////////////////////////////////////////////////////////////////
  //Reset Interaction Code
  /////////////////////////////////////////////////////////////////////////////

  function void toggle_reset(int idle_cycles = -1, int num_clks_active = -1); // pragma tbx xtf
    if (reset == RESET_POLARITY)
      $warning("Reset Active when %m.toggle_reset() called.  This invocation will be ignored.");
    else begin
      if (idle_cycles >= 0) initial_idle_cycles = idle_cycles;
      if (num_clks_active >= 0) reset_active_cycles = num_clks_active;
      -> initiate_toggle;
    end
  endfunction : toggle_reset

  function void configure(int idle_cycles = -1, int num_clks_active = -1); // pragma tbx xtf
    if (idle_cycles >= 0) initial_idle_cycles = idle_cycles;
    if (num_clks_active >= 0) reset_active_cycles = num_clks_active;
  endfunction : configure

endinterface : sync_reset_bfm
