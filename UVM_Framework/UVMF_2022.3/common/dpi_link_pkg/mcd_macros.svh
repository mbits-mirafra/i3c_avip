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
// $Date: 2015-12-02 08:43:55 -0700 (Wed, 02 Dec 2015) $
// $Revision: 3169 $
//---------------------------------------------------------------------------
`ifndef MCD_MACROS
`define MCD_MACROS

`define mcd_uvm_new_component function new(string name = "", uvm_component parent = null);super.new(name,parent); endfunction
`define mcd_uvm_new_object function new(string name = "");super.new(name); endfunction


`define declare_set_get(t, n) \
   protected t n; \
   protected bit n``_set = 0; \
   virtual function void set_``n(t ``n); \
      this.``n = n; \
      n``_set = 1'b1; \
   endfunction : set_``n \
   virtual function t get_``n(); \
      if (!``n``_set) \
	`uvm_fatal(`"get_``n```", `"Tried to get data member '``n' before setting it`") \
      return n; \
   endfunction : get_``n


`define declare_rand_set_get(t, n) \
   rand protected t n; \
   rand protected bit n``_set = 0; \
   constraint set_``n``_c {n``_set == 1'b1;} \
   virtual function void set_``n(t ``n); \
      this.``n = n; \
      n``_set = 1'b1; \
   endfunction : set_``n \
   virtual function t get_``n(); \
      if (!``n``_set) \
	`uvm_fatal(`"get_``n```", `"Tried to get data member '``n' before setting it`") \
      return n; \
   endfunction : get_``n

`endif

