//---------------------------------------------------------------------------
// Copyright 2014 Mentor Graphics Corporation 
//    All Rights Reserved 
// 
// THIS WORK CONTAINS TRADE SECRET 
// AND PROPRIETARY INFORMATION WHICH IS THE 
// PROPERTY OF MENTOR GRAPHICS 
// CORPORATION OR ITS LICENSORS AND IS 
// SUBJECT TO LICENSE TERMS. 
// 
//---------------------------------------------------------------------------
//   WARRANTY:
//   Use all material in this file at your own risk.  Mentor Graphics, Corp.
//   makes no claims about any material contained in this file.
//---------------------------------------------------------------------------
// $Date: 2015-10-26 17:24:48 -0400 (Mon, 26 Oct 2015) $
// $Revision: 4120 $
//---------------------------------------------------------------------------
class dpi_link_proxy extends uvm_object;
   `uvm_object_utils(dpi_link_proxy);
   
   dpi_link_event dpi_link_event_h;
   
   protected function new(string name = "");
      dpi_link_proxy_pool pool_h;
      super.new(name);
      
      // check for XRTL
      if (!scope_exists(get_xrtl_path()))
	`uvm_fatal("dpi_link_proxy", {"Tried to set a proxy to a  nonexistant scope: ", get_xrtl_path()});
      
      // Store the event syncronizer
      dpi_link_event_h = dpi_link_event::get_event_using_xrtl_path(get_xrtl_path());
      
endfunction : new

   `dpi_link_proxy_get(dpi_link_proxy)

function string get_xrtl_path();
   return super.get_name();
endfunction : get_xrtl_path

task wait_for(output int unsigned ret_val);
    dpi_link_event_h.wait_for(ret_val);
endtask : wait_for


endclass : dpi_link_proxy

