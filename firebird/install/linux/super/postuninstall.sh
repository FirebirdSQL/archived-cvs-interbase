#!/bin/sh

# The post uninstall routine for Firebird Classic.


#------------------------------------------------------------------------
# remove line from config file if it exists in it.

removeLineFromFile() {
    FileName=$1
    oldLine=$2

    if [ ! -z "$oldLine" ] 
      then
        cat $FileName | grep -v "$oldLine" > ${FileName}.tmp
        mv ${FileName}.tmp $FileName
        echo "Updated."

    fi
}


#= Main PostUn ============================================================

# I don't think this is needed anymore.
#    if [ -L /usr/lib/libgds.so ] 
#      then 
#        rm /usr/lib/libgds.so 
#    fi 

    if [ "$1"=0 ] 
      then 

        # Lose the gds_db line from /etc/services 

        FileName=/etc/services
        oldLine=`grep "^gds_db" $FileName`
        removeLineFromFile "$FileName" "$oldLine"


        # Remove /usr/sbin/rcfirebird symlink

        rm /usr/sbin/rcfirebird
        
        # Remove initd script
        
        if [ -e /etc/init.d/firebird ]; then
            rm /etc/init.d/firebird
        fi
            
        if [ -e /etc/rc.d/init.d/firebird ]; then
            rm /etc/rc.d/init.d/firebird
            fi
            
        if [ -x sbin/insserv ] ; then
            sbin/insserv /etc/init.d/
        fi
        
        if [ -x sbin/chkconfig ] ; then
            sbin/chkconfig --del firebird
        fi

    fi
