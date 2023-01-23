interface async_reset_bfm #(bit RESET_POLARITY = 1,
                            int INITIAL_IDLE_TIME_IN_PS = 1000,
                            int RESET_ACTIVE_TIME_IN_PS = 20000)
  (
   input bit    clock,
   output logic reset
  );
  // pragma attribute async_reset_bfm partition_interface_xif 
  
  timeunit 1ps;
  timeprecision 1ps;

  reset_pkg::reset_ctrl_base proxy;

  event         initiate_toggle;
  int unsigned  initial_idle_cycles = 0;
  int unsigned  reset_active_cycles = 10;

  bit async_reset, sync_reset;
  bit reset_mux_ctrl = 0;
  bit manual_control = 0;

  assign reset = (reset_mux_ctrl == 0) ? async_reset : sync_reset;

  /////////////////////////////////////////////////////////////////////////////
  //Asynchronous Reset Generation Logic
  /////////////////////////////////////////////////////////////////////////////
  //tbx clkgen
  initial begin
    async_reset = ~RESET_POLARITY;

    #(INITIAL_IDLE_TIME_IN_PS);
    async_reset = RESET_POLARITY;

    #(RESET_ACTIVE_TIME_IN_PS);
    async_reset = ~RESET_POLARITY;

    reset_mux_ctrl = 1;
  end

  // We can only generate an async reset at the beginning of simulation.
  // To enable additional resets during the rest fo the simulation, any 
  // additional resets will have to be synchronous.
  initial begin
    sync_reset = ~RESET_POLARITY;
    
    forever begin
      @initiate_toggle;
      @(posedge clock );

      if (!manual_control) repeat(initial_idle_cycles) @(posedge clock);
      sync_reset = RESET_POLARITY;

      if (manual_control) begin
        @initiate_toggle;
        @(posedge clock );
      end
      else begin
        repeat(reset_active_cycles) @(posedge clock);
      end
      sync_reset = ~RESET_POLARITY;
    end
  end

  always begin
    wait(reset == RESET_POLARITY);
    @(posedge clock );
    proxy.notify_reset_edge(1);
    wait(reset != RESET_POLARITY);
    @(posedge clock );
    proxy.notify_reset_edge(0);
  end
  
  /////////////////////////////////////////////////////////////////////////////
  //Reset Interaction Code
  /////////////////////////////////////////////////////////////////////////////

  function void toggle_reset(int idle_cycles = -1, int num_clks_active = -1); // pragma tbx xtf
    if (reset == RESET_POLARITY)
      $warning("Reset Active when %m.toggle_reset() called.  This invocation will be ignored.");
    else if (manual_control == 1)
      $warning("Manual control via (de)assert_reset() functions in middle of reset cycle.  This invocation will be ignored");
    else begin
      if (idle_cycles >= 0) initial_idle_cycles = idle_cycles;
      if (num_clks_active >= 0) reset_active_cycles = num_clks_active;
      -> initiate_toggle;
    end
  endfunction : toggle_reset

  function void assert_reset(); // pragma tbx xtf
    manual_control = 1;
    -> initiate_toggle;
  endfunction : assert_reset

  function void deassert_reset(); // pragma tbx xtf
    manual_control = 0;
    -> initiate_toggle;
  endfunction : deassert_reset

  function void configure(int idle_cycles = -1, int num_clks_active = -1); // pragma tbx xtf
    if (idle_cycles >= 0) initial_idle_cycles = idle_cycles;
    if (num_clks_active >= 0) reset_active_cycles = num_clks_active;
  endfunction : configure

  function void set_manual_control(bit mc); // pragma tbx xtf
    manual_control = mc;
  endfunction : set_manual_control

endinterface : async_reset_bfm
