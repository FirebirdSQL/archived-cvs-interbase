#!/bin/sh

if [ `cat $2/builds/original/.version_flag` != $1 ]; then
	make ROOT="$2" BUILDTYPE="$1" SERVERTYPE="$3" updatemakefiles
fi
