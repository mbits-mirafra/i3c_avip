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
// $Date: 2016-05-26 09:22:41 -0400 (Thu, 26 May 2016) $
// $Revision: 5351 $
//---------------------------------------------------------------------------
`ifndef DPI_LINK_PROXY
`define DPI_LINK_PROXY

`define dpi_link_proxy_get(T) \
   static function T get(string path = ""); \
      string std_path; \
      dpi_link_proxy_pool pool_h; \
      T proxy_h; \
      std_path = dpi_link_pkg::standardized_path(path); \
      pool_h = dpi_link_proxy_pool::get_global_pool(); \
      if (!pool_h.exists(std_path)) begin \
	 proxy_h = new(std_path); \
	 pool_h.add(std_path, proxy_h);    end \
      else $cast(proxy_h, pool_h.get(std_path)); \
      return proxy_h; \
   endfunction : get \

`endif

