#include <stdio.h>
#include <unistd.h>

#define FB_STR "Firebird.framework"

extern void gds__prefix(char *, char*);

int main()
{
    char buff[2048];
    int offset;

#ifdef VAR_PATH
    gds__prefix(buff, "");
#else
    gds__prefix(buff, "bin");
#endif

#ifdef INCLUDE_PATH
    if (strlen(buff) >= strlen(FB_STR))
    {
        for(offset = strlen(buff) - strlen(FB_STR); offset >= 0; offset--)
            if (!strncmp(&buff[offset], FB_STR, strlen(FB_STR)))
                break;
    }
    buff[offset + strlen(FB_STR)] = 0;
    strcat(buff, "/Headers");
#endif
    printf("%s\n", buff);
    return 0;
}
