/* This file is included by guard.c, ibmgr.c, srvrmgr.c, ibmgr.h,
   and ibmgrswi.h to define whether the code to disable
   the nagle algorithm and the appropriate switches are included.
   If this is necessary for other platforms, just add them to the
   define below and check the calls to setsockopt in guard.c
   FSG 27.Dez.2000 
*/ 

#ifdef LINUX
#define SET_TCP_NODELAY
#endif
