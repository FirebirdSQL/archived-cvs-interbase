#include <iostream.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <string.h>
#include <ibase.h>
#include <assert.h>

#if 0
#define DEBUG_MSG(msg) { fprintf(stdout, "%d: ", getpid()); fprintf(stdout, (msg)); fflush(stdout); }
#define DEBUG_MSG_1(msg, x) { fprintf(stdout, "%d: ", getpid()); fprintf(stdout, (msg), (x)); fflush(stdout); }
#define DEBUG_MSG_2(msg, x, y) { fprintf(stdout, "%d: ", getpid()); fprintf(stdout, (msg), (x), (y)); fflush(stdout); }
#else
#define DEBUG_MSG(msg) { }
#define DEBUG_MSG_1(msg, x) { }
#define DEBUG_MSG_2(msg, x, y) { }
#endif

#define SEND_MSG(msg, dst) { DEBUG_MSG_1("Send: %s", (msg)); fprintf((dst), (msg)); fflush(dst); }
#define SEND_MSG_1(msg, x, dst) { DEBUG_MSG_2("Send: %s", (msg), (x)); fprintf((dst), (msg), (x)); fflush(dst); }

int MAX_THREADS = 10;
char *SQL = "SELECT F.FACILITY, M.CODE, M.TEXT FROM FACILITIES F, MESSAGES M WHERE F.FAC_CODE = M.FAC_CODE ORDER BY F.FACILITY, M.CODE";

class ChildProcess
{
    public:
        ChildProcess(char *db, char *user, char *pass);
        virtual ~ChildProcess();

        double getConnectTime() { return ((double)connectTime)/1000000.0; }
        void forkProc();
        void releaseFromCheckpoint();
        void quit();
        int atCheckpoint();

    protected:
        void run();
        void connectToDb();
        void disconnectFromDb();
        void childWorkLoop();
        long executeSql();

        FILE *outputFd, *inputFd;
        pid_t pid;
        void *db_handle, *tr_handle;
        char *dbPath, *dbUser, *dbPassword;
        long connectTime;
};

int main(int argn, char **argv)
{
    ChildProcess *procs[MAX_THREADS];

    if (argn != 5)
    {
        printf("Usage: %s <num concurrent processes to test> <path to msg.gdb on test server> <username> <password>\n", argv[0]);
        exit(1);
    }
    MAX_THREADS = atoi(argv[1]);

    for(int num = 0; num < MAX_THREADS; num++)
    {
        /* Allocate our new thread, then wait for them all to report in */
        procs[num] = new ChildProcess(argv[2], argv[3], argv[4]);
        procs[num]->forkProc();
        for(int i = 0; i <= num; i++)
            procs[i]->atCheckpoint();

        /* Report the stats for the new connection */
        printf("Testing %d connections\n", num + 1);
        printf("Connection %d took %f seconds to establish\n", 1 + num,
             procs[num]->getConnectTime());

        /* Release the hounds */
        for(int i = 0; i <= num; i++)
            procs[i]->releaseFromCheckpoint();
    }
    for(int i = 0; i < MAX_THREADS; i++)
        procs[i]->atCheckpoint();
    printf("Please wait while I quit all child processes...\n");
    for(int num = 0; num < MAX_THREADS; num++)
    {
        procs[num]->quit();
        delete procs[num];
        printf("\t%d\n", num);
    }
}


/************* The good stuff follows  ***********************/
void ChildProcess::forkProc()
{
    int toChild[2], fromChild[2];

    /*printf("Forking child...\n");
    fflush(stdout);*/
    pipe(toChild);
    pipe(fromChild);
    pid = fork();
    if (pid)
    {
        /*printf("\t pid: %d\n", pid);
        fflush(stdout);*/
        outputFd = fdopen(toChild[1], "w");
        close(toChild[0]);
        inputFd = fdopen(fromChild[0], "r");
        close(fromChild[1]);
        return;
    }
    close(toChild[1]);
    close(fromChild[0]);
    inputFd = fdopen(toChild[0], "r");
    outputFd = fdopen(fromChild[1], "w");
    childWorkLoop();
    exit(0);
}

void ChildProcess::childWorkLoop()
{
    char buff[256];
    int quitting = 0;
    long runTime;

    connectToDb();

    do
    {
        /* Wait at the checkpoint */
        SEND_MSG("READY\n", outputFd);
        do
        {
            if (!fgets(buff, 254, inputFd))
                assert(0);
            if (!buff[0])
                continue;
            if (buff[strlen(buff) - 1] == '\n')
                buff[strlen(buff) - 1] = 0;
            if (!buff[0])
                continue;
            DEBUG_MSG_1("Rcvd: %s\n", buff);
            if (!strcmp("QUIT", buff))
            {
                quitting = 1;
                break;
            }
            if (!strcmp("RUN", buff))
                break;
        } while(!quitting);
        DEBUG_MSG("RUNNING\n");
        runTime = executeSql();
        SEND_MSG_1("ELAPSED: %ld\n", runTime, outputFd);
 
        /* We should be doing some fun statements here, but that will happen later */
    } while (!quitting);

    disconnectFromDb();
}

void ChildProcess::releaseFromCheckpoint()
{
    SEND_MSG("RUN\n", outputFd);
}

void ChildProcess::quit()
{
    int stat;

    SEND_MSG("QUIT\n", outputFd);
    waitpid(pid, &stat, 0);
}

