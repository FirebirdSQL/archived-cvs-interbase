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

# Update /etc/services

FileName=/etc/services
newLine="gds_db          3050/tcp  # InterBase Database Remote Protocol"
oldLine=`grep "^gds_db" $FileName`

replaceLineInFile "$FileName" "$newLine" "$oldLine"

# Make links to libs

    ln -s ../../opt/interbase/lib/libgds.so.0 /usr/lib/libgds.so
    ln -s ../../opt/interbase/lib/libib_util.so /usr/lib/libib_util.so

# Update rcX.d with Firebird initd entries

if [ -d /etc/init.d ]; then
    cp /opt/interbase/misc/firebird.init.d.suse /etc/init.d/firebird
    ln -s ../../etc/init.d/firebird /usr/sbin/rcfirebird
    /sbin/insserv /etc/init.d/firebird
fi

if [ -e /etc/rc.d/init.d/functions ]; then
    cp /opt/interbase/misc/firebird.init.d.mandrake /etc/rc.d/init.d/firebird
    ln -s ../../etc/rc.d/init.d/firebird /usr/sbin/rcfirebird
    /sbin/chkconfig --add firebird
    
else

  if [ -d /etc/rc.d/init.d ]; then
      cp /opt/interbase/misc/firebird.init.d.generic /etc/rc.d/init.d/firebird
      ln -s ../../etc/rc.d/init.d/firebird /usr/sbin/rcfirebird
      /sbin/chkconfig --add firebird
  fi
  
fi

# SuSE rc.config fillup

if [ -x /bin/fillup ] ; then
  cp scripts/rc.config.firebird /var/adm/fillup-templates/rc.config.firebird
  /bin/fillup -q -d = /etc/rc.config /var/adm/fillup-templates/rc.config.firebird
else
  echo "ERROR: fillup not found."
  echo "If you're using SuSE, this should not happen. Please compare"
  echo "/etc/rc.config and /var/adm/fillup-templates/rc.config.firebird and update by hand."
  echo "On other distributions this IS NOT an error."
fi

