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
#include "dpi_link.h"
#include <iostream>
#include <sstream>
#include <cstdlib>
static svScope hvl_scope;

svLogic dpi_link::read_bit(const svLogicVecVal * bus, unsigned int bit_n){
    return  svGetBitselLogic(bus, bit_n);
}

svBit dpi_link::read_bit(const svBitVecVal * bus, unsigned int bit_n){
    return  svGetBitselBit(bus, bit_n);
}

void * dpi_link::get_user_key(){
  return  &(dpi_link::USER_KEY);
}

   void dpi_link::create_svBitVecVal(const std::string vec_str, svBitVecVal * vec) {
        int bit = vec_str.length() - 1;
        for (std::string::const_iterator it = vec_str.begin(); it != vec_str.end(); ++it){
            std::cout << *it;
            switch(*it){
                case '0' : svPutBitselBit(vec, bit, sv_0 );
                break;
                case '1' : svPutBitselBit(vec, bit, sv_1 );
                break;
                default :
                    std::cout << "Invalid vector string in create_svBitVecVal:" <<vec_str<<std::endl;
            }
            --bit;
        }
    }

char dpi_link::bit_to_char(const svLogic bit){
    switch (bit) {
        case sv_0 : return '0';
        case sv_1 : return '1';
        case sv_x : return 'X';
        case sv_z : return 'Z';
    }
    return '?';
}

    void dpi_link::store_svScope(const char * path){
        std::string path_str = path;
        dpi_link::package_map[path] = svGetScope();
//        std::cout << "Stored " << svGetScope() << " in dpi_link::package_map["<<path<<"]" << std::endl;
    }

    svScope dpi_link::get_svScope(const char * path){
        std::string path_str = path;
//        std::cout << "Read " << dpi_link::package_map[path] << " from dpi_link::package_map["<<path<<"]" << std::endl;
        return (svScope *) dpi_link::package_map[path_str];
    }

extern "C" {

    svBit scope_exists(const char * name) {
        return (svGetScopeFromName(name) != NULL);
    }

    void trigger_the_event(const char * event_name, int unsigned ret_value){
      if (hvl_scope == NULL) {
	std::cout << "MCD event system not initialized. trigger_*_event called before initialize_hvl_events"<<std::endl;
	exit(1);
      }
      svSetScope(hvl_scope);
      trigger_named_event(event_name, ret_value);
    }

    void trigger_hvl_event(int unsigned ret_value){
      trigger_the_event(svGetNameFromScope(svGetScope()), ret_value);
    }

    void trigger_numbered_hvl_event(int unsigned event_num, int unsigned ret_value){
        std::stringstream num_string;
        num_string << event_num;
        trigger_the_event(num_string.str().c_str(), ret_value);
    }


    void initialize_hvl_events(){
        hvl_scope = svGetScope();
    }

}

