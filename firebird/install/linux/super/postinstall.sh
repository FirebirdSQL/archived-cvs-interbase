#!/bin/sh

# The post install script for Firebird Classic


#------------------------------------------------------------------------
# Prompt for response, store result in Answer

Answer=""

AskQuestion() {
    Test=$1
    DefaultAns=$2
    echo -n "${1}"
    Answer="$DefaultAns"
    read Answer
}


#------------------------------------------------------------------------
# add a service line in the (usually) /etc/services or /etc/inetd.conf file
# Here there are three cases, not found         => add service line,
#                             found & different => ask user to check
#                             found & same      => do nothing
#                             

replaceLineInFile() {
    FileName=$1
    newLine=$2
    oldLine=$3

    if [ -z "$oldLine" ] 
      then
        echo "$newLine" >> $FileName

    elif [ "$oldLine" != "$newLine"  ]
      then
        echo ""
        echo "--- Warning ----------------------------------------------"
        echo ""
        echo "    In file $FileName found line: "
        echo "    $oldLine"
        echo "    Which differs from the expected line:"
        echo "    $newLine"
        echo ""

#        AskQuestion "Press return to update file or ^C to abort install"

        cat $FileName | grep -v "$oldLine" > ${FileName}.tmp
        mv ${FileName}.tmp $FileName
        echo "$newLine" >> $FileName
        echo "Updated."

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
#  changeInitPassword


changeInitPassword() {

    NewPasswd=$1

    InitFile=/etc/rc.d/init.d/firebird
    if [ -f $InitFile ]
      then
        ed $InitFile <<EOF
/ISC_PASSWORD/s/ISC_PASSWORD=.*/ISC_PASSWORD=$NewPasswd/g
w
q
EOF
    chmod u=rwx,g=rx,o= $InitFile

    fi
}


#------------------------------------------------------------------------
#  Unable to generate the password for the rpm, so put out a message 
#  instead


keepOrigDBAPassword() {

    DBAPasswordFile=$IBRootDir/SYSDBA.password
    
    NewPasswd='masterkey'
    echo "Firebird initial install password " > $DBAPasswordFile
    echo "for user SYSDBA is : $NewPasswd" >> $DBAPasswordFile

    echo "for install on `hostname` at time `date`" >> $DBAPasswordFile
    echo "You should change this password at the earliest oportunity" >> $DBAPasswordFile
    echo ""

    echo "(For superserver you will also want to check the password in the" >> $DBAPasswordFile
    echo "daemon init routine in the file /etc/rc.d/init.d/firebird)" >> $DBAPasswordFile
    echo "" >> $DBAPasswordFile
    echo "Your should password can be changed to a more suitable one using the" >> $DBAPasswordFile
    echo "/opt/interbase/bin/changeDBAPassword.sh script" >> $DBAPasswordFile
    echo "" >> $DBAPasswordFile

    chmod u=r,go= $DBAPasswordFile


}


#------------------------------------------------------------------------
#  Generate new sysdba password - this routine is used only in the 
#  rpm file not in the install acript.


generateNewDBAPassword() {

    DBAPasswordFile=$IBRootDir/SYSDBA.password
    
    NewPasswd=`/usr/bin/mkpasswd -l 8`
    if [ -z "$NewPasswd" ]
      then
        keepOrigDBAPassword
        return
    fi

    echo "Firebird generated password " > $DBAPasswordFile
    echo "for user SYSDBA is : $NewPasswd" >> $DBAPasswordFile
    echo "generated on `hostname` at time `date`" >> $DBAPasswordFile
    echo "(For superserver you will also want to check the password in the" >> $DBAPasswordFile
    echo "daemon init routine in the file /etc/rc.d/init.d/firebird)" >> $DBAPasswordFile
    echo "" >> $DBAPasswordFile
    echo "Your password can be changed to a more suitable one using the" >> $DBAPasswordFile
    echo "/opt/interbase/bin/changeDBAPassword.sh script" >> $DBAPasswordFile
    echo "" >> $DBAPasswordFile
    chmod u=r,go= $DBAPasswordFile

    $IBBin/gsec -user sysdba -password masterkey <<EOF
modify sysdba -pw $NewPasswd
EOF

    changeInitPassword "$NewPasswd"

}

#------------------------------------------------------------------------
#  Change sysdba password - this routine is interactive and is only 
#  used in the install shell script not the rpm one.


askUserForNewDBAPassword() {

    NewPasswd=""

    while [ -z "$NewPasswd" ]
      do
# If using a generated password
#         DBAPasswordFile=$IBRootDir/SYSDBA.password
#         NewPasswd=`mkpasswd -l 8`
#         echo "Password for SYSDBA on `hostname` is : $NewPasswd" > $DBAPasswordFile
#         chmod ga-rwx $DBAPasswordFile

          AskQuestion "Please enter new password for SYSDBA user: "
          NewPasswd=$Answer
          if [ ! -z "$NewPasswd" ]
            then
             $IBBin/gsec -user sysdba -password masterkey <<EOF
modify sysdba -pw $NewPasswd
EOF
              echo ""
              changeInitPassword "$NewPasswd"
          fi
          
      done
}


#------------------------------------------------------------------------
#  Change sysdba password - this routine is interactive and is only 
#  used in the install shell script not the rpm one.

#  On some systems the mkpasswd program doesn't appear and on others
#  there is another mkpasswd which does a different operation.  So if
#  the specific one isn't available then keep the original password.


changeDBAPassword() {

    if [ -z "$InteractiveInstall" ]
      then
        if [ -f /usr/bin/mkpasswd ]
            then
              generateNewDBAPassword
        else
              keepOrigDBAPassword
        fi
      else
        askUserForNewDBAPassword
    fi
}


#------------------------------------------------------------------------
#  fixFilePermissionsForSuper
#  Change the permissions to restrict access to server programs to 
#  firebird group only.  Since super runs as a server there is a lot
#  less trouble with suid things and this procedure is fairly straight
#  forward.


fixFilePermissionsForSuper() {

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
         chmod a=rx  $i
    done

    # These two should only be executed by firebird user.
    for i in ibguard ibserver
      do
        chmod u=rx,go= $i
      done
    
    # SUID is still needed for group direct access.  General users
    # cannot run though.
    for i in gds_lock_mgr
    do
        chmod ug=rx,o= $i
        chmod ug+s $i
    done


    cd $IBRootDir

    # Fix lock files
    for i in isc_init1 isc_lock1 isc_event1 isc_guard1
      do
        FileName=$i.`hostname`
        chmod ug=rw,o= $FileName
      done


    chmod u=rw,go= interbase.log

    chmod a=r interbase.msg
    chmod a=r README
    chmod ug=rw,o= help/help.gdb
    chmod ug=rw,o= isc4.gdb


    # Set a default of read all files in includes

	for i in include lib UDF intl misc
	  do
	      
        cd $i
        for j in `ls`
          do
            chmod a=r  $j
          done

        cd ..
      done

    # Set a default of read all files in examples

    cd examples

    for i in `ls`
      do
         chmod a=r  $i
    done

    # make examples db's writable by group
    chmod ug=rw,o=r *.gdb



}


#------------------------------------------------------------------------
# installInitdScript
# Everbody stores this one in a seperate location, so there is a bit of
# running around to actually get it for each packager.
# Update rcX.d with Firebird initd entries
# initd script for SuSE >= 7.2 is a part of RPM package

installInitdScript() {

# This is for RH and MDK specific

    if [ -e /etc/rc.d/init.d/functions ]
      then
        srcScript=firebird.init.d.mandrake
        initScript=/etc/rc.d/init.d/firebird

# SuSE specific

    elif [ -x /bin/fillup ]; then
#    elif [ -d /etc/init.d ]; then

# I'm not sure if this is enough to detect SuSE, but it works for now
# (Pavel I've changed it since /etc/init.d will match quite a few It would
# be nice of we could find a SuSE specific file we could use).

        srcScript=firebird.init.d.suse
        initScript=/etc/init.d/firebird
        ln -s ../../etc/init.d/firebird /usr/sbin/rcfirebird

# Generic...

    elif [ -d /etc/rc.d/init.d ]
      then
        srcScript=firebird.init.d.generic
        initScript=/etc/rc.d/init.d/firebird
    fi



    # Install the firebird init.d script
    cp  $IBRootDir/misc/$srcScript $initScript
    chown root:root $initScript
    chmod ug=rx,o= $initScript  # contains password hence no world read.



    # RedHat and Mandrake specific 
    if [ -x /sbin/chkconfig ]
      then
        /sbin/chkconfig --add firebird
    fi


    # Suse specific 
    if [ -x /sbin/insserv ]
      then
        /sbin/insserv /etc/init.d/firebird
    fi

    # More SuSE rc.config fillup
    if [ -x /bin/fillup ] 
      then
        /bin/fillup -q -d = etc/rc.config $IBRootDir/misc/rc.config.firebird
    fi
    
    if [ -d /etc/sysconfig ] 
      then
      cp $IBRootDir/misc/rc.config.firebird /etc/sysconfig/firebird
    fi

}

#------------------------------------------------------------------------
# startInetService
# Now that we've installed it start up the service.

startInetService() {

    initScript=/etc/init.d/firebird
    if [ ! -f $initScript ]
      then
        initScript=/etc/rc.d/init.d/firebird
    fi

    if [ -f $initScript ]
      then
        $initScript start
    fi
}


#------------------------------------------------------------------------
# UpdateHostsDotEquivFile
# The /etc/hosts.equiv file is needed to allow local access for super server
# from processes on the machine to port 3050 on the local machine.
# The two host names that are needed there are 
# localhost.localdomain and whatever hostname returns.

updateHostsDotEquivFile() {

    hostEquivFile=/etc/hosts.equiv

    if [ ! -f $hostEquivFile ]
      then
        touch $hostEquivFile
        chown root:root $hostEquivFile
        chmod u=rw,go=r $hostEquivFile
    fi

    newLine="localhost.localdomain"
    oldLine=`grep "$newLine" $hostEquivFile`
    replaceLineInFile "$hostEquivFile" "$newLine" "$oldLine"

    newLine="`hostname`"
    oldLine=`grep "$newLine" $hostEquivFile`
    replaceLineInFile "$hostEquivFile" "$newLine" "$oldLine"
    
}

    



#= Main Post ===============================================================

    # Make sure the links are in place 
    if [ ! -L /opt/interbase -a ! -d /opt/interbase ] 
      then 
    # Main link and... 
        ln -s $RPM_INSTALL_PREFIX/interbase /opt/interbase 
    fi 


    IBRootDir=/opt/interbase
    IBBin=$IBRootDir/bin
    RunUser=root
#    RunUser=firebird


    # Update /etc/services

    FileName=/etc/services
    newLine="gds_db          3050/tcp  # InterBase Database Remote Protocol"
    oldLine=`grep "^gds_db" $FileName`

    replaceLineInFile "$FileName" "$newLine" "$oldLine"


    # Add entries to host.equiv file
    updateHostsDotEquivFile


    # add Firebird user if required
    if [ $RunUser = "firebird" ]
      then
        addFirebirdUser
    fi

    # Set up Firebird for run with init.d
    installInitdScript


    # Create the ibmgr shell script.
    cd $IBBin

    cat > ibmgr <<EOF
#!/bin/sh
INTERBASE=$IBRootDir
export INTERBASE
exec \$INTERBASE/bin/ibmgr.bin \$@
EOF


    # Create Lock files
    cd $IBRootDir

    for i in isc_init1 isc_lock1 isc_event1 isc_guard1
      do
        FileName=$i.`hostname`
        touch $FileName
      done

    # Create log
    touch interbase.log


    # Update ownership and SUID bits for programs.
    chown -R $RunUser.$RunUser $IBRootDir

    fixFilePermissionsForSuper

    startInetService

    cd $IBRootDir
    # Change sysdba password
    #changeDBAPassword
    keepOrigDBAPassword
    
