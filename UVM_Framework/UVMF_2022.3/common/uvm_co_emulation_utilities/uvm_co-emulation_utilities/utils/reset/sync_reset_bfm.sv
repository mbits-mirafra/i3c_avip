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
  bit           manual_control = 0;

  /////////////////////////////////////////////////////////////////////////////
  //Synchronous Reset Generation Logic
  /////////////////////////////////////////////////////////////////////////////
  
  initial begin
    reset = ~RESET_POLARITY;
    //if (initial_idle_cycles == 0) @(posedge clock);
    @(posedge clock );
    //Need to allow manual control from time 0
    if (manual_control) begin
      @initiate_toggle;
      @(posedge clock );
    end
    
    forever begin
      if (!manual_control) repeat(initial_idle_cycles) @(posedge clock);
      reset = RESET_POLARITY;
      proxy.notify_reset_edge(1);

      if (manual_control) begin
        @initiate_toggle;
        @(posedge clock );
      end
      else begin
        repeat(reset_active_cycles) @(posedge clock);
      end
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
    
endinterface : sync_reset_bfm
