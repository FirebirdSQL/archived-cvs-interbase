#! /bin/sh

# THis one is not finished by a long shot, but was some work on doing an
# uninstall for a .tar.gz install

# THe way this works is that the buildroot file is stored relative to the root
# directory and a tar -xzf at root directory will restore all the files in 
# the position that we want them to be

OrigDir=`pwd`

cd /

Dirs=""
for i in `tar -tzf $OrigDir/buildroot.tar.gz`
  do
     if [ -f $i -o -L $i ]
       then
         rm -f $i
     elif [ -d $i ]
       then
          Dirs="$i $Dirs"
     fi
  done


if [ ! -z $Dirs ]
  then
    for i in $Dirs
      do
        checkIfCanRemoveDir $i
      done
fi

cd $OrigDir
