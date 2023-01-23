class clock_ctrl #(int unsigned INIT_CLOCK_HALF_PERIOD = 2000,
                   int unsigned PHASE_OFFSET_IN_PS = INIT_CLOCK_HALF_PERIOD)
  extends clock_ctrl_base;

  `uvm_object_param_utils(clock_ctrl #(INIT_CLOCK_HALF_PERIOD,
                                       PHASE_OFFSET_IN_PS))

  //bfm is local because we must set the proxy handle for proper operation
  local virtual clock_bfm #(INIT_CLOCK_HALF_PERIOD, PHASE_OFFSET_IN_PS) bfm;

  local bit                       advance_in_progress = 0;
  local int unsigned              dClockPeriodInPs = INIT_CLOCK_HALF_PERIOD * 2;
  local int unsigned              dPhaseOffsetInPs;
  local int unsigned              dStartUpTimeInPs;
  local XlSvQueue #(XlSvTimeSync) dTimeQueue;
  local event                     clock_advance_finished;

  function new(string name = "clock_ctrl");
    super.new(name);
    report_id = name;
    dTimeQueue = new();

    fork advanceNotificationThread(); join_none
  endfunction : new

  /////////////////////////////////////////////////////////////////////////////
  //BFM Accessors Code
  /////////////////////////////////////////////////////////////////////////////
  
  function void set_bfm(virtual clock_bfm #(INIT_CLOCK_HALF_PERIOD, PHASE_OFFSET_IN_PS) cbfm);
    bfm = cbfm;
    bfm.proxy = this;
  endfunction : set_bfm;

  function virtual clock_bfm #(INIT_CLOCK_HALF_PERIOD, PHASE_OFFSET_IN_PS) get_bfm();
    return bfm;
  endfunction : get_bfm

  /////////////////////////////////////////////////////////////////////////////
  //Clock Adjustment Code
  /////////////////////////////////////////////////////////////////////////////
  
  virtual function void update_half_period_in_ps (int unsigned half_period);
    if (!dTimeQueue.isEmpty())
      `uvm_error(report_id, "Changing the clock period while threads are advancing time can cause unpredictible behavior.")
    bfm.update_half_period_in_ps(half_period);
    //dClockPeriodInPs = half_period*2;
  endfunction : update_half_period_in_ps
  /*Note: Can also specify clock high time and clock low time as seperate
          variables if duty cycle control is desired.*/
  
  virtual function void update_clock_enable (bit enable);
    bfm.update_clock_enable(enable);
  endfunction : update_clock_enable

  /////////////////////////////////////////////////////////////////////////////
  //Clock Interaction Code
  /////////////////////////////////////////////////////////////////////////////

  //For backpointer call from HDL side to inform HVL side that a clock
  //advancement has finished
  function void advance_finished();
    -> clock_advance_finished;
  endfunction : advance_finished
  
  //For backpointer call from HDL side to inform HVL side that the half period
  //has been updated
  function void half_period_updated(int unsigned half_period);
    //After this function is called by the BFM, there is another half period
    // from the previous clock and then a half period from the new clock
    //`uvm_info("clock_ctrl::half_period_updated()", $sformatf("dStartUpTimeInPs: %0d  dClockPeriodInPs: %0d  half_period: %0d", dStartUpTimeInPs, dClockPeriodInPs, half_period), UVM_LOW)
    dStartUpTimeInPs = $time + dClockPeriodInPs/2 + half_period;
    dClockPeriodInPs = half_period*2;
    //`uvm_info("clock_ctrl::half_period_updated()", $sformatf("dStartUpTimeInPs: %0d  dClockPeriodInPs: %0d  half_period: %0d", dStartUpTimeInPs, dClockPeriodInPs, half_period), UVM_LOW)
  endfunction : half_period_updated

  virtual task wait_clocks(int unsigned numClocksArg = 1,
                           string file = "",
                           int unsigned line = 0);
    XlSvQueue #(XlSvTimeSync) sync, pred, nextInQueue;

    longint unsigned currentClock, scheduledClock, deltaClocks;
    longint unsigned timeInNs;

    if( numClocksArg == 0 ) return;
    if (collectStats) count_stat({get_full_name(),".wait_clocks()"},file,line);

    sync = new();

    // Get the current time in PS, then convert it to equivalent number of
    // "fastest clocks".
    currentClock = psToClocks( $time );
    scheduledClock = currentClock + numClocksArg;

    sync.payload.setScheduledClock( scheduledClock );

    // Find time slot in queue for this advance request.
    pred = dTimeQueue;
    forever begin
      nextInQueue = pred.next();
      if( nextInQueue == null
          || nextInQueue.payload.scheduledClock() >= scheduledClock )
        break;
      pred = nextInQueue;
    end

    //`uvm_info("clock_ctrl::wait_clocks()", dTimeQueue.deep_sprint(), UVM_LOW)
    sync.enqueue( dTimeQueue, pred );
    //`uvm_info("clock_ctrl::wait_clocks()", dTimeQueue.deep_sprint(), UVM_LOW)

    // Advance global clock advancer to first scheduled clock on the queue.
    nextInQueue = dTimeQueue.next();
    if( nextInQueue == sync ) begin
      deltaClocks = nextInQueue.payload.scheduledClock() - currentClock;
      
      bfm.advance_clocks(deltaClocks);
    end

    // Now wait for time to arrive at scheduled clock.
    sync.payload.waitForSync();
  endtask : wait_clocks

  local function longint unsigned psToClocks( longint unsigned numPs );
    if( dStartUpTimeInPs == 0 ) initializeStartUpTime();
    
    //`uvm_info("clock_ctrl::psToClocks()", $sformatf("numPs: %0d  dClockPeriodInPs: %0d  dStartUpTimeInPs: %0d   calc: %0d", numPs, dClockPeriodInPs, dStartUpTimeInPs, (numPs <= dStartUpTimeInPs) ? 0 : (numPs-dStartUpTimeInPs) / dClockPeriodInPs), UVM_LOW)
    return (numPs <= dStartUpTimeInPs) ? 0 : (numPs-dStartUpTimeInPs) / dClockPeriodInPs;
  endfunction : psToClocks

  local function void initializeClockPeriod();
    // Get initial clock period
    setClockPeriodInPs( bfm.get_half_period_in_ps() * 2);
  endfunction : initializeClockPeriod

  local function void initializePhaseOffset();
    // Get the phase offset
    dPhaseOffsetInPs = bfm.get_phase_offset_in_ps();
  endfunction : initializePhaseOffset
  
  local function void initializeStartUpTime();
    //`uvm_info("clock_ctrl::initializeStartUpTime()", "StartUp Time updated", UVM_LOW)
    //Get the clock period and the phase offset (if need be)
    if( dClockPeriodInPs == 0 ) initializeClockPeriod();
    if( dPhaseOffsetInPs == 0 ) initializePhaseOffset();
    //At the beginning of a simulation, we have: phase offset + 1 full
    // clock period (used to adjust the clock half period) + half period and
    // then we get our first edge for our properly configured clock
    dStartUpTimeInPs = dPhaseOffsetInPs + INIT_CLOCK_HALF_PERIOD * 2 + dClockPeriodInPs/2;
  endfunction : initializeStartUpTime

  local function void setClockPeriodInPs( int unsigned clockPeriodInPs );
    dClockPeriodInPs = clockPeriodInPs;
    
    if( $time == 0 )
      `uvm_warning(report_id, "You are attempting a time advance at simTime==0. This can result in unpredictable behavior due to initialization races. Please sync on a reset generator before making any calls to the time advancer." )
    
    if( dClockPeriodInPs == 0 ) begin
      `uvm_error(report_id, "Detected parameter CLOCK_PERIOD=0 from HDL side. Be sure first time advance is called at time > 0." )
      dClockPeriodInPs = 1; // To avoid divide-by-0 errors.
    end
  endfunction : setClockPeriodInPs
  
  //---------------------------------------------------------
  // advanceNotifcationThread()
  //
  // This thread services all "advance maturity" notifications from the
  // HDL-side global clock advancer.
  //---------------------------------------------------------

  local task advanceNotificationThread();
    
    XlSvQueue #(XlSvTimeSync) sync, old;
    longint unsigned currentClock;
    longint unsigned tempClock;
    longint unsigned deltaClocks;
    
    forever begin // {
      @clock_advance_finished;
      
      sync = dTimeQueue.next();
      
      currentClock = sync.payload.scheduledClock();
      tempClock = psToClocks( $time );
      //`uvm_info("clock_ctrl::wait_clocks()", $sformatf("currentClock: %0d  tempClock: %0d", currentClock, tempClock), UVM_LOW)
      
      // Dequeue each entry in time queue scheduled for current time slot
      // and notify its waiting thread.
      //`uvm_info("clock_ctrl::wait_clocks()", dTimeQueue.deep_sprint(), UVM_LOW)
      do begin
        sync.payload.post();
        old = sync;
        sync = sync.next();
        old.dequeue();
      end while( sync != null &&
                 sync.payload.scheduledClock() == currentClock );
      //Ensure currentClock hasn't gotten off which can happen when time
      // advances for different clock domains are all sync'd in the same thread
      currentClock = psToClocks( $time );
      //`uvm_info("clock_ctrl::wait_clocks()", $sformatf("currentClock: %0d", currentClock), UVM_LOW)
      //`uvm_info("clock_ctrl::wait_clocks()", dTimeQueue.deep_sprint(), UVM_LOW)
      
      // Advance global clock advancer to first scheduled clock
      // on the queue.
      if( sync != null ) begin
        deltaClocks = sync.payload.scheduledClock() - currentClock;
        
        bfm.advance_clocks(deltaClocks);
      end
    end // }
  endtask : advanceNotificationThread
  
endclass : clock_ctrl
