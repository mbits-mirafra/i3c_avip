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
export "DPI-C" function trigger_named_event;


function void trigger_named_event(string event_name, input int unsigned ret_value = 0);
   string key; 
   dpi_link_event trig_event;
   dpi_link_event_pool event_pool_h;
   event_pool_h = dpi_link_event_pool::get_global_pool();
   if (!event_pool_h.exists(event_name))
     `uvm_warning("dpi_link_event", {"Triggered event: \"", event_name,"\" before the hvl was waiting for it. Perhaps a misspelled event name?"});
   trig_event = dpi_link_event_pool::get_global(event_name);
   trig_event.trigger_event(ret_value);
endfunction : trigger_named_event
   


class dpi_link_event extends uvm_object;
   `uvm_object_utils(dpi_link_event);

   event  this_event;
   protected int ret_val;
   
   protected static bit initialized = 0;
   protected function new(string name = "", string event_name="");
      super.new(name);
      if (!initialized) begin
	 initialize_hvl_events();
	 initialized = 1;
      end

   endfunction : new

   static function dpi_link_event get_event_using_number(int event_num);
      string event_name;
      event_name = $sformatf("%0d", event_num);
      return dpi_link_event_pool::get_global(event_name);
   endfunction : get_event_using_number
   

   static function dpi_link_event get_event_using_xrtl_path(string xrtl_path);
      if (!scope_exists(xrtl_path))
	  `uvm_fatal("dpi_link_event", {"Tried to get an xrtl path event with non existant xrtl path: ",xrtl_path})
      return dpi_link_event_pool::get_global(xrtl_path);
   endfunction : get_event_using_xrtl_path
   
   function void trigger_event(input int unsigned ret_value = 0);
      this.ret_val = ret_value;
      -> this_event;
   endfunction : trigger_event

   task wait_for(output int unsigned ret_value);
      @this_event;
      ret_value= this.ret_val;
   endtask : wait_for

endclass : dpi_link_event
