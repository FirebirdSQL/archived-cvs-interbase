#! /bin/sh

#------------------------------------------------------------------------
# add a service line in the (usually) /etc/services
# Here there are three cases, not found         => add service line,
#                             found             => do nothing
#

replaceLineInFile() {
    FileName=$1
    newLine=$2
    oldLine=$3

    if [ -z "$oldLine" ]
      then
        echo "$newLine" >> $FileName
    fi
}

#------------------------------------------------------------------------
#  Add new user and group


addFirebirdUser() {

    testStr=`grep firebird /etc/group`

    if [ -z "$testStr" ]
      then
        groupadd -g 84 -o -r firebird
    fi

    testStr=`grep firebird /etc/passwd`
    if [ -z "$testDir" ]
      then
        useradd -o -r -m -d $IBRootDir -s /bin/bash \
            -c "Firebird Database Administrator" -g firebird -u 84 firebird

        # >/dev/null 2>&1
    fi
}


#------------------------------------------------------------------------
#  Delete new user and group


deleteFirebirdUser() {

    userdel firebird
 #   groupdel firebird

}


#------------------------------------------------------------------------
#  changeXinetdServiceUser
#  Change the run user of the xinetd service

changeXinetdServiceUser() {

    InitFile=/etc/xinetd.d/firebird
    if [ -f $InitFile ]
      then
        ed -s $InitFile <<EOF
/	user	/s/=.*$/= $RunUser/g
w
q
EOF
    fi
}

#------------------------------------------------------------------------
#  Update inetd service entry
#  This just adds/replaces the service entry line

updateInetdEntry() {

    FileName=/etc/inetd.conf
    newLine="gds_db  stream  tcp     nowait.30000      $RunUser $IBBin/gds_inet_server gds_inet_server # InterBase Database Remote Server"
    oldLine=`grep "^gds_db" $FileName`

    replaceLineInFile "$FileName" "$newLine" "$oldLine"
}

#------------------------------------------------------------------------
#  Update xinetd service entry

updateXinetdEntry() {

    cp $IBRootDir/misc/firebird.xinetd /etc/xinetd.d/firebird
    changeXinetdServiceUser
}


#------------------------------------------------------------------------
#  Update inetd service entry
#  Check to see if we have xinetd installed or plain inetd.  Install differs
#  for each of them.

updateInetdServiceEntry() {

    if [ -d /etc/xinetd.d ]
      then
        updateXinetdEntry
    else
        updateInetdEntry
    fi

}

#------------------------------------------------------------------------
#  fixFilePermissions
#  Change the permissions to restrict access to server programs to
#  firebird group only.  This is MUCH better from a saftey point of
#  view than installing as root user, even if it requires a little
#  more work.


fixFilePermissions() {

    # Turn other access off.
    chmod -R o= $IBRootDir


    # Now fix up the mess.

    # fix up directories
    for i in `find $IBRootDir -print`
    do
        FileName=$i
        if [ -d $FileName ]
        then
            chmod o=rx $FileName
        fi
    done


    cd $IBBin


    # set up the defaults for bin
    for i in `ls`
      do
         chmod ug=rx,o=  $i
    done

    # User can run these programs, they need to talk to server though.
    # and they cannot actually create a database.


    chmod a=rx isql
    chmod a=rx qli

    # SUID is still needed for group direct access.  General users
    # cannot run though.
    for i in gds_lock_mgr gds_drop gds_inet_server
    do
        chmod ug=rx,o= $i
        chmod ug+s $i
    done


    cd $IBRootDir

    # Fix lock files
    for i in isc_init1 isc_lock1 isc_event1
      do
        FileName=$i.`hostname`
        chmod ug=rw,o= $FileName
      done


    chmod ug=rw,o= interbase.log

    chmod a=r interbase.msg
    chmod ug=rw,o= help/help.gdb
    chmod ug=rw,o= isc4.gdb


    # Set a default of read all files in includes

    cd include

    for i in `ls`
      do
         chmod a=r  $i
    done

    cd ..



    # Set a default of read all files in intl

    cd intl

    for i in `ls`
      do
         chmod a=r  $i
    done

    cd ..

    # Set a default of read all files in examples

    cd examples

    for i in `ls`
      do
         chmod a=r  $i
    done

    # make examples db's writable by group
    chmod ug=rw,o= *.gdb

}


