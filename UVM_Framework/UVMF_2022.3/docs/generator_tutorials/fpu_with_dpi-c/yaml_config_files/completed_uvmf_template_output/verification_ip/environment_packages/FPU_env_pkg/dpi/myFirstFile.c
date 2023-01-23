/*
**********************************************************************
  Placeholder for complete C file.  This placeholder allows
  compilation of generated environment without modification.
**********************************************************************
*/
#include <stdio.h>
#include "fpu_tlm_dpi_c.h"
#include "dpiheader.h"

void fpu_compute (const reqstruct* req_data, rspstruct* rsp_data)
{
        printf("Inside fpu_compute\n");
		 //#pragma STDC FENV_ACCESS ON

  float result;
  
  //fexcept_t exc_flags;
  int rnd_mode;
  
  //svBitVecVal exc_flags_actual = 0;

  /* Save state of exception flags and actual rounding mode */
  //fegetexceptflag( &exc_flags, FE_INEXACT | FE_DIVBYZERO| FE_UNDERFLOW | FE_OVERFLOW | FE_INVALID );
  rnd_mode = fegetround();

  switch(req_data->round) {
  case RND_TONEAREST:
    fesetround(FE_TONEAREST);
    break;
  case RND_TOWARDZERO:
    fesetround(FE_TOWARDZERO);
    break;
  case RND_UPWARD:
    fesetround(FE_UPWARD);
    break;
  case RND_DOWNWARD:
    fesetround(FE_DOWNWARD);
    break;
  }
  
  //feclearexcept( FE_INEXACT | FE_DIVBYZERO| FE_UNDERFLOW | FE_OVERFLOW | FE_INVALID );

  switch(req_data->op)
  {
  case OP_ADD:
	result = req_data->a + req_data->b;
	break;
  case OP_SUB:
	result = req_data->a - req_data->b;
	break;
  case OP_MUL:
	result = req_data->a * req_data->b;
        break;
  case OP_DIV:
    result = (req_data->a / req_data->b);
    break;
  case OP_SQR:
    result = sqrt(req_data->a);
    break;
  }

  /* Restore state of exception flags and actual rounding mode as saved: */	       
  //fesetexceptflag( &exc_flags, FE_INEXACT | FE_DIVBYZERO| FE_UNDERFLOW | FE_OVERFLOW | FE_INVALID );
  fesetround(rnd_mode);
  
  rsp_data->a      = req_data->a;
  rsp_data->b      = req_data->b;
  rsp_data->op     = req_data->op;
  rsp_data->round  = req_data->round;
  rsp_data->result = result;
  /*res->status[0] = exc_flags_actual;*/
 
}
