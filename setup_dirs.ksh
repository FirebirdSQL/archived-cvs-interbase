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
# Contributor(s):
#	Reed Mideke <rfm@cruzers.com>
# $Id$
# Revision 1.3  2000/12/08 16:18:20  fsg
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
#	______________________________________.

#set -x
if [ "$1" = "" ] ; then
	echo "syntax: setup_dirs.ksh {DB_PATH}"
	echo "  where {DB_PATH} is the root of a directory tree"
	echo "  which contains the build time database. DB_DIR may"
	echo "  include a server name. DB_DIR should not be the"
	echo "  source directory."
	exit 1
fi

IB_BIN_COMPS="alice burp dsql dudley example5 extlib gpre intl ipserver isql iscguard jrd lock msgs qli remote utilities wal"

echo setting up source directories...
for comp in ${IB_BIN_COMPS}
do
    echo creating component $comp ...
    mkdir $comp/ms_obj
    mkdir $comp/ms_obj/bin
    mkdir $comp/ms_obj/bind
    mkdir $comp/ms_obj/client
    mkdir $comp/ms_obj/clientd
done

mkdir builds
mkdir builds/original
mkdir ib_debug
mkdir ib_debug/bin
mkdir ib_debug/lib
mkdir ib_debug/intl
mkdir ib_debug/UDF
mkdir ib_debug/include
mkdir ib_debug/examples
mkdir ib_debug/examples/v4
mkdir ib_debug/examples/v5
mkdir ib_debug/help

mkdir interbase
mkdir interbase/bin
mkdir interbase/lib
mkdir interbase/intl
mkdir interbase/UDF
mkdir interbase/include
mkdir interbase/examples
mkdir interbase/examples/v4
mkdir interbase/examples/v5
mkdir interbase/help

echo "Creating jrd/build_no.h"
./builds_win32/original/build_no.ksh

./setup_build.ksh $1

echo done

