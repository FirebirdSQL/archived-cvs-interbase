# The contents of this file are subject to the Interbase Public
# License Version 1.0 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy
# of the License at http://www.Inprise.com/IPL.html
#
# Software distributed under the License is distributed on an
# "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
# or implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code was created by Inprise Corporation
# and its predecessors. Portions created by Inprise Corporation are
# Copyright (C) Inprise Corporation.
#
# All Rights Reserved.
# Contributor(s): ______________________________________.
# $Id$
#
# 29-Nov-2001 PR
# Moved defines of ISC_MAJOR_VER etc. to here, from license.h
# Removed defines of WIN_MAJOR_VER etc.
#
# Revision 1.2  2000/12/08 16:18:21  fsg
# Preliminary changes to get IB_BUILD_NO automatically
# increased on commits.
#
# setup_dirs will create 'jrd/build_no.h' by a call to
# a slightly modified 'builds_win32/original/build_no.ksh'
# that gets IB_BUILD_NO from 'this_build', that hopefully
# will be increased automatically in the near future :-)
#
# I have changed 'jrd/iblicense.h' to use IB_BUILD_TYPE
# from 'jrd/build_no.h'.
# So all changes to version numbers, build types etc. can
# now be done in 'builds_win32/original/build_no.ksh'.
#
#
#
#
# This script should only be run for 'formal' builds. 
# It will be run when setupdirs is executed and create
# jrd/build_no.h with the formal build number received from cvs.
# Other builds should use the build_no.h in win_nt/original. (refresh will copy it to JRD)
# the variable BUILD_TYPE can be used for more complex manipulations of the
# the version resource flags, depending on if it is I B or V

# For Firebird we also are adopting an odd minor number => dev/test/beta 
# and even minor number => production release.
# That way 0.9 is a precursor to production 1.0 and 1.1 versions are dev/test
# versions of the upcoming production 1.2 version.
# This method is also used in a few other projects (linux kernel, gcc etc).

BUILD_TYPE=T
MAJOR_VER=1
MINOR_VER=0
REV_NO=0
BUILD_SUFFIX="Firebird 1.0"
ISC_MAJOR_VER=6
ISC_MINOR_VER=2


if [ ! -f this_build ]
then
	echo $0:this_build not found
	exit 1
fi

THISBUILD=`cat this_build`

PRODUCT_VER_STRING="${MAJOR_VER}"."${MINOR_VER}"."${REV_NO}"."${THISBUILD}"
FILE_VER_STRING='WI-'"${BUILD_TYPE}${MAJOR_VER}"."${MINOR_VER}"."${REV_NO}"."${THISBUILD}"
FILE_VER_NUMBER="${MAJOR_VER}"', '"${MINOR_VER}"', '"${REV_NO}"', '"${THISBUILD}"
WIN_FILE_VER_NUMBER="${ISC_MAJOR_VER}"', '"${ISC_MINOR_VER}"', '"${REV_NO}"', '"${THISBUILD}"
echo '/*FILE GENERATED BY BUILD_NO.KSH. DO NOT EDIT*/' > jrd/build_no.h
echo '/*TO CHANGE ANY INFORMATION IN HERE PLEASE*/' >> jrd/build_no.h
echo '/*EDIT BUILD_NO.KSH IN THE BUILD_WIN32 COMPONENT*/' >> jrd/build_no.h
echo '/*FORMAL BUILD NUMBER:'${THISBUILD}'*/' >> jrd/build_no.h
if [ "${BuildHostType}" != "SOLARIS" ]; then
echo '#define PRODUCT_VER_STRING '\"${PRODUCT_VER_STRING}\\0\" >> jrd/build_no.h
echo '#define FILE_VER_STRING '\"${FILE_VER_STRING}\\0\" >> jrd/build_no.h
echo '#define LICENSE_VER_STRING '\"${FILE_VER_STRING}\" >> jrd/build_no.h
fi
echo '#define FILE_VER_NUMBER '${FILE_VER_NUMBER} >> jrd/build_no.h
echo '#define FB_MAJOR_VER '\"${MAJOR_VER}\" >> jrd/build_no.h
echo '#define FB_MINOR_VER '\"${MINOR_VER}\" >> jrd/build_no.h
echo '#define FB_REV_NO '\"${REV_NO}\" >> jrd/build_no.h
echo '#define FB_BUILD_NO '\"${THISBUILD}\" >> jrd/build_no.h
echo '#define FB_BUILD_TYPE '\"${BUILD_TYPE}\" >> jrd/build_no.h
echo '#define FB_BUILD_SUFFIX '\"${BUILD_SUFFIX}\" >> jrd/build_no.h
echo '#define WIN_FILE_VER_NUMBER '${WIN_FILE_VER_NUMBER} >> jrd/build_no.h
echo '#define ISC_MAJOR_VER '\"${ISC_MAJOR_VER}\" >> jrd/build_no.h
echo '#define ISC_MINOR_VER '\"${ISC_MINOR_VER}\" >> jrd/build_no.h



