#ifndef _FPU_TLM_DPI_C_H
#define _FPU_TLM_DPI_C_H

#include "stdio.h"
#include <string.h>
#include "math.h" 
#include <fenv.h>

#define TRUE 1
#define FALSE 0

#define OP_CODES 5

#define OP_ADD 0
#define OP_SUB 1
#define OP_MUL 2
#define OP_DIV 3
#define OP_SQR 4

#define RND_TONEAREST 0
#define RND_TOWARDZERO 1
#define RND_UPWARD 2
#define RND_DOWNWARD 3

#define MB_DEBUG

#define P_INFINITY 0x7F800000
#define SNaN_P_MIN 0x7F800001
#define SNaN_P_MAX 0x7FBFFFFF
#define QNaN_P_MIN 0x7FC00000
#define QNaN_P_MAX 0x7FFFFFFF

#define N_INFINITY 0xFF800000
#define SNaN_N_MIN 0xFF800001	// neg min
#define SNaN_N_MAX 0xFFBFFFFF	// neg max
#define QNaN_N_MIN 0xFFC00000
#define QNaN_N_MAX 0xFFFFFFFF


union ufloat {
  float f;
  unsigned u;
};

#endif






