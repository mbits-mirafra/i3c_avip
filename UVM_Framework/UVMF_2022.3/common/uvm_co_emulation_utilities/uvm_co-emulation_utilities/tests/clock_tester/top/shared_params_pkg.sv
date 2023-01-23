package shared_params_pkg;

  parameter NUM_CLK_RSTS = 3;
  
  //parameters for clocks and resets
  parameter CLK_PHASE_OFFSET_IN_PS     = 1000; //Cannot be 0 according to Veloce
  parameter CLK_INIT_HALF_PERIOD_IN_PS = 1000; //Cannot be 0 according to Veloce
  parameter RST_POLARITY               = 0;
  parameter ASYNC_RST_POLARITY         = 1;
  parameter ASYNC_INIT_IDLE_TIME_IN_PS = 10000;
  parameter ASYNC_RST_ACTIVE_IN_PS     = 200000;

  parameter CLK_PERIOD = 4000;
  
endpackage : shared_params_pkg
  