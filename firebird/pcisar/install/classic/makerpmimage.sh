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
    mkdir $TargetDir/opt
    mkdir $TargetDir/opt/interbase 
    mkdir $TargetDir/opt/interbase/bin 
    mkdir $TargetDir/opt/interbase/examples 
    mkdir $TargetDir/opt/interbase/help 
    mkdir $TargetDir/opt/interbase/include 
    mkdir $TargetDir/opt/interbase/intl 
    mkdir $TargetDir/opt/interbase/lib
    mkdir $TargetDir/opt/interbase/doc 
    mkdir $TargetDir/opt/interbase/UDF 
    mkdir $TargetDir/opt/interbase/misc
    mkdir $TargetDir/etc 
    mkdir $TargetDir/etc/init.d
    mkdir $TargetDir/var
    mkdir $TargetDir/var/adm
    mkdir $TargetDir/var/adm/fillup-templates
    mkdir $TargetDir/usr
    mkdir $TargetDir/usr/sbin
    mkdir $TargetDir/usr/lib

    cp interbase/bin/gbak $TargetDir/opt/interbase/bin/gbak 
    cp interbase/bin/gdef $TargetDir/opt/interbase/bin/gdef 
    cp interbase/bin/gds_inet_server $TargetDir/opt/interbase/bin/gds_inet_server
    cp interbase/bin/gds_lock_print $TargetDir/opt/interbase/bin/gds_lock_print
    cp interbase/bin/gds_lock_mgr $TargetDir/opt/interbase/bin/gds_lock_mgr
    cp interbase/bin/gds_pipe $TargetDir/opt/interbase/bin/gds_pipe
    cp interbase/bin/gds_drop $TargetDir/opt/interbase/bin/gds_drop
    cp interbase/bin/gfix $TargetDir/opt/interbase/bin/gfix
    cp interbase/bin/gpre $TargetDir/opt/interbase/bin/gpre 
    cp interbase/bin/gsec $TargetDir/opt/interbase/bin/gsec 
    cp interbase/bin/gsplit $TargetDir/opt/interbase/bin/gsplit 
    cp interbase/bin/gstat $TargetDir/opt/interbase/bin/gstat 
    cp interbase/bin/isc4.gbak $TargetDir/opt/interbase/bin/isc4.gbak 
    cp interbase/bin/isql $TargetDir/opt/interbase/bin/isql
    cp interbase/bin/qli $TargetDir/opt/interbase/bin/qli

    cp interbase/examples/v5/*.[ceh] $TargetDir/opt/interbase/examples 
    cp interbase/examples/v5/*.sql $TargetDir/opt/interbase/examples 
    cp interbase/examples/v5/*.gbk $TargetDir/opt/interbase/examples 
    cp interbase/examples/v5/*.gdb $TargetDir/opt/interbase/examples 
    cp interbase/examples/v5/makefile $TargetDir/opt/interbase/examples 
    cp interbase/help/help.gbak $TargetDir/opt/interbase/help 
    cp interbase/help/help.gdb $TargetDir/opt/interbase/help 
    cp -r $BuildSrcDir/doc $TargetDir/opt/interbase 
    cp interbase/interbase.msg $TargetDir/opt/interbase/interbase.msg 
    cp interbase/isc4.gdb $TargetDir/opt/interbase/isc4.gdb 
    cp $BuildSrcDir/misc/isc_config $TargetDir/opt/interbase/isc_config

    cp $BuildSrcDir/misc/whatsnew.txt $TargetDir/opt/interbase/whatsnew.txt

    cp interbase/include/gds.f $TargetDir/opt/interbase/include 
    cp interbase/include/gds.hxx $TargetDir/opt/interbase/include 
    cp interbase/include/*.h $TargetDir/opt/interbase/include 

    cp -f interbase/lib/gds.so $TargetDir/opt/interbase/lib/libgds.so.0 
    if [ -L $TargetDir/opt/interbase/lib/libgds.so ]
      then
        rm -f $TargetDir/opt/interbase/lib/libgds.so
    fi
    ln -s libgds.so.0 $TargetDir/opt/interbase/lib/libgds.so

    cp -f interbase/lib/gds.a $TargetDir/opt/interbase/lib/libgds.a
    cp -f interbase/lib/ib_util.so $TargetDir/opt/interbase/lib/libib_util.so 
#    cp -f interbase/lib/gds_pyxis.a $TargetDir/opt/interbase/lib/libgds_pyxis.a 

    cp interbase/intl/gdsintl $TargetDir/opt/interbase/intl/gdsintl 
    cp interbase/UDF/ib_udf $TargetDir/opt/interbase/UDF/ib_udf 

    cp interbase/services.isc $TargetDir/opt/interbase/services.isc 


    cp $BuildSrcDir/misc/README $TargetDir/opt/interbase/README
    cp $BuildSrcDir/misc/CSchangeRunUser.sh $TargetDir/opt/interbase/bin
    cp $BuildSrcDir/misc/CSrestoreRootRunUser.sh $TargetDir/opt/interbase/bin
    cp $BuildSrcDir/misc/changeDBAPassword.sh $TargetDir/opt/interbase/bin

#    cp $BuildSrcDir/misc/README.CZ $TargetDir/opt/interbase/README.CZ

    cp  $BuildSrcDir/misc/firebird.xinetd $TargetDir/opt/interbase/misc

    ln -s ../../opt/interbase/lib/libgds.so.0 $TargetDir/usr/lib/libgds.so
    ln -s ../../opt/interbase/lib/libgds.a $TargetDir/usr/lib/libgds.a
    ln -s ../../opt/interbase/lib/libib_util.so $TargetDir/usr/lib/libib_util.so

    (cd $TargetDir/opt/interbase; touch interbase.log; chmod u=rw,go= interbase.log)
    (cd $TargetDir/opt/interbase; chmod uga+rw examples/*.gdb)

    chown -R root:root $TargetDir
    