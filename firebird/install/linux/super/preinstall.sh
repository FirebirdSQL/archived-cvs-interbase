#!/bin/sh


# The pre install routine for Firebird Classic


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
#  stop super server if it is running 
#  Also will only stop firebird, since that has the init script


stopServerIfRunning() {

    checkString=`ps -efww| egrep "(ibserver|ibguard)" |grep -v grep`

    if [ ! -z "$checkString" ] 
      then
        if [ -f /etc/init.d/firebird ]
          then
            /etc/init.d/firebird stop
        elif [ -f /etc/rc.d/init.d/firebird ]
          then
            /etc/rc.d/init.d/firebird stop
        fi
    fi
}

#------------------------------------------------------------------------
#  stop server if it is running


checkIfServerRunning() {


    stopServerIfRunning

# Check is server is being actively used.

    checkString=`ps -efww| egrep "(ibserver|ibguard)" |grep -v grep`

    if [ ! -z "$checkString" ] 
      then
        echo "An instance of the Firebird/InterBase Super server seems to be running." 
        echo "(the ibserver or ibguard process was detected running on your system)"
        echo "Please quit all Firebird applications and then proceed"
        exit -1 
    fi

    checkString=`ps -efww| egrep "(gds_inet_server|gds_pipe)" |grep -v grep`

    if [ ! -z "$checkString" ] 
      then
        echo "An instance of the Firebird/InterBase classic server seems to be running." 
        echo "(the gds_inet_server or gds_pipe process was detected running on your system"
        echo "Please quit all Firebird applications and then proceed." 
        exit -1 
    fi


    checkString=`netstat -an | egrep '3050.*LISTEN'`

    if [ ! -z "$checkString" ] 
      then
        echo "An instance of the Firebird/InterBase server seems to be running." 
        echo "(netstat -an reports a process is already listening on port 3050)"
        echo "Please quit all Firebird applications and then proceed." 
        exit -1 
    fi


# Stop lock manager if it is the only thing running.

    for i in `ps -efww | grep "gds_lock_mgr" | grep -v "grep" | awk '{print $2}' `
     do
        kill $i
     done

}

#------------------------------------------------------------------------
# Run process and check status


runAndCheckExit() {
    Cmd=$*

#    echo $Cmd
    $Cmd

    ExitCode=$?

    if [ $ExitCode -ne 0 ]
      then
        echo "Install aborted: The command $Cmd "
        echo "                 failed with error code $ExitCode"
        exit $ExitCode
    fi
}


#------------------------------------------------------------------------
#  Display message if this is being run interactively.


displayMessage() {

    msgText=$1
    if [ ! -z "$InteractiveInstall" ]
      then
        echo $msgText
    fi
}


#------------------------------------------------------------------------
#  Archive any existing prior installed files.
#  The 'cd' stuff is to avoid the "leading '/' removed message from tar.
#  for the same reason the DestFile is specified without the leading "/"


archivePriorInstallSystemFiles() {

    oldPWD=`pwd`
    archiveFileList=""

    cd /


    DestFile="opt/interbase"
    if [ -e "$DestFile"  ]
      then
        echo ""
        echo ""
        echo ""
        echo "--- Warning ----------------------------------------------"
        echo "    The installation target directory: $IBRootDir"
        echo "    Already contains a prior installation of InterBase/Firebird."
        echo "    This and files found in /usr/include and /usr/lib will be"
        echo "    archived in the file : ${ArchiveMainFile}"
        echo "" 

        if [ ! -z "$InteractiveInstall" ]
          then
            AskQuestion "Press return to continue or ^C to abort"
        fi

        if [ -e $DestFile ]
          then
            archiveFileList="$archiveFileList $DestFile"
        fi
    fi


    for i in gds.h ibase.h iberror.h ib_util.h
      do
        DestFile=usr/include/$i
        if [ -e $DestFile ]
          then
            archiveFileList="$archiveFileList $DestFile"
        fi
      done

    for i in gds_pyxis.a gds.a libgds.so.0 libgds.so libib_util.so libgds.a
      do
        DestFile=usr/lib/$i
        if [ -e $DestFile ]
          then
            archiveFileList="$archiveFileList $DestFile"
        fi
      done

    for i in usr/sbin/rcfirebird etc/init.d/firebird etc/rc.d/init.d/firebird
      do
        DestFile=$i
        if [ -e $DestFile ]
          then
            archiveFileList="$archiveFileList $DestFile"
        fi
      done

      if [ ! -z "$archiveFileList" ]
        then

          displayMessage "Archiving..."

          runAndCheckExit "tar -czf $ArchiveMainFile $archiveFileList"


          displayMessage "Done."
          displayMessage "Deleting..."

          for i in $archiveFileList
            do
              rm -rf $i
            done

          displayMessage "Done."

      fi
    cd $oldPWD

}


#------------------------------------------------------------------------
#  Check for installed RPM package

# (Pavel I've left this in since originally I could test for other packages,
# even if they did not conflict with current ones, ie we can test InterBase
# and CS/SS  The package manager does not allow it currently but I've left
# this in in case that sort of thing gets allowed again

checkForRPMInstall() {
    PackageName=$1

    rpm -q $PackageName
    STATUS=$? 
    if [ $STATUS -eq 0 ]
      then 
        echo "Previous version of $PackageName is detected on your system." 
        echo "this will conflict with the current install of Firebird"
        echo "Please unistall the previous version `rpm -q $PackageName` and then proceed." 
        exit $STATUS 
    fi 

}



#= Main Pre ================================================================

    IBRootDir=/opt/interbase
    IBBin=$IBRootDir/bin
    ArchiveDateTag=`date +"%Y%m%d_%H%M"`
    ArchiveMainFile="${IBRootDir}_${ArchiveDateTag}.tar.gz"



# Ok so any of the following packages are a problem
# these don't work at least in the latest rpm manager, since it 
# has the rpm database locked and it fails.

#    checkForRPMInstall InterBase
#    checkForRPMInstall FirebirdCS
#    checkForRPMInstall FirebirdSS


    checkIfServerRunning

# Failing that we archive any files we find

    archivePriorInstallSystemFiles


