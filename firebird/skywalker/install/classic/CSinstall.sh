#!/bin/sh

# Script to install files from the build/transport area

#    cd InterBase


# A little bit of tidying up of some odd files not in the original build
# These files will exist in the CVS tree.  
# If this is a tar.gz install rather than the result of a build then
# We assume the files have already been copied here manually.


    if [ -z "$InteractiveInstall" ] 
      then
        ScriptsSrcDir=firebird/skywalker/install
        cp $ScriptsSrcDir/misc/README interbase/
    fi

# The guts of the tranfer of files to /opt and other directories

    if [ -d /opt/interbase ] 
      then 
        rm -rf /opt/interbase 
    fi 
    mkdir /opt/interbase 
    mkdir /opt/interbase/bin 
    mkdir /opt/interbase/examples 
    mkdir /opt/interbase/help 
    mkdir /opt/interbase/include 
    mkdir /opt/interbase/intl 
    mkdir /opt/interbase/lib 
    mkdir /opt/interbase/doc 
    mkdir /opt/interbase/UDF 


    cp -f interbase/bin/gds_inet_server /opt/interbase/bin/gds_inet_server 

    cp interbase/bin/gbak /opt/interbase/bin/gbak 
    cp interbase/bin/gdef /opt/interbase/bin/gdef 
    cp interbase/bin/gds_lock_print /opt/interbase/bin/gds_lock_print 
    cp interbase/bin/gds_drop /opt/interbase/bin/gds_drop 
    cp interbase/bin/gds_lock_mgr /opt/interbase/bin/gds_lock_mgr 
    cp interbase/bin/gds_pipe /opt/interbase/bin/gds_pipe 
    cp interbase/bin/gfix /opt/interbase/bin/gfix 
    cp interbase/bin/gpre /opt/interbase/bin/gpre 
    cp interbase/bin/gsec /opt/interbase/bin/gsec 
    cp interbase/bin/gsplit /opt/interbase/bin/gsplit 
    cp interbase/bin/gstat /opt/interbase/bin/gstat 
    cp interbase/bin/isc4.gbak /opt/interbase/bin/isc4.gbak 
    cp interbase/bin/isql /opt/interbase/bin/isql 
    cp interbase/bin/qli /opt/interbase/bin/qli 

    cp interbase/bin/CSchangeRunUser.sh /opt/interbase/bin
    cp interbase/bin/CSrestoreRootRunUser.sh /opt/interbase/bin
    cp interbase/bin/changeDBAPassword.sh /opt/interbase/bin

    cp interbase/examples/v5/*.[ceh] /opt/interbase/examples 
    cp interbase/examples/v5/*.sql /opt/interbase/examples 
    cp interbase/examples/v5/*.gbk /opt/interbase/examples 
    cp interbase/examples/v5/*.gdb /opt/interbase/examples 
    cp interbase/examples/v5/makefile /opt/interbase/examples 
    cp interbase/help/help.gbak /opt/interbase/help 
    cp interbase/help/help.gdb /opt/interbase/help 
    #cp -r interbase/doc /opt/interbase 
    cp interbase/interbase.msg /opt/interbase/interbase.msg 
    cp interbase/isc4.gdb /opt/interbase/isc4.gdb 
    cp interbase/isc_config /opt/interbase/isc_config

    cp -f interbase/include/gds.h /usr/include/gds.h 
    cp -f interbase/include/iberror.h /usr/include/iberror.h 
    cp -f interbase/include/ibase.h /usr/include/ibase.h 
    cp -f interbase/include/ib_util.h /usr/include/ib_util.h 

    cp interbase/include/gds.f /opt/interbase/include 
    cp interbase/include/gds.hxx /opt/interbase/include 
    cp interbase/include/*.h /opt/interbase/include 

    cp -f interbase/lib/gds.so /usr/lib/libgds.so.0 
    if [ -L /usr/lib/libgds.so ]
      then
        rm -f /usr/lib/libgds.so
    fi
    ln -s libgds.so.0 /usr/lib/libgds.so

    cp -f interbase/lib/gds.a /usr/lib/libgds.a 
    cp -f interbase/lib/ib_util.so /usr/lib/libib_util.so 
    cp -f interbase/lib/gds_pyxis.a /usr/lib/libgds_pyxis.a 

    cp interbase/intl/gdsintl /opt/interbase/intl/gdsintl 
    cp interbase/UDF/ib_udf /opt/interbase/UDF/ib_udf 

    cp interbase/services.isc /opt/interbase/services.isc
    cp interbase/README /opt/interbase/README

    # June 23 2000, 6:00AM 
    #TIMESTAMP="200006230600.00" 
    #cd /opt/interbase/ 
    #touch -t $TIMESTAMP `find . -print` 

