#! /bin/sh

RPM_ROOT=`pwd`
rpm -bb --buildroot $RPM_ROOT/buildroot SSrpmscript
