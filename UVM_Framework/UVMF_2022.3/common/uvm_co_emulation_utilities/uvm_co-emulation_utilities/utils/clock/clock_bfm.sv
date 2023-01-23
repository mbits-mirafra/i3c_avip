interface clock_bfm #(int unsigned INIT_CLOCK_HALF_PERIOD = 2000,
                      int unsigned PHASE_OFFSET_IN_PS = INIT_CLOCK_HALF_PERIOD)
  (output logic clock);
  // pragma attribute clock_bfm partition_interface_xif
  
  timeunit 1ps;
  timeprecision 1ps;

  bit                internal_clock = 0;
  bit                clock_enable = 1;
  //int unsigned     half_period_in_ps = 2000;
  int unsigned       half_period_in_ps = INIT_CLOCK_HALF_PERIOD;


  /////////////////////////////////////////////////////////////////////////////
  //Clock Generation Logic
  /////////////////////////////////////////////////////////////////////////////
  /* Note: Optimizations can be applied to remove negative edges and/or positive
           edges when looking at performance. */
  //tbx clkgen
  initial begin
    internal_clock = 0;
    #(PHASE_OFFSET_IN_PS);  //Can not be a variable and can not be 0
    forever #(half_period_in_ps) internal_clock = ~internal_clock;
  end
  
  assign clock = internal_clock & clock_enable;


  /////////////////////////////////////////////////////////////////////////////
  //Clock Adjustment Code
  /////////////////////////////////////////////////////////////////////////////
  event        update_clk_hp, update_clk_en;
  int          clk_num;
  bit [63:0]   hp;
  bit          en;  
  

  function void update_half_period_in_ps(int unsigned half_period); // pragma tbx xtf
    if (half_period > 0) begin
      hp = half_period;
      -> update_clk_hp;
    end
  endfunction : update_half_period_in_ps
  
  // update frequency of non gated clock/reset
  always begin
    @(update_clk_hp);
    @(posedge internal_clock);

    half_period_in_ps <= hp;
    proxy.half_period_updated(hp);
  end

  function int unsigned get_half_period_in_ps(); // pragma tbx xtf
    return half_period_in_ps;
  endfunction : get_half_period_in_ps

  function int unsigned get_phase_offset_in_ps(); // pragma tbx xtf
    return PHASE_OFFSET_IN_PS;
  endfunction : get_phase_offset_in_ps
  
  function void update_clock_enable(bit enable); // pragma tbx xtf
    en = enable;

    $display("enable: %0d", enable);
    -> update_clk_en;
  endfunction : update_clock_enable
  
  // update clk enable of clock
  always begin
    @(update_clk_en);
    @(posedge internal_clock);

    clock_enable <= en;
  end 
  

  /////////////////////////////////////////////////////////////////////////////
  //Clock Interaction Code
  /////////////////////////////////////////////////////////////////////////////

  reg [63:0] cycleCount = 0, numClocks = 0;
  event      initiateAdvance;
  clock_pkg::clock_ctrl#(INIT_CLOCK_HALF_PERIOD, PHASE_OFFSET_IN_PS) proxy;
  
  function void advance_clocks( int unsigned numClocksArg = 1 ); // pragma tbx xtf
    numClocks = numClocksArg;
    cycleCount = 1;
    ->initiateAdvance;
  endfunction : advance_clocks


  //======================================================================
  // Clock Advancer FSM

  always begin
    @initiateAdvance;
    @( posedge internal_clock );
    
    forever begin
      if( cycleCount == numClocks ) begin
        proxy.advance_finished();
        break;
      end
      else cycleCount = cycleCount + 1;
      @( posedge internal_clock );
    end
  end
  
  
endinterface : clock_bfm