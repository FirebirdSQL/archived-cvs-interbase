#include <netinfo/ni.h>
#include <assert.h>

#define CHECK_VAL(x, y) bailError = (x); if( bailError != 0 && bailError != (y)) return error(__LINE__);
#define CHECK(x) CHECK_VAL(x,0)
#define DEBUG(x, y) if (debug >= (y)) printf(x)
#define DEBUG1(x, y, z) if (debug >= (z)) printf((x), (y))

#define NI_PATH "/services"
#define NI_DIR "gds_db"
#define MAX_EXPECTED_PROPS 10
#define MAX_EXPECTED_VALS 10
#define EX_OFFSET(x) (expectedPropOffset[(x)].offset)
#define MATCH_LEN (MAX_EXPECTED_PROPS * (2 + MAX_EXPECTED_VALS) + 1)

ni_name expectedVals[] =
{
    "port", "3050", "",
    "protocol", "tcp", "tcp", "",
    "name", "gds_db", "",
    0
};

struct Prop_Tally
{
    int offset, numVals;
};

ni_status bailError;
int debug = 0;
int numExpectedProps = 0;
struct Prop_Tally expectedPropOffset[MAX_EXPECTED_PROPS + 1];
char valMatched[MATCH_LEN];

int printUsage(char *appName)
{
    printf("Usage:\n");
    printf("%s [-d]\n", appName);
    printf("\twhere the optional -d flag will just delete the entry from\n");
    printf("\tthe NetInfo DB instead of adding it.\n");
    return 0;
}

int error(int lineNum)
{
    if (debug > 0)
        printf("Error %d: %s, line %ld\n", bailError, ni_error(bailError), lineNum);
    return 1;
}

int matchExpectedProp(ni_name name)
{
    int i;
    for(i = 0; i < numExpectedProps; i++)
        if (ni_name_match(name, expectedVals[EX_OFFSET(i)]))
            return i;
    return -1;
}

int matchExpectedVal(int propOffset, ni_name val)
{
    int i;
    for(i = 0; i < expectedPropOffset[i].numVals; i++)
    {
        if ( (ni_name_match(val, expectedVals[1 + i + EX_OFFSET(propOffset)])) &&
            (valMatched[1 + i + EX_OFFSET(propOffset)] == 0) )
                 return 1 + i + EX_OFFSET(propOffset);
    }

    return -1;
}

void ReadConfiguration()
{
    int i, j = -1;

    for(i = 0; i < MAX_EXPECTED_PROPS; i++)
        expectedPropOffset[i].numVals = -2;
    for(i = 0; i < MATCH_LEN; i++)
        valMatched[i] = 0;

    expectedPropOffset[++j].offset = 0;
    valMatched[0] = -1;
    for(i = 0; expectedVals[i]; i++)
    {
        expectedPropOffset[j].numVals++;
        if (expectedVals[i][0] == 0)
        {
            valMatched[i] = valMatched[i+1] = -1;
            numExpectedProps++;
            expectedPropOffset[++j].offset = i + 1;
        }
    }
    assert(numExpectedProps <= MAX_EXPECTED_PROPS);

    if (debug >= 2)
    {
        printf("---Configuration Report---\n");
        printf("We are looking for %d properties in %s/%s as follows:\n", numExpectedProps, NI_PATH, NI_DIR);
        for(i = 0; i < numExpectedProps; i++)
        {
            printf("\t%s -", expectedVals[EX_OFFSET(i)]);
            for(j = 0; j < expectedPropOffset[i].numVals; j++)
                printf(" %s", expectedVals[EX_OFFSET(i) + j + 1]);
            printf("\n");
        }
        printf("\n");
    }
}

int main(int argc, char **argv)
{
    void *nidb;
    ni_id currDir, parentDir;
    ni_name valName;
    ni_namelist propNames, values, newValues;
    ni_index propNum, valNum;
    int redoDirectory = 0, propOffset, valOffset, i;
    ni_proplist newProps;
    ni_property newProp;
    int updateExisting = 1;
    int deleteOnly = 0;

    /* Check for command line parameters */
    if (argc > 2)
        return printUsage(argv[0]);
    if (2 == argc)
        if (!strcmp(argv[1], "-d"))
            deleteOnly = 1;
        else
            return printUsage(argv[0]);

    /* Load our configuration */
    ReadConfiguration();

    /* Start the real work */
    DEBUG("Opening up the NetInfo database...\n", 2);
    CHECK(ni_open(NULL, "/", &nidb));
    CHECK(ni_root(nidb, &currDir));
    DEBUG1("Looking for existing service entry for \"%s\"...\n", NI_DIR, 3);
    CHECK_VAL(ni_pathsearch(nidb, &currDir, NI_PATH "/" NI_DIR), 5);

    if (!bailError)
    {
        /* gds_db service entry already exists lets check to see if the
           entries match our configuration */
        if (deleteOnly)
        {
            CHECK(ni_pathsearch(nidb, &parentDir, NI_PATH ));
            CHECK(ni_destroy(nidb, &parentDir, currDir));
            return 0;
        }

        DEBUG("\tEntry exists.\n", 3);
        DEBUG1("Reading the service entries for \"%s\".\n", NI_DIR, 3);
        CHECK(ni_listprops(nidb, &currDir, &propNames));
        if (propNames.ni_namelist_len != numExpectedProps)
        {
            redoDirectory++;
            if (debug >= 1) printf("Invalid number of properties. Found %d, expected %d\n", propNames.ni_namelist_len, numExpectedProps);
        }

        /* Loop on all the properties */
        DEBUG("Verifying property entries...\n", 2);
        for(propNum = 0; propNum < propNames.ni_namelist_len; propNum++)
        {
            propOffset = matchExpectedProp(propNames.ni_namelist_val[propNum]);
            if (propOffset == -1)
            {
                DEBUG1("\tUnexpected property - %s\n", propNames.ni_namelist_val[propNum], 2);
                redoDirectory++;
                continue;
            }
            DEBUG1("\t%s -", propNames.ni_namelist_val[propNum], 2);
            CHECK(ni_readprop(nidb, &currDir, propNum, &values));

            for(valNum = 0; valNum < values.ni_namelist_len; valNum++)
            {
                valOffset = matchExpectedVal(propOffset, values.ni_namelist_val[valNum]);
                if (valOffset == -1)
                {
                    DEBUG1(" %s(UNKNOWN)", values.ni_namelist_val[valNum], 2);
                    redoDirectory++;
                }
                else
                {
                    DEBUG1(" %s", values.ni_namelist_val[valNum], 2);
                    valMatched[valOffset] = 1;
                }
            }
            DEBUG("\n", 2);
        }
        DEBUG("\n", 2);

        for(i = 0; i < numExpectedProps; i++)
        {
            if (valMatched[i] == 0)
            {
                redoDirectory++;
                DEBUG1("Failed to match value %s\n", expectedVals[i], 2);
            }
        }

        if (updateExisting && redoDirectory)
        {
            /* Something was wrong with the directory entry.
               We delete it completely here and let the fallthrough
               re-create it. */
            DEBUG1("Found %d reason(s) to rebuild NetInfo directory\n", redoDirectory, 2);
            DEBUG("Deleting " NI_PATH "/" NI_DIR " from the NetInfo Database\n\n", 1);
            CHECK(ni_pathsearch(nidb, &parentDir, NI_PATH ));
            CHECK(ni_destroy(nidb, &parentDir, currDir));
        }
        else
        {
            DEBUG(NI_PATH "/" NI_DIR " matches target configuration.  NO CHANGES MADE\n\n", 1);
            ni_free(nidb);
            return 0;
        }
    }
    else
    {
        DEBUG("\tentry DOES NOT exist.\n", 3);
        if (deleteOnly)
            return 0;
    }

    /* The gds_db entry does not exists, so create it */
    DEBUG1("Adding new services entry for \"%s\".\n", NI_DIR, 1);

    NI_INIT(&newProps);
    for ( propOffset = 0; propOffset < numExpectedProps; propOffset++)
    {
        NI_INIT(&newValues);
        for (valOffset = 0; valOffset < expectedPropOffset[propOffset].numVals;
                              valOffset++)
        {
            ni_namelist_insert(&newValues, expectedVals[1 +
                                 expectedPropOffset[propOffset].offset + valOffset],
                                 valOffset);
        }
        newProp.nip_name = expectedVals[EX_OFFSET(propOffset)];
        newProp.nip_val = newValues;
        ni_proplist_insert(&newProps, newProp, propOffset);
        ni_namelist_free(&newValues);
    }

    CHECK(ni_pathsearch(nidb, &parentDir, NI_PATH ));
    CHECK(ni_create(nidb, &parentDir, newProps, &currDir, -1));
    ni_proplist_free(&newProps);

    ni_free(nidb);
    DEBUG("Program terminated normally\n", 2);
    return 0;
}
