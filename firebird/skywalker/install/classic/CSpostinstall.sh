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
#  Generate new sysdba password - this routine is used only in the 
#  rpm file not in the install acript.


generateNewDBAPassword() {

    DBAPasswordFile=$IBRootDir/SYSDBA.password
    NewPasswd=`mkpasswd -l 8`
    echo "Firebird generated password " > $DBAPasswordFile
    echo "for user SYSDBA is : $NewPasswd" >> $DBAPasswordFile
    echo "generated on `hostname` at time `date`" >> $DBAPasswordFile
    echo "(For superserver you will also want to check the password in the" >> $DBAPasswordFile
    echo "daemon init routine in the file /etc/rc.d/init.d/firebird)" >> $DBAPasswordFile
    echo "" >> $DBAPasswordFile
    echo "Your password can be changed to a more suitable one using the" >> $DBAPasswordFile
    echo "/opt/interbase/bin/gsec program as show below:" >> $DBAPasswordFile
    echo "" >> $DBAPasswordFile
    echo ">cd /opt/interbase" >> $DBAPasswordFile
    echo ">bin/gsec -user sysdba -password <password>" >> $DBAPasswordFile
    echo "GSEC>modify sysdba -pw <newpassword>" >> $DBAPasswordFile
    echo "GSEC>quit" >> $DBAPasswordFile
    chmod u=r,go= $DBAPasswordFile

    $IBBin/gsec -user sysdba -password masterkey <<EOF
modify sysdba -pw $NewPasswd
EOF

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
          fi
          
      done
}


#------------------------------------------------------------------------
#  Change sysdba password - this routine is interactive and is only 
#  used in the install shell script not the rpm one.


changeDBAPassword() {

    if [ -z "$InteractiveInstall" ]
      then
        generateNewDBAPassword
      else
        askUserForNewDBAPassword
    fi
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


    # Update /etc/services


    FileName=/etc/services
    newLine="gds_db          3050/tcp  # InterBase Database Remote Protocol"
    oldLine=`grep "^gds_db" $FileName`

    replaceLineInFile "$FileName" "$newLine" "$oldLine"



    # Update the /etc/inetd.conf


    FileName=/etc/inetd.conf
    newLine="gds_db  stream  tcp     nowait.30000      $RunUser $IBBin/gds_inet_server gds_inet_server # InterBase Database Remote Server"
    oldLine=`grep "^gds_db" $FileName`

    replaceLineInFile "$FileName" "$newLine" "$oldLine"


    # Update ownership and SUID bits for programs.

    chown -R $RunUser.$RunUser $IBRootDir

    cd $IBBin

    for i in gds_lock_mgr gds_drop gds_inet_server
      do
        chmod ug+s $i
      done


    # Get inetd to reread new init files.

    if [ -f /var/run/inetd.pid ]
      then
        kill -HUP `cat /var/run/inetd.pid`
    fi




    # Lock files
    # remember isc_guard1 in addition for super

    cd $IBRootDir

    for i in isc_init1 isc_lock1 isc_event1 
      do
        FileName=$i.`hostname`
        touch $FileName
        chmod uga+rw $FileName
      done

    touch interbase.log
    chmod uga+rw interbase.log



    # Change sysdba password

    changeDBAPassword