ChildProcess::ChildProcess(char *db, char *user, char *pass)
: dbPath(0), dbUser(0), dbPassword(0), db_handle(0), tr_handle(0), pid(0),
  inputFd(0), outputFd(0), connectTime(-1)
{
    assert(db);
    dbPath = new char[strlen(db)+1];
    strcpy(dbPath, db);
    if (user)
    {
        dbUser = new char[strlen(user)+1];
        strcpy(dbUser, user);
    }
    if (pass)
    {
        dbPassword = new char[strlen(pass)+1];
        strcpy(dbPassword, pass);
    }
}

long ChildProcess::executeSql()
{
    XSQLDA *out_sqlda;
    XSQLVAR *var;
    isc_stmt_handle stmt = NULL;
    ISC_STATUS sv[20], retcode;
    long code;
    char facility[16], message[132];
    short null1, null2, null3;
    struct timeval startTime, endTime;

    out_sqlda = (XSQLDA*) malloc(XSQLDA_LENGTH(10));
    assert(out_sqlda);
    out_sqlda->version = SQLDA_VERSION1;
    out_sqlda->sqln = 10;

    gettimeofday(&startTime, 0);
    if (isc_dsql_allocate_statement(sv, &db_handle, &stmt))
    {
        isc_print_status(sv);
        assert(0);
    }
    if (isc_dsql_prepare(sv, &tr_handle, &stmt, 0, SQL, 1, NULL))
    {
        isc_print_status(sv);
        assert(0);
    }
    if (isc_dsql_describe(sv, &stmt, 1, out_sqlda))
    {
        isc_print_status(sv);
        assert(0);
    }
    var = out_sqlda->sqlvar;
    var[0].sqltype = SQL_TEXT + 1;
    var[0].sqldata = facility;
    var[0].sqlind = &null1;
    var[1].sqltype = SQL_LONG + 1;
    var[1].sqldata = (char*)&code;
    var[1].sqlind = &null2;
    var[2].sqltype = SQL_TEXT + 1;
    var[2].sqldata = message;
    var[2].sqlind = &null3;

    if (isc_dsql_execute(sv, &tr_handle, &stmt, 1, NULL))
    {
        isc_print_status(sv);
        assert(0);
    }
    while ((retcode = isc_dsql_fetch(sv, &stmt, 1, out_sqlda)) == 0)
    {
    }
    if (retcode != 100L)
    {
        isc_print_status(sv);
        assert(0);
    }
    if (isc_dsql_free_statement(sv, &stmt, DSQL_drop))
    {
        isc_print_status(sv);
        assert(0);
    }
    gettimeofday(&endTime, 0);
    return 1000000 * (endTime.tv_sec - startTime.tv_sec) + endTime.tv_usec - startTime.tv_usec;
}

void ChildProcess::connectToDb()
{
    char    dpb_buffer [256], *dpb, *p;
    short   dpb_length;
    ISC_STATUS sv[20];
    struct timeval startTime, endTime;

    assert(db_handle == 0);
    dpb = dpb_buffer;
    *dpb++ = isc_dpb_version1;
    if (dbUser)
    {
        *dpb++ = isc_dpb_user_name;
        *dpb++ = strlen (dbUser);
        for (p = dbUser; *p;)
            *dpb++ = *p++;
    }
    if (dbPassword)
    {
        *dpb++ = isc_dpb_password;
        *dpb++ = strlen (dbPassword);
        for (p = dbPassword; *p;)
            *dpb++ = *p++;
    }
    dpb_length = dpb - dpb_buffer;

    gettimeofday(&startTime, 0);
    if (isc_attach_database (sv, 0, dbPath, &db_handle, dpb_length, dpb_buffer))
    {
        isc_print_status(sv);
        assert(0);
    }
    if (isc_start_transaction(sv, &tr_handle, 1, &db_handle, 0, 0))
    {
        isc_print_status(sv);
        assert(0);
    }
    gettimeofday(&endTime, 0);
    SEND_MSG_1("CONNECTED: %d\n", 1000000 * (endTime.tv_sec - startTime.tv_sec) + endTime.tv_usec - startTime.tv_usec, outputFd);
}

int ChildProcess::atCheckpoint()
{
    char buff[256];

    DEBUG_MSG("M: atCheckpoint()\n");

    do
    {
        if (!fgets(buff, 254, inputFd))
            if (ferror(inputFd) || feof(inputFd))
                ; /*assert(0);*/
        if (!buff[0])
            continue;
        if (buff[strlen(buff) - 1] == '\n')
            buff[strlen(buff) - 1] = 0;
        if (!buff[0])
            continue;
        DEBUG_MSG_2("M rcvd(%d): %s\n", pid, buff);
        if (!strcmp("READY", buff))
            break;
        if (!strncmp("CONNECTED: ", buff, 11))
            connectTime = atol(&buff[11]);
        if (!strncmp("ELAPSED: ", buff, 9))
        {
            printf("Time: %f\n", ((double)atol(&buff[9]))/1000000.0);
        }
    } while(1);

    return 1;
}

void ChildProcess::disconnectFromDb()
{
    ISC_STATUS sv[20];

    if (tr_handle != 0)
        isc_commit_transaction(sv, &tr_handle);

    if (db_handle != 0)
        isc_detach_database(sv, &db_handle);

    tr_handle = 0;
    db_handle = 0;
}

ChildProcess::~ChildProcess()
{
    if (outputFd != 0)
        fclose(outputFd);
    if (inputFd != 0)
        fclose(inputFd);
    delete [] dbPath;
    delete [] dbUser;
    delete [] dbPassword;
}
