#!/bin/sh


# This script file is for refreshing the files in the boot build 
# process.

fbSrcHome=.

# find . -name '*.c' > bootfiles.txt
# find . -name '*.h' >> bootfiles.txt

fbBootFiles=`cat <<e_o_f
./jrd/codes.c
./jrd/blf.c
./jrd/dfw.c
./jrd/envelope.c
./jrd/dpm.c
./jrd/dyn.c
./jrd/fun.c
./jrd/ini.c
./jrd/met.c
./jrd/scl.c
./jrd/stats.c
./jrd/dyn_util.c
./jrd/grant.c
./jrd/dyn_def.c
./jrd/dyn_del.c
./jrd/dyn_mod.c
./jrd/pcmet.c
./qli/help.c
./burp/backup.c
./burp/restore.c
./dsql/blob.c
./dsql/metd.c
./dsql/parse.c
./dsql/array.c
./gpre/met.c
./msgs/check_msgs.c
./msgs/build_file.c
./pyxis/edit.c
./pyxis/save.c
./utilities/dba.c
./utilities/security.c
./jrd/iberror.h
e_o_f`



# Build the directories

for i in burp dsql jrd gpre misc msgs pyxis qli utilities
  do
    mkdir -p porting/$i
  done


# copy the individual files

for i in $fbBootFiles
  do
    cp  $fbSrcHome/$i porting/$i
  done
