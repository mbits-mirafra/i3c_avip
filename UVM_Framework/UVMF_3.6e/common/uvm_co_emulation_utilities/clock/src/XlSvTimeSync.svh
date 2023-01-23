//============================================================================
// @(#) $Id: XlSvTimeSync.svh 681 2011-07-06 10:56:19Z jstickle $
//============================================================================

//--------------------------------------------------------------------------//
//  Mentor Graphics, Corp.                                                  //
//                                                                          //
//  (C) Copyright, Mentor Graphics, Corp. 2003-2011                         //
//  All Rights Reserved                                                     //
//  Licensed Materials - Property of Mentor Graphics, Corp.                 //
//                                                                          //
//  No part of this file may be reproduced, stored in a retrieval system,   //
//  or transmitted in any form or by any means --- electronic, mechanical,  //
//  photocopying, recording, or otherwise --- without prior written         //
//  permission of Mentor Graphics, Corp.                                    //
//                                                                          //
//  WARRANTY:                                                               //
//  Use all material in this file at your own risk. Mentor Graphics, Corp.  //
//  makes no claims about any material contained in this file.              //
//--------------------------------------------------------------------------//

`ifndef _XlSvTimeSync_svh_ // {
`define _XlSvTimeSync_svh_

//____________________                                       ________________
// class XlSvTimeSync \_____________________________________/ johnS 6-15-2010
//---------------------------------------------------------------------------

class XlSvTimeSync; // {

  //private:
    local event dIsAdvanceDone;
    local longint unsigned dScheduledClock;

  //public:

    function new(); endfunction

    //---------------------------------------------------------
    // accessors

    function void setScheduledClock( longint unsigned scheduledClock );
        dScheduledClock = scheduledClock; endfunction
    function longint unsigned scheduledClock();
        scheduledClock = dScheduledClock; endfunction

    task waitForSync(); @dIsAdvanceDone; endtask
    function void post(); ->dIsAdvanceDone; endfunction

  function string sprint();
    return $sformatf("dScheduledClock: %0d", dScheduledClock);
  endfunction : sprint
  
endclass // }

`endif // } _XlSvTimeSync_svh_
