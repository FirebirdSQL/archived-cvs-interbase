:: The contents of this file are subject to the Independant
:: Developers Public License Version 1.0 (the "License").
:: You may not use this file except in compliance with the License.
:: You may obtain a copy of the License at http://www.ibphoenix.com/IDPL.html
:: 
:: Software distributed under the License is distributed on an
:: "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
:: or implied. See the License for the specific language governing
:: rights and limitations under the License.
::
:: The Original Code was created by Paul Reeves. Portions created
:: by him are Copyright (C) Paul Reeves.
:: 
:: All Rights Reserved.
:: Contributor(s): ______________________________________.
::
:: PREREQUISITES
:: This is the master script for building Firebird on Win32.
:: This script and the unix tools associated with it should entirely
:: replace cygwin and the cygwin scripts required to build Firebird.
:: This file itself replaces the SETUP_DIRS script. In addition it checks
:: the build environment. It then calls build_lib.bat which drives 
:: the actual build process.
::
:: Before running this script you may want to check the readme file which
:: documents extensively the requirements and preparations you need to
:: make.
::
:: o This Batch file is intended for use on the NT4 and Win2K platforms.
:: o It is assumed that command-line extensions are enabled (the default).
:: o It must be run from the root of the source tree.
:: o An existing installation of Firebird or InterBase should exist.
:: o See the FB_Build_Win32_Readme.txt for full documentation
::
::
::  Changelog
::    Add .cvsignore for each component to      - 02-Nov-2001  - PR
::      block cvs committing the Win32
::      specific depends.mak files
::    Removed need to pass build number param   - 01-Nov-2001  - PR
::    Added better environment checking         - 06-Sep-2001  - PR
::    Added :CLEAN to clean things up.          - 06-Sep-2001  - PR
::    Corrected error processing of parameters  - 06-Sep-2001  - PR
::    Added support for building the build-dbs  - 29-Aug-2001  - PR
::    Added support for using the build_no      - 29-Aug-2001  - PR
::    Script first created                      - 12-Apr-2001  - PR

@echo off

call :CHECK_CURLIES %1

::Check if on-line help is required
if /I "%1"=="-h" (goto :HELP & goto :EOF)
if /I "%1"=="/h" (goto :HELP & goto :EOF)
if /I "%1"=="-?" (goto :HELP & goto :EOF)
if /I "%1"=="/?" (goto :HELP & goto :EOF)

goto :CHECKPARMS

::=====================================
:CHECKPARMS
@if "%INTERBASE%"=="" (goto :HELP2) else (set IBSERVER="%INTERBASE%")

@if "%2"=="-DDEV" (set BUILDTYPE=DEV) else (set BUILDTYPE=PROD)
@if not "%2"=="" then if not "%2"=="-DDEV" (goto :HELP3)
@if /I "%1"=="-DDEV" goto :HELP3
@if "%1"=="" goto :HELP1
@if /I "%1"=="CLEAN" (goto :CLEAN) else (goto :CHECKTOOLS)

::=====================================
:CLEAN
:: clear out all the env vars we have set.
call FB_Build_Win32_Clean.bat do_it

set BUILDTYPE=
set IBSERVER=
set BUILD_SUFFIX=
set BUILD_TYPE=
set IB_COMPONENTS=

set FILE_VER_NUMBER=
set FILE_VER_STRING=
set MAJOR_VER=
set MINOR_VER=
set NO_HEADER_COMPS=
set OS_NAME=
set PRODUCT_VER_STRING=
set REV_NO=
set THISBUILD=

@echo:
@echo Finished cleaning Win32 build environment
@echo:
goto :EOF


::=====================================

:CHECKTOOLS
:: verify our unix tool set is available

sed --help > nul
@if errorlevel 1 goto :HELP4
echo sed located on path

cp --help > nul
@if errorlevel 1 goto :HELP4
echo cp located on path

cat --help > nul
@if errorlevel 1 goto :HELP4
echo cat located on path

tail --help > nul
@if errorlevel 1 goto :HELP4
echo tail located on path


::=====================================


:CHECK_MAKE
:: Verify make, touch etc are available

make.exe | findstr "Borland" > nul
@if errorlevel 1 call :HELP_MAKE make.exe
@echo Borland make exists on path

touch.exe | findstr "Borland" > nul
@if errorlevel 1 call :HELP_MAKE touch.exe
@echo Borland touch exists on path

implib.exe | findstr "Borland" > nul
@if errorlevel 1 call :HELP_MAKE implib.exe
@echo Borland implib exists on path

brc32.exe | findstr "Borland" > nul
@if errorlevel 1 call :HELP_MAKE brc32.exe
@echo Borland brc32 exists on path

