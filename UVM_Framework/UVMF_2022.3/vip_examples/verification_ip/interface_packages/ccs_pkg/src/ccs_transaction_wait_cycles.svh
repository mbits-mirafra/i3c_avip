//----------------------------------------------------------------------
// Created with uvmf_gen version 2020.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an ccs
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class ccs_transaction_wait_cycles #(
      int WIDTH = 32
      ) extends ccs_transaction #(
                                  WIDTH
                                 );

  `uvm_object_param_utils( ccs_transaction_wait_cycles #(
                           WIDTH
                           ))

  // override the default constraint thus introducing delays in the assertion of the 
  // valid and rdy signals as driven by ccs_agents INITIATORs and RESPONDERs respectively.
  // Constraints for the transaction variables:
  // constraint wait_cycles_c { wait_cycles <= 0; } // Constrain wait_cycles to be no more than 16 cycles
  constraint wait_cycles_c { wait_cycles <= 16; } // Constrain wait_cycles to be no more than 16 cycles
  // constraint wait_cycles_c { wait_cycles <= 256; } // Constrain wait_cycles to be no more than 256 cycles

  function new( string name = "" );
    super.new( name );
  endfunction

endclass