#------------------------------------------------------------------------
#  fixFilePermissionsForRoot
#  This sets the file permissions up to what you need if you are
#  running the server as root user.  I hope to remove this mode
#  of running before the next version, since it's security level
#  is absolutely woeful.


fixFilePermissionsRoot() {

    # Turn other access off.
    chmod -R o= $IBRootDir

    # Now fix up the mess.

    # fix up directories
    for i in `find $IBRootDir -print`
    do
        FileName=$i
        if [ -d $FileName ]
        then
            chmod o=rx $FileName
        fi
    done


    cd $IBBin


    # set up the defaults for bin
    for i in `ls`
      do
         chmod o=rx  $i
    done


    # SUID is still needed for group direct access.  General users
    # cannot run though.
    for i in gds_lock_mgr gds_drop gds_inet_server
    do
        chmod ug+s $i
    done


    cd $IBRootDir

    # Set a default of read all files in includes

    cd include

    for i in `ls`
      do
         chmod a=r  $i
    done

    cd ..



    # Set a default of read all files in intl

    cd intl

    for i in `ls`
      do
         chmod a=r  $i
    done

    cd ..


    # Fix lock files
    for i in isc_init1 isc_lock1 isc_event1
      do
        FileName=$i.`hostname`
        chmod a=rw $FileName
      done


    chmod a=rw interbase.log

    chmod a=r interbase.msg
    chmod a=rw help/help.gdb
    chmod a=rw isc4.gdb


    # Set a default of read all files in examples

    cd examples

    for i in `ls`
      do
         chmod a=r  $i
    done

    # make examples db's writable by group
    chmod a=rw *.gdb

}

#------------------------------------------------------------------------
#  resetXinitdServer
#  Check for both inetd and xinetd, only one will actually be running.
#  depending upon your system.

resetInetdServer() {

    if [ -f /var/run/inetd.pid ]
      then
        kill -HUP `cat /var/run/inetd.pid`
    fi

    if [ -f /var/run/xinetd.pid ]
      then
        kill -HUP `cat /var/run/xinetd.pid`
    fi
}

#= Main Post ===============================================================

    IBRootDir=/opt/interbase
    IBBin=$IBRootDir/bin
    RunUser=root
#    RunUser=firebird

# Update /etc/services

FileName=/etc/services
newLine="gds_db          3050/tcp  # InterBase Database Remote Protocol"
oldLine=`grep "^gds_db" $FileName`

replaceLineInFile "$FileName" "$newLine" "$oldLine"

# Make links to libs

    ln -s ../../opt/interbase/lib/libgds.so.0 /usr/lib/libgds.so
    ln -s ../../opt/interbase/lib/libgds.a /usr/lib/libgds.a
    ln -s ../../opt/interbase/lib/libib_util.so /usr/lib/libib_util.so

    # add Firebird user
    if [ $RunUser = "firebird" ]
      then
        addFirebirdUser
    fi

    # Create Lock files
    cd $IBRootDir

    for i in isc_init1 isc_lock1 isc_event1
      do
        FileName=$i.`hostname`
        touch $FileName
      done

    # Create log
    touch interbase.log

    # Update ownership and SUID bits for programs.
    chown -R $RunUser.$RunUser $IBRootDir
#    fixFilePermissions
    fixFilePermissionsRoot

    # Update the /etc/inetd.conf or xinetd entry
    updateInetdServiceEntry


    # Get inetd to reread new init files.
    resetInetdServer

