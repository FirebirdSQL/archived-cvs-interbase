#! /bin/sh

# Script to copy install files from the build/transport area

# The guts of the tranfer of files and other directories

    if [ -d /opt/interbase ] 
      then 
        rm -fr /opt/interbase
    fi 
    mkdir -p /opt/interbase 
    mkdir /opt/interbase/bin 
    mkdir /opt/interbase/examples 
    mkdir /opt/interbase/help 
    mkdir /opt/interbase/include 
    mkdir /opt/interbase/intl 
    mkdir /opt/interbase/lib
    mkdir /opt/interbase/doc 
    mkdir /opt/interbase/UDF 
    mkdir /opt/interbase/misc 

    cp -R interbase /opt

#    (cd /opt/interbase; touch interbase.log; chmod u=rw,go= interbase.log)
#    (cd /opt/interbase; chmod uga+rw examples/*.gdb)
