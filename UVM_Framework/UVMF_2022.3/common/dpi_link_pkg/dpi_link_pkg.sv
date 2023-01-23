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
// $Date: 2016-05-27 13:25:41 -0400 (Fri, 27 May 2016) $
// $Revision: 5406 $
//---------------------------------------------------------------------------
package dpi_link_pkg;
 import uvm_pkg::*;
 import uvmf_base_pkg::*;
 `include "uvm_macros.svh"
 `include "mcd_macros.svh"
 `include "dpi_link_macros.svh"

 import "DPI-C" function bit scope_exists(string name);
 import "DPI-C" context function void initialize_hvl_events();

typedef class dpi_link_proxy;
typedef class dpi_link_event;
 typedef   uvm_object_string_pool #(dpi_link_event) dpi_link_event_pool;
 typedef   uvm_object_string_pool #(dpi_link_proxy) dpi_link_proxy_pool;

function string standardized_path(input string path);
    string ret;
    if (path[0] == "/")
        ret = path.substr(1,path.len-1);
    else
        ret = path;

    for (int ii = 1; ii<ret.len(); ++ii) begin
        if (ret[ii] == " ")
            `uvm_fatal("DPI LINK", $sformatf("Illegal space in path '%s'",path))
        if (ret[ii] == "/")
            ret[ii] = ".";
    end
    return ret;
endfunction

function string path2filename(input string path);
    string ret;
    ret = standardized_path(path);
    for (int ii = 0; ii<ret.len(); ++ii)
        if (ret[ii] == ".")
            ret[ii] = "_";
    return ret;
endfunction : path2filename


    `include "dpi_link_proxy.svh"
    `include "dpi_link_event.svh"
    
endpackage : dpi_link_pkg

