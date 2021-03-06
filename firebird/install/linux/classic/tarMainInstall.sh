
#  Install script for FirebirdSQL database engine
#  http://www.firebirdsql.org




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
# Prompt for yes or no answer - returns non-zero for no

AskYNQuestion() {
    while echo -n "${*} (y/n): "
    do
        read answer rest
        case $answer in
        [yY]*)
            return 0
            ;;
        [nN]*)
            return 1
            ;;
        *)
            echo "Please answer y or n"
            ;;
        esac
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
        exit
    fi
}

#------------------------------------------------------------------------
# Check for a previous install 


checkInstallUser() {

    if [ "`whoami`" != "root" ];
      then
        echo ""
        echo "--- Warning ----------------------------------------------"
        echo ""
        echo "    You need to be 'root' user to install"
        echo ""
        exit
    fi
}



#== Main Program ==========================================================


InteractiveInstall=1
export InteractiveInstall


checkInstallUser


echo "Firebird Classic XXXVERSIONXXX Installation"
echo ""
echo ""

AskQuestion "Press Enter to start installation or ^C to abort"


# Here we are installing from a install tar.gz file

if [ -e scripts ]
  then
    echo "Extracting install data"
#    runAndCheckExit "tar -xzf buildroot.tar.gz"

    runAndCheckExit "./scripts/preinstall.sh"
    runAndCheckExit "./scripts/tarinstall.sh"
    runAndCheckExit "./scripts/postinstall.sh"

#    rm -rf interbase
fi

echo "Install completed"