echo %PATH% | find "%INTERBASE%\bin" > nul
@if errorlevel 1 (call :HELP_MAKE "%INTERBASE%\bin" & goto :EOF) else (
@echo "%INTERBASE%\bin" exists on path)

::=====================================

:BUILD_NO
:: set up build number etc
for /f "tokens=*" %%a in ('cat THIS_BUILD') do set THISBUILD=%%a
call FB_Build_Win32_build_no.bat %THISBUILD%
@echo Completed writing build_no.h

::=====================================
:COMP_VARS
::set up some env vars.
set IB_COMPONENTS=alice burp dsql dudley example5 extlib gpre intl ipserver isql iscguard jrd lock msgs qli remote utilities wal
set NO_HEADER_COMPS=examples example5
set OS_NAME=builds_win32


::=====================================
::ADD_BUILDER
gsec -add BUILDER -pw builder 2>nul


::=====================================
::Check DB_PATH has forward slashes
@echo "%1" | find "\" >nul && ((@echo:) & (@echo Build_Db must not contain backslashes.) & (goto :HELP1))

::=====================================
:SETUP_ENV

:: path to look for db in .e files
SET DB_PATH="%1"
SET DB_DIR="%1"

:: Start tail in another console and watch the show.
::start "Preparing Firebird build environment" "cmd /k tail -f FB_Build_Win32.log"


:: move the first parameters out of the way. We don't need them anymore.
shift

for %%V in (%IB_COMPONENTS%) do (
  (@echo creating component %%V ...)
  (mkdir %%V 2>nul)
  (@echo depends.mak > %%V\.cvsignore)
  (mkdir %%V\MS_obj 2>nul)
  (mkdir %%V\MS_obj\bin  2>nul)
  (mkdir %%V\MS_obj\bind 2>nul)
  (mkdir %%V\MS_obj\client 2>nul)
  (mkdir %%V\MS_obj\clientd 2>nul)

  (@echo Delivering .\builds_win32\original\make.%%V to %%V\makefile.lib)
  (copy .\builds_win32\original\make.%%V %%V\makefile.lib)

  )

setlocal
set DIRS=bin lib intl UDF include examples examples\v4 examples\v5 help

mkdir ib_debug 2> nul
for %%a in (%DIRS%) do ((mkdir ib_debug\%%a 2>nul))

mkdir interbase 2> nul
for %%a in (%DIRS%) do ((mkdir interbase\%%a 2>nul))

endlocal

:: directory for builds_win32 components
cd builds_win32\original

@echo Delivering files from builds_win32\original
sed s@$(DB_DIR)@%DB_PATH%@ include.mak > ../../include.mak

:: build expand_dbs.bat and compress_dbs.bat in root build dir
@echo CREATING expand_dbs and compress_dbs
sed s/$(SYSTEM)/builds_win32/ expand_dbs.bat > ../../expand_dbs.bat
sed s/$(SYSTEM)/builds_win32/ compress_dbs.bat > ../../compress_dbs.bat

:: build expand.sed and compress.sed
sed s@$(DB_DIR)@builds_win32@ expand.sed > ../expand.sed
sed s@$(DB_DIR)@builds_win32@ compress.sed > ../compress.sed

:: check if user wants local metadata database
sed s@$(DB_DIR)@%DB_PATH%@ expand_local.sed > ../expand.sed
sed s@$(DB_DIR)@%DB_PATH%@ compress_local.sed > ../compress.sed

@echo Creating local METADATA.GDB for GPRE, also known as yachts.gdb
cd ..
isql -i .\original\metadata.sql
cd original

@echo DELIVERING ROOT BUILD FILES
copy build_lib.bat ..\..
copy std.mk ..\..

@echo DELIVERING MISC FILES
copy gdsalias.asm ..\..\jrd
copy gdsintl.bind ..\..\intl\gdsintl.bind
copy gds32.bind ..\..\jrd
copy jrd32.bind ..\..\jrd\ibeng32.bind
copy expand_cfile.bat ..\..
copy depends.sed ..\
copy build_no.ksh ..\..
copy debug_entry.bind ..\..\jrd
copy ib_udf.bind     ..\..\extlib\ib_udf.bind
copy ib_util.bind     ..\..\extlib\ib_util.bind

@echo DELIVERING '*template.bat' FILES
copy *template.bat ..\..

cd ..\..

::
::  In setup_build.ksh there is code to copy the make.* files to their
::  relevant component directories. This task is now carried out earlier on
::  when the component object directories are created
::

:: Modify component depends.mak files for NT

