/*
 File Name       : tbxbindings.h

 This is a machine-generated file. Please do not edit.
*/

#ifndef _tbxbindings_h_
#define _tbxbindings_h_

#include <svdpi.h>
#include "vpi_user.h"
#ifdef __cplusplus
void tbx_perform_release_impl(const char* file, int line, const char* signal_name);
#define tbx_perform_release(signal_name) tbx_perform_release_impl(__FILE__,__LINE__,signal_name)
void tbx_perform_set_impl(const char* file, int line, const char* signal_name, svBitVecVal* signal_value);
#define tbx_perform_set(signal_name,signal_value) tbx_perform_set_impl(__FILE__,__LINE__,signal_name,signal_value)
void tbx_perform_force_impl(const char* file, int line, const char* signal_name, svBitVecVal* signal_value);
#define tbx_perform_force(signal_name,signal_value) tbx_perform_force_impl(__FILE__,__LINE__,signal_name,signal_value)
void tbx_perform_get_impl(const char* file, int line, const char* signal_name, svBitVecVal* &signal_value, int& size);
#define tbx_perform_get(signal_name,signal_value,size) tbx_perform_get_impl(__FILE__,__LINE__,signal_name,signal_value,size)



int tbx_release_api(const char* file, int line, const char* signal_name); 
int tbx_set_api(const char* file, int line, const char* signal_name, svLogicVecVal* signal_value, int size); 
int tbx_force_api(const char* file, int line, const char* signal_name, svLogicVecVal* signal_value, int size); 
int tbx_get_api(const char* file, int line, const char* signal_name, svLogicVecVal* &signal_value, int *size); 
int tbx_size_api(const char* file, int line, const char* signal_name); 
#define tbx_release_function(signal_name) tbx_release_api(__FILE__,__LINE__,signal_name)
#define tbx_set_function(signal_name,signal_value, value_size) tbx_set_api(__FILE__,__LINE__,signal_name,signal_value, value_size)
#define tbx_force_function(signal_name,signal_value, value_size) tbx_force_api(__FILE__,__LINE__,signal_name,signal_value, value_size)
#define tbx_get_function(signal_name,signal_value,size) tbx_get_api(__FILE__,__LINE__,signal_name,signal_value,size)
#define tbx_size_function(signal_name) tbx_size_api(__FILE__,__LINE__,signal_name)

extern "C" {
#endif
void aowc_get_exec_time(vpiHandle obj, s_vpi_time *time_p);


#ifdef __cplusplus
}
#endif

#endif
