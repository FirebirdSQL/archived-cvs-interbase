:: The contents of this file are subject to the Independant
:: Developers Public License Version 1.0 (the "License").
:: You may not use this file except in compliance with the License.
:: You may obtain a copy of the License at http://www.ibphoenix.com/IDPL.html
:: 
:: Software distributed under the License is distributed on an
:: "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
:: or implied. See the License for the specific language governing
:: rights and limitations under the License.

:: The Original Code was created by Paul Reeves. Portions created
:: by him are Copyright (C) Paul Reeves.
:: 
:: All Rights Reserved.
:: Contributor(s): Dmitri Kuzmenko__________________________________.
::
::
:: Notes:
::
:: This script is intended as a Win32 replacement for
:: 'builds_win32/original/build_no.ksh'
::
::  'jrd/iblicense.h' now uses IB_BUILD_TYPE from 'jrd/build_no.h'.
:: So all changes to version numbers, build types etc. can now be
:: done in 'builds_win32/original/build_no.ksh'.
::

::===========

:: For Firebird we are adopting an odd minor number => dev/test/beta
:: and even minor number => production release.
:: That way 0.9 is precursor to production 1.0 and 1.1 versions are dev/test
:: versions of the upcoming production 1.2 version.
:: This method is also used in a few other projects (linux kernel, gcc etc).

@echo off
set BUILD_TYPE=T
set MAJOR_VER=1
set MINOR_VER=0
set REV_NO=0
set BUILD_SUFFIX="Firebird Release Candidate 2"

set ISC_MAJOR_VER=6
set ISC_MINOR_VER=2


:: For now, THISBUILD must be set by passing a parameter
:: this is supplied automatically by FB_Build_Win32.bat

if not "%1"=="" (goto :BUILD_NO_OK) else (goto :HELP)

::--------------------------------------
:HELP
@echo This build number is 
type this_build
@echo It is recommended that you use this value as a 
@echo parameter for the current bat file
goto :BUILD_NO_OK

::--------------------------------------
:BUILD_NO_OK

if "%1"=="" (set THISBUILD=0) else (set THISBUILD=%1)

set PRODUCT_VER_STRING=%MAJOR_VER%.%MINOR_VER%.%REV_NO%.%THISBUILD%
set FILE_VER_STRING=WI-%BUILD_TYPE%%MAJOR_VER%.%MINOR_VER%.%REV_NO%.%THISBUILD%
set FILE_VER_NUMBER=%MAJOR_VER%, %MINOR_VER%, %REV_NO%, %THISBUILD%

set WIN_FILE_VER_NUMBER=%ISC_MAJOR_VER%, %ISC_MINOR_VER%, %REV_NO%, %THISBUILD%

echo /* FILE GENERATED BY BUILD_NO.BAT - DO NOT EDIT      */ > jrd/build_no.h
echo /* TO CHANGE ANY INFORMATION IN HERE PLEASE EDIT     */ >> jrd/build_no.h
echo /* FB_BUILD_WIN32_BUILD_NO.BAT IN THE SOURCE ROOT DIR*/ >> jrd/build_no.h
echo /* FORMAL BUILD NUMBER: %THISBUILD%                  */ >> jrd/build_no.h

echo #define PRODUCT_VER_STRING "%PRODUCT_VER_STRING%\0" >> jrd/build_no.h
echo #define FILE_VER_STRING "%FILE_VER_STRING%\0" >> jrd/build_no.h
echo #define LICENSE_VER_STRING "%FILE_VER_STRING%" >> jrd/build_no.h
echo #define FILE_VER_NUMBER %FILE_VER_NUMBER% >> jrd/build_no.h
echo #define FB_MAJOR_VER "%MAJOR_VER%" >> jrd/build_no.h
echo #define FB_MINOR_VER "%MINOR_VER%" >> jrd/build_no.h
echo #define FB_REV_NO "%REV_NO%" >> jrd/build_no.h
echo #define FB_BUILD_NO "%THISBUILD%" >> jrd/build_no.h
echo #define FB_BUILD_TYPE "%BUILD_TYPE%" >> jrd/build_no.h
echo #define FB_BUILD_SUFFIX "%BUILD_SUFFIX%\0" >> jrd/build_no.h
echo #define WIN_FILE_VER_NUMBER %WIN_FILE_VER_NUMBER% >> jrd/build_no.h
echo #define ISC_MAJOR_VER "%ISC_MAJOR_VER%" >> jrd/build_no.h
echo #define ISC_MINOR_VER "%ISC_MINOR_VER%" >> jrd/build_no.h


goto :EOF

::--------------------------------------
:EOF