setlocal
@echo Expanding depends.mak
set IB_COMPONENTS=alice burp dsql dudley gpre intl isql jrd lock msgs qli remote utilities wal
for %%V in (%IB_COMPONENTS%) do (
  (cd %%V)
  (@echo creating depends.mak for component %%V ...)
  (sed -f ..\builds_win32\depends.sed depends.mak > .\sed.TMP)
  (copy .\sed.TMP depends.mak)
  (del .\sed.TMP)
  (cd ..)
  )
endlocal

::
:: Now check if we need to copy gds32_MS.lib to jrd\ms_obj\client
:: This really is messy - the build should not need this palaver
:: If a DEV build is run before a PROD build then gds32_ms.lib will
:: not exist in "jrd\ms_obj\client\" and the build will completely fail
:: so we have to copy an existing one.
::
if exist jrd\ms_obj\client\gds32_ms.lib (goto :BUILD_LIB)
if exist jrd\ms_obj\clientd\gds32_ms.lib (copy jrd\ms_obj\clientd\gds32_ms.lib jrd\ms_obj\client\gds32_ms.lib)
if exist %INTERBASE%\SDK\lib_ms\gds32_ms.lib (copy %INTERBASE%\SDK\lib_ms\gds32_ms.lib jrd\ms_obj\client) else if exist %INTERBASE%\lib\gds32_ms.lib (copy %INTERBASE%\lib\gds32_ms.lib jrd\ms_obj\client)

::=====================================
:BUILD_LIB
:: This is where it all happens
@echo Setup Complete. Now running Firebird Build...
start "Running Firebird Build" "cmd /k tail -f build_lib_%BUILDTYPE%.log"
call build_lib.bat %1 %2 > build_lib_%BUILDTYPE%.log 2>&1
goto :END_COMPLETED


::=====================================
:HELP
type FB_Build_Win32_Readme.txt | more /E +16
goto :EOF

goto :EOF

:HELP1
@echo:
@echo   Syntax 1
@echo   FB_Build_Win32.bat {params}
@echo:
@echo   where params are {DB_PATH} [-DDEV] (In that order!)
@echo:
@echo   {DB_PATH} is the root of a directory tree which contains
@echo   the build time database. DB_PATH may include a server name.
@echo   DB_PATH should not be the same as the source directory.
@echo:
@echo   DB_PATH must be specified with forward slashes, even if
@echo   the server is running under windows ie use:
@echo       SERVER:driveletter:/path/to/databases
@echo   If DB_PATH is not correctly specified the build will fail.
@echo:
@echo   You may optionally specify -DDEV to create a debug build.
@echo:
@echo:
@echo   Syntax 2
@echo   FB_Build_Win32.bat { -h ^| /h ^| -? ^| /? }
@echo:
@echo   This will open the readme file
@echo:
@echo:
@goto :EOF


:HELP2
@echo:
@echo   An existing installation of INTERBASE must exist and
@echo   the INTERBASE environment variable must be set.
@echo:
@echo:
@goto :EOF


:HELP3
@echo:
@echo   You must pass the location of the build
@echo   databases as parameter 1.
@echo   The second parameter, if passed, must be -DDEV
@echo:
@echo:
@goto :EOF


:HELP4
@echo:
@echo   Please check that these utilities programs are
@echo   all on your path:
@echo:
@echo     sed.exe cat.exe cp.exe tail.exe
@echo:
@echo   If you do not have these utilities they may be downloaded
@echo   via ftp from the Firebird Project on Sourceforge:
@echo:
@echo     http://firebird.sourceforge.net/downloads
@echo:
@echo   filename:  Firebird_Unix_Tools_for_Win32.zip
@echo:
@echo:
@goto :EOF

:HELP_MAKE
@echo on
@echo:
@echo   %1 was not found or is wrong version.
@echo: 
@echo   Please check that Borland make.exe, touch.exe
@echo   and implib.exe are on your path. Also, please
@echo   ensure that they are found earlier in the path 
@echo   than other versions of make, touch etc.
@echo:
@echo:
@echo off
goto :EOF

::-------------------------------------
:HELP_SYNTAX
@echo:
@echo Curly brackets are not required.
@echo They are only part of the syntax diagram,
@echo indicating required parameters
@echo:
set curly=
goto :EOF


::=====================================
:CHECK_CURLIES
:: Someone may just be daft enough to misread the
:: syntax diagram
set curly=%1
set curly=%curly:~0,1%
if "%curly%"=="{" goto :HELP_SYNTAX
set curly=
goto :EOF


::=====================================

:END_COMPLETED
if exist BUILD_OK (
  if "%BUILDTYPE%"=="DEV" (call FB_Build_Win32_BSCMake.bat)
) else (goto :END_FAIL)
@echo FB_Win32_Build.bat completed
goto :EOF

:END_FAIL
@echo FB_Win32_Build.bat FAILED
goto :EOF

