#!/bin/sh
  
if [ -z "`make -s ROOT=\"$1\" installpath`" ]; then
    echo "######################  ERROR  ###################"
    echo "Couldn't locate an existing Firebird install"
    echo "Firebird must be installed before you can use this source"
    echo "to build it.  Please visit the Firebird website"
    echo "(www.firebird.sourceforge.net) to download an installer."
    echo "The compliation will be aborted"
    echo "##################################################"
    exit 1
fi
if [ -f `./binpath`/gpre -a -f `./binpath`/gds_lock_mgr ]; then
    exit 0;
fi
echo "Couldn't find the gpre and/or gds_lock_mgr application in your"
echo "firebird installation. You have an incomplete installation."
echo "Please reinstall."
exit 1;
