#! /bin/sh

# Script to copy install files from the build/transport area

BuildSrcDir=firebird/pcisar/install
TargetDir=buildroot

# The guts of the tranfer of files and other directories

    if [ -d $TargetDir ] 
      then 
        rm -fr $TargetDir
    fi 
    mkdir $TargetDir
    mkdir $TargetDir/interbase 
    mkdir $TargetDir/interbase/bin 
    mkdir $TargetDir/interbase/examples 
    mkdir $TargetDir/interbase/help 
    mkdir $TargetDir/interbase/include 
    mkdir $TargetDir/interbase/intl 
    mkdir $TargetDir/interbase/lib
    mkdir $TargetDir/interbase/doc 
    mkdir $TargetDir/interbase/UDF 
    mkdir $TargetDir/interbase/misc 
    mkdir $TargetDir/scripts 

    cp interbase/bin/gbak $TargetDir/interbase/bin/gbak 
    cp interbase/bin/gdef $TargetDir/interbase/bin/gdef 
    cp interbase/bin/gds_lock_print $TargetDir/interbase/bin/gds_lock_print 
    cp interbase/bin/gds_lock_mgr $TargetDir/interbase/bin/gds_lock_mgr 
    cp interbase/bin/gfix $TargetDir/interbase/bin/gfix 
    cp interbase/bin/gpre $TargetDir/interbase/bin/gpre 
    cp interbase/bin/gsec $TargetDir/interbase/bin/gsec 
    cp interbase/bin/gsplit $TargetDir/interbase/bin/gsplit 
    cp interbase/bin/gstat $TargetDir/interbase/bin/gstat 
    cp interbase/bin/isc4.gbak $TargetDir/interbase/bin/isc4.gbak 
    cp interbase/bin/isql $TargetDir/interbase/bin/isql
    cp interbase/bin/qli $TargetDir/interbase/bin/qli 
    cp interbase/bin/ibmgr.bin $TargetDir/interbase/bin/ibmgr.bin 
    cp interbase/bin/ibserver $TargetDir/interbase/bin/ibserver 
    cp interbase/bin/ibguard $TargetDir/interbase/bin/ibguard 

    cp interbase/examples/v5/*.[ceh] $TargetDir/interbase/examples 
    cp interbase/examples/v5/*.sql $TargetDir/interbase/examples 
    cp interbase/examples/v5/*.gbk $TargetDir/interbase/examples 
    cp interbase/examples/v5/*.gdb $TargetDir/interbase/examples 
    cp interbase/examples/v5/makefile $TargetDir/interbase/examples 
    cp interbase/help/help.gbak $TargetDir/interbase/help 
    cp interbase/help/help.gdb $TargetDir/interbase/help 
    cp interbase/interbase.msg $TargetDir/interbase/interbase.msg 
    cp interbase/isc4.gdb $TargetDir/interbase/isc4.gdb 
    cp $BuildSrcDir/misc/isc_config $TargetDir/interbase/isc_config

    cp $BuildSrcDir/misc/whatsnew.txt $TargetDir/interbase/whatsnew.txt

    cp interbase/include/gds.f $TargetDir/interbase/include 
    cp interbase/include/gds.hxx $TargetDir/interbase/include 
    cp interbase/include/*.h $TargetDir/interbase/include 

    cp -r $BuildSrcDir/doc $TargetDir/interbase

    cp -f interbase/lib/gds.so.1 $TargetDir/interbase/lib/libgds.so.0 
    if [ -L $TargetDir/interbase/lib/libgds.so ]
      then
        rm -f $TargetDir/interbase/lib/libgds.so
    fi
    ln -s libgds.so.0 $TargetDir/interbase/lib/libgds.so
    cp -f interbase/lib/ib_util.so $TargetDir/interbase/lib/libib_util.so 

    cp interbase/intl/gdsintl $TargetDir/interbase/intl/gdsintl 
    cp interbase/UDF/ib_udf $TargetDir/interbase/UDF/ib_udf 

    cp interbase/services.isc $TargetDir/interbase/services.isc 
    #cp interbase/license.txt $TargetDir/interbase/license.txt 
    #cp interbase/license.html $TargetDir/interbase/license.html 
    #cp interbase/ReleaseNotes.pdf $TargetDir/interbase/ReleaseNotes.pdf 

    cp $BuildSrcDir/misc/README $TargetDir/interbase/README
    cp $BuildSrcDir/misc/SSchangeRunUser.sh $TargetDir/interbase/bin
    cp $BuildSrcDir/misc/SSrestoreRootRunUser.sh $TargetDir/interbase/bin
    cp $BuildSrcDir/misc/changeDBAPassword.sh $TargetDir/interbase/bin

#    cp $BuildSrcDir/misc/README.CZ $TargetDir/interbase/README.CZ
    cp $BuildSrcDir/misc/rc.config.firebird $TargetDir/scripts/rc.config.firebird
#    cp $BuildSrcDir/misc/firebird $TargetDir/scripts/firebird
#    chmod ug+rx,o= $TargetDir/scripts/firebird
    cp $BuildSrcDir/misc/ibmgr $TargetDir/interbase/bin

    cp  $BuildSrcDir/misc/firebird.init.d.suse $TargetDir/interbase/misc
    cp  $BuildSrcDir/misc/firebird.init.d.generic $TargetDir/interbase/misc
    cp  $BuildSrcDir/misc/firebird.init.d.mandrake $TargetDir/interbase/misc

    (cd $TargetDir/interbase/bin; chmod u=rwx,go=rx *; chmod u=rwx,go= ibguard ibserver)
    (cd $TargetDir/interbase; touch interbase.log; chmod u=rw,go= interbase.log)
    (cd $TargetDir/interbase; chmod uga+rw examples/*.gdb)

    cp $BuildSrcDir/super/tarpreinstall.sh $TargetDir/scripts/preinstall.sh
    cp $BuildSrcDir/super/tarinstall.sh $TargetDir/scripts/install.sh
    cp $BuildSrcDir/super/tarpostinstall.sh $TargetDir/scripts/postinstall.sh
    cp $BuildSrcDir/super/tarmaininstall.sh $TargetDir/install.sh

    chown -R root:root $TargetDir 
    