#! /bin/sh

# Script to copy install files from the build/transport area

BuildSrcDir=firebird/install/linux
TargetDir=buildroot

FBRootDir=opt/interbase
TargetFBRootDir=$TargetDir/$FBRootDir



#------------------------------------------------------------------------
#  copyFiles
# This function copies all the files for a classic distribution into a
# directory heirachy mirroring the installation.

copyFiles() {
# The guts of the tranfer of files and other directories

    if [ -d $TargetDir ]
      then 
        rm -fr $TargetDir
    fi 
    mkdir $TargetDir
    mkdir $TargetDir/opt
    mkdir $TargetFBRootDir 
    mkdir $TargetFBRootDir/bin 
    mkdir $TargetFBRootDir/examples 
    mkdir $TargetFBRootDir/help 
    mkdir $TargetFBRootDir/include 
    mkdir $TargetFBRootDir/intl 
    mkdir $TargetFBRootDir/lib
    mkdir $TargetFBRootDir/doc 
    mkdir $TargetFBRootDir/UDF 
    mkdir $TargetFBRootDir/misc
    mkdir $TargetDir/etc 
#    mkdir $TargetDir/etc/init.d
#    mkdir $TargetDir/var
#    mkdir $TargetDir/var/adm
#    mkdir $TargetDir/var/adm/fillup-templates

    mkdir -p $TargetDir/usr/sbin
    mkdir -p $TargetDir/usr/lib
    mkdir -p $TargetDir/usr/include

    cp interbase/bin/gbak $TargetFBRootDir/bin/gbak 
    cp interbase/bin/gdef $TargetFBRootDir/bin/gdef 
#    cp interbase/bin/gds_inet_server $TargetFBRootDir/bin/gds_inet_server
    cp interbase/bin/gds_lock_print $TargetFBRootDir/bin/gds_lock_print
    cp interbase/bin/gds_lock_mgr $TargetFBRootDir/bin/gds_lock_mgr
#    cp interbase/bin/gds_pipe $TargetFBRootDir/bin/gds_pipe
#    cp interbase/bin/gds_drop $TargetFBRootDir/bin/gds_drop
    cp interbase/bin/gfix $TargetFBRootDir/bin/gfix
    cp interbase/bin/gpre $TargetFBRootDir/bin/gpre 
    cp interbase/bin/gsec $TargetFBRootDir/bin/gsec 
    cp interbase/bin/gsplit $TargetFBRootDir/bin/gsplit 
    cp interbase/bin/gstat $TargetFBRootDir/bin/gstat 
    cp interbase/bin/isc4.gbak $TargetFBRootDir/bin/isc4.gbak 
    cp interbase/bin/isql $TargetFBRootDir/bin/isql
    cp interbase/bin/qli $TargetFBRootDir/bin/qli
    cp interbase/bin/ibmgr.bin $TargetFBRootDir/bin/ibmgr.bin
    cp $BuildSrcDir/misc/ibmgr $TargetFBRootDir/bin/ibmgr
    cp interbase/bin/ibserver $TargetFBRootDir/bin/ibserver
    cp interbase/bin/ibguard $TargetFBRootDir/bin/ibguard

    cp interbase/examples/v5/*.[ceh] $TargetFBRootDir/examples 
    cp interbase/examples/v5/*.sql $TargetFBRootDir/examples 
    cp interbase/examples/v5/*.gbk $TargetFBRootDir/examples 
    cp interbase/examples/v5/*.gdb $TargetFBRootDir/examples 
    cp interbase/examples/v5/makefile $TargetFBRootDir/examples 
    cp interbase/help/help.gbak $TargetFBRootDir/help 
    cp interbase/help/help.gdb $TargetFBRootDir/help 
#	echo "Commented out cp of doc directory"
    cp -r $BuildSrcDir/doc $TargetFBRootDir 
    cp interbase/interbase.msg $TargetFBRootDir/interbase.msg 
    cp interbase/isc4.gdb $TargetFBRootDir/isc4.gdb 
    cp $BuildSrcDir/misc/isc_config $TargetFBRootDir/isc_config


    cp interbase/include/gds.f $TargetFBRootDir/include 
#    cp interbase/include/gds.hxx $TargetFBRootDir/include 
    cp interbase/include/*.h $TargetFBRootDir/include 

    cp -f interbase/lib/gds.so.1 $TargetFBRootDir/lib/libgds.so.0 
    if [ -L $TargetFBRootDir/lib/libgds.so ]
      then
        rm -f $TargetFBRootDir/lib/libgds.so
    fi
    ln -s libgds.so.0 $TargetFBRootDir/lib/libgds.so

#    cp -f interbase/lib/gds.a $TargetFBRootDir/lib/libgds.a
    cp -f interbase/lib/ib_util.so $TargetFBRootDir/lib/libib_util.so 
#    cp -f interbase/lib/gds_pyxis.a $TargetFBRootDir/lib/libgds_pyxis.a 

    cp interbase/intl/gdsintl $TargetFBRootDir/intl/gdsintl 
    cp interbase/UDF/ib_udf $TargetFBRootDir/UDF/ib_udf 

    cp $BuildSrcDir/misc/README $TargetFBRootDir/README
    cp $BuildSrcDir/misc/SSchangeRunUser.sh $TargetFBRootDir/bin
    cp $BuildSrcDir/misc/SSrestoreRootRunUser.sh $TargetFBRootDir/bin
    cp $BuildSrcDir/misc/changeDBAPassword.sh $TargetFBRootDir/bin

#    cp $BuildSrcDir/misc/README.CZ $TargetFBRootDir/README.CZ

    cp  $BuildSrcDir/misc/rc.config.firebird $TargetFBRootDir/misc
    cp  $BuildSrcDir/misc/firebird.init.d.generic $TargetFBRootDir/misc
    cp  $BuildSrcDir/misc/firebird.init.d.mandrake $TargetFBRootDir/misc
    cp  $BuildSrcDir/misc/firebird.init.d.suse $TargetFBRootDir/misc

    ln -s ../../$FBRootDir/lib/libgds.so.0 $TargetDir/usr/lib/libgds.so
    ln -s ../../$FBRootDir/lib/libgds.so.0 $TargetDir/usr/lib/libgds.so.0
    ln -s ../../$FBRootDir/lib/libgds.a $TargetDir/usr/lib/libgds.a
    ln -s ../../$FBRootDir/lib/libib_util.so $TargetDir/usr/lib/libib_util.so

# link include files to /usr/include 
	for i in gds.h iberror.h ibase.h ib_util.h
	   do
		   ln -s ../../$FBRootDir/include/$i $TargetDir/usr/include/$i
	   done

    (cd $TargetFBRootDir; touch interbase.log;)

#     chmod u=rw,go= interbase.log)
#    (cd $TargetFBRootDir; chmod uga+rw examples/*.gdb)

#    chown -R root:root $TargetDir
    
}


#=== MAIN ====================================================================


copyFiles

