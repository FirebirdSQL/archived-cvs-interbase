#! /bin/sh
#
# $Id$
#
# Contributor(s):
#
# Tom Coleman TMC Systems <tcoleman@autowares.com>
#

# set up env variables required for the make process such as 
# the username and password if they have not already been
# If we are doing a boot build having ISC_USER will disrupt the
# runningof gbak, making it require a security database isc4.gdb.
# which obviously doesn't exist as yet since we are trying to 
# restore it.


if [ -d porting ]
  then
    if [ ! -z "$ISC_PASSWORD"]
      then
        echo "The environment variables ISC_USER and ISC_PASSWORD will"
        echo "disrupt with the boot build process, you need to unset "
        echo "them before continuing"
    fi

fi


# On the other hand ISC_PASSWORD/ISC_USER is usually required for building
# in the normal build process where we have a version already installed.

if [ ! -d porting ]
  then
    if [ "$ISC_PASSWORD" = "" ]
      then
        ISC_USER="sysdba"
        ISC_PASSWORD="masterkey"
        export ISC_USER ISC_PASSWORD
    fi
fi


FBBuildRoot=`pwd`
export FBBuildRoot

FBNewBuild=$FBBuildRoot/interbase
export FBNewBuild

INTERBASE=$FBNewBuild
export INTERBASE

LD_LIBRARY_PATH=$FBNewBuild/lib:$FBBuildRoot/jrd:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

PATH=$PATH:$FBNewBuild/bin:.


