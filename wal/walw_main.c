#ifndef SUPERSERVER
/* JMB - I didn't like have a "main" symbol is the shared library, so
 * I change the function name from main to walw_classic_main and
 * added the walw_main.c file.
extern int walw_classic_main(int, char**);

int CLIB_ROUTINE main (
    int         argc,  
    char        **argv)
{
    return walw_classic_main(argc, argv);
}
#endif

