#include "dpiheader.h"
#include "dpi_link.h"

extern "C" {

	extern void configure(const svBitVecVal* bit_vec_in);
	extern int bfm_access(const svBitVecVal* bit_vec_in, svBitVecVal* bit_vec_out);
	extern int response(const svBitVecVal* bit_vec_in, svBitVecVal* bit_vec_out);
	extern void do_response_ready(const svBitVecVal* bit_vec_in);
	extern void start_monitoring();
	extern int wait_for_reset();
	extern int wait_for_num_clocks(const svBitVecVal* bit_vec_in);
	
     int C_access(const char* path, svBitVecVal* bit_vec) {
          svSetScope(svGetScopeFromName(path));
          bfm_access(bit_vec, bit_vec);
     }

     int C_response(const char* path, svBitVecVal* bit_vec) {
          svSetScope(svGetScopeFromName(path));
          response(bit_vec, bit_vec);
     }

/* 
 * This function is called in monitors end_of_elaboration phase to associate the 
 * package with the bfm identified by the string variable called path.
 * This adds the wb_pkg to the hash using the path as the key.
 * The hash is stored in the dpi_link namespace
 */
    void C_initialize_monitor(const char * path) { 
        dpi_link::store_svScope(path); 
    }

     void 
     C_configure( const char * path, const svBitVecVal* bit_vec) {
        svSetScope(svGetScopeFromName(path));
        configure( bit_vec );
     }

     void
     C_do_response_ready( const char * path, const svBitVecVal* bit_vec) {
        svSetScope(svGetScopeFromName(path));
        do_response_ready( bit_vec);
     }

     void
     C_start_monitoring(const char * path) {
        svSetScope(svGetScopeFromName(path));
        start_monitoring();
     }

     int
     C_wait_for_reset(const char * path) {
        svSetScope(svGetScopeFromName(path));
        wait_for_reset();
     }

     int
     C_wait_for_num_clocks(const char * path, const svBitVecVal* bit_vec) {
        svSetScope(svGetScopeFromName(path));
        wait_for_num_clocks(bit_vec);
     }
}


