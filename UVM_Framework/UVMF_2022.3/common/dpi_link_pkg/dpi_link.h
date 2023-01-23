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
#ifndef DPI_LINK_HEADER_
#define DPI_LINK_HEADER_
#include "svdpi.h"
#include <string>
#include <map>
#include <iostream>
namespace dpi_link {
    static int USER_KEY;

    static std::map<std::string, svScope > package_map;
    
    svLogic read_bit(const svLogicVecVal * bus, unsigned int bit_n);
    svBit   read_bit(const svBitVecVal   * bus, unsigned int bit_n);

    char bit_to_char(const svLogic bit);
    char bit_to_char(const svBit bit);
    
    void * get_user_key();
  

    void create_svBitVecVal(const std::string vec_str, svBitVecVal * vec);
    
    template<typename vecT>
    std::string vec_to_string(const vecT vec, int length){
        std::string s;
        for (int ii = 0; ii<length; ++ii){
            svLogic bit = read_bit(vec, ii);
            switch (bit) {
                case sv_0 : s = "0"+s; break;
                case sv_1 : s = "1"+s; break;
                case sv_x : s = "X"+s; break;
                case sv_z : s = "Z"+s; break;
                default : 
                    std::cout << "vec_to_string: Invalid bit value: " << bit << std::endl;
                    s = "?"+s;
            }
        }
        return s;
    }
    void store_svScope(const char * path);
    svScope get_svScope(const char * path);
}
extern "C" {
    svBit scope_exists(const char * name);
    void trigger_hvl_event(int unsigned ret_value);
    void trigger_numbered_hvl_event(int unsigned event_num, int unsigned ret_value);
    void trigger_named_event(const char * name, int unsigned ret_value);

    
}
#endif
