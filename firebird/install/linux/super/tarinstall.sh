#! /bin/sh

# THe way this works is that the buildroot file is stored relative to the root
# directory and a tar -xzf at root directory will restore all the files in 
# the position that we want them to be

OrigDir=`pwd`

cd /

tar -xzf $OrigDir/buildroot.tar.gz 

cd $OrigDir
