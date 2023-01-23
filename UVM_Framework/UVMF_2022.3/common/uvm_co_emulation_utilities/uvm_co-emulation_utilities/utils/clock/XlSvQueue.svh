//============================================================================
// @(#) $Id: XlSvQueue.svh 681 2011-07-06 10:56:19Z jstickle $
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

//_________________                                          ________________
// class XlSvQueue \________________________________________/ johnS 6-15-2010
//---------------------------------------------------------------------------

class XlSvQueue #(type PayloadType = int); // {

  //private:

  local XlSvQueue #(PayloadType) dQueue;
  local XlSvQueue #(PayloadType) dNext;
  local XlSvQueue #(PayloadType) dTail;

  //public:
  PayloadType payload;

  function new(); payload = new(); endfunction

  function void setNext( XlSvQueue #(PayloadType) next );
    dNext = next; endfunction
  function void setTail( XlSvQueue #(PayloadType) tail );
    dTail = tail; endfunction
  function XlSvQueue #(PayloadType) next(); return dNext; endfunction
  function XlSvQueue #(PayloadType) tail(); return dTail; endfunction

  function void enqueue(
                        XlSvQueue #(PayloadType) queue,
                        XlSvQueue #(PayloadType) pred=null );
    // {
    // By default, use queue tail itself as predecessor.
    if( pred == null ) begin
      pred = queue.tail();
      if( pred == null )
        pred = queue;
    end

    // if( I'm not already enqueued ... )
    if( dQueue == null ) begin
      dQueue = queue;

      setNext( pred.next() );
      pred.setNext( this );

      if( next() == null ) queue.setTail( this );
    end

    // I'd better not be part of another queue ...
    else if( dQueue != queue )
      $display( { "XL-VIP ERROR: XlSvQueue::enqueue() ",
                  "Attempting to enqueue an entry that is ",
                  "already part of another queue.\n" } );
  endfunction // }

  function void dequeue(); // {
    // I'd better already be enqueued ...
    if( dQueue == null )
      $display( { "XL-VIP ERROR: XlSvQueue::dequeue() ",
                  "Attempting to dequeue an entry that is ",
                  "not part of this queue.\n" } );

    // Furthermore, I'd better at the head ...
    if( dQueue.next() != this )
      $display( { "XL-VIP ERROR: XlSvQueue::dequeue() ",
                  "Attempting to dequeue an entry that is ",
                  "not part at the head of this queue.\n" } );

    dQueue.setNext( next() );
    if( next() == null ) dQueue.setTail( null );
    dQueue = null;
  endfunction // }


  function bit isEmpty();
    return ((dNext == null) & (dTail == null));
  endfunction : isEmpty

  function string sprint(bit show_dQueue=0);
    string msg = $get_id_from_handle(this);
    if (show_dQueue) 
      if (dQueue == null)
        $sformat(msg, "%s dQueue = null", msg);
      else
        $sformat(msg, "%s dQueue = %s", msg, $get_id_from_handle(dQueue));
    if (dNext == null)
      $sformat(msg, "%s dNext = null", msg);
    else
      $sformat(msg, "%s dNext = %s", msg, $get_id_from_handle(dNext));
    if (dTail == null)
      $sformat(msg, "%s dTail = null", msg);
    else
      $sformat(msg, "%s dTail = %s", msg, $get_id_from_handle(dTail));
    $sformat(msg, "%s payload = %s", msg, payload.sprint());
    return msg;
  endfunction : sprint

  function string deep_sprint(string prefix = "->");
    XlSvQueue #(PayloadType) next = this;
    string msg;
    int    ii = 0;
    while (next != null) begin
      msg = $sformatf("%s%s%s\n", msg, {ii{prefix}}, next.sprint());
      ii++;
      next = next.dNext;
    end
    return msg;
  endfunction : deep_sprint
  
endclass // }

