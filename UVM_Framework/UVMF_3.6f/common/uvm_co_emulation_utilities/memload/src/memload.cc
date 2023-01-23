#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mti.h"
#ifdef QUESTA
#include "dpiheader.h"
#else
#include "tbxbindings.h"
#include "TclClientLib_C.h"
#endif

//extern "C" {
 

char* strrev(char* str) {
    char *temp, *ptr;
    int len, i;

    temp=str;
    for(len=0; *temp !='\0';temp++, len++);

    ptr=(char *)malloc(sizeof(char)*(len+1));

    for(i=len-1; i>=0; i--)
        ptr[len-i-1]=str[i];

    ptr[len]='\0';
    return ptr;
}

//memLoad(string fname, string path, int startAddr, int endAddr, string format)
void memLoad(const svBitVecVal* fname_in,
						 const svBitVecVal* path_in,
						 int startAddr,
						 int endAddr,
						 const svBitVecVal* format_in)
{
    char *fname = strrev((char *)fname_in);
    char *path = strrev((char *)path_in);
    char *format = strrev((char *)format_in);

    printf("fname=%s\n", fname);
    printf("path=%s\n", path);
    printf("format=%s\n", format);

#ifdef QUESTA
    char cmd[BUFSIZ];
    sprintf(cmd, "mem load -infile %s %s -format %s", fname, path, format);
    if (startAddr != -1)
        sprintf(cmd + strlen(cmd), " -startaddress %s", startAddr);
    if (endAddr != -1)
        sprintf(cmd + strlen(cmd), " -endaddress %s", endAddr);

    mti_Command(cmd);
#else
    DmMemFormat_e fmt = DEFAULT_MEM_ADDR_FMT;
    if (strcmp(format, "hex") == 0)
        fmt = cVerilogHex;
    else if (strcmp(format, "bin") == 0)
        fmt = cVerilogbin;
    else
        printf("[WARNING] memory format type: %s not supported\n", format);

    dm_clock_suspend();
    dm_memory_download_file((char *)fname, (char *)path, startAddr, endAddr, fmt);
    dm_clock_resume();

#endif
}

//} //extern "C"
