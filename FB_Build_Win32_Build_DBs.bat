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
:: Contributor(s): Dmitri Kuzmenko_________________________________.
::
::
@echo off

goto :BUILD_DBS

::SUB-ROUTINES
::These are NT/W2K specific

::=====================================
::DEPRECATED
:GETINPUT
@ECHO OFF & (set input=) & echo\
if not "%COMMENT1%"=="" (@echo %COMMENT1%)
if not "%COMMENT2%"=="" (@echo %COMMENT2%)
if "%QUESTION%"=="" (echo ERROR - No Input Question given & goto :EOF)
@echo %QUESTION%
echo\ & format/f:160 a: > %temp%.\#input#
for /f "tokens=6*" %%a in (
'findstr \... %temp%.\#input#') do if not "%%b"=="" (set input=%%a %%b) else (set input=%%a)

goto :EOF

::=====================================
::Deprecated
:CHECK_BUILD_DBS
set DB_DIR=

set COMMENT1=
set COMMENT2=
@set QUESTION=Do you want to create the build databases (y/n)
@call :GETINPUT %QUESTION%
@set QUESTION=
if not "%INPUT%"=="y" (set INPUT= & goto :EOF)

@set COMMENT1=* NOTES: You must use the current drive.  *
@set COMMENT2=*        DO NOT specify a trailing slash! *
@set QUESTION=* Enter the drive and path for the Build Databases:
call :GETINPUT %QUESTION% %COMMENT1% %COMMENT2%

if NOT "%INPUT%"=="" ((set DB_DIR=%INPUT%) )
set INPUT=

goto :EOF

::=====================================
:MAKE_DB
@echo ON
"%INTERBASE%\bin\gbak" -r "%GBKFILE%" "%OUTFILE%" -user %ISC_USER% -password %ISC_PASSWORD%
@echo OFF
if not errorlevel 1 (@echo created %OUTFILE% in build_db dir tree ) else (@echo Failed to create %OUTFILE%)
goto :EOF

::=====================================

:COPY_DB
@echo ON
"%INTERBASE%\bin\gbak" -b -g "%INFILE%" "%GBKFILE%" -user %ISC_USER% -password %ISC_PASSWORD%
@echo OFF
call :MAKE_DB
goto :EOF

::=====================================

:BUILD_DBS
:: This constructs the build databases that are
:: required during the build process.

:: deprecated
::call :CHECK_BUILD_DBS

if "%1"=="" goto :HELP
if "%INTERBASE%"=="" goto :HELP

:: path to look for db in .e files
SET DB_DIR=%1

::ADD_BUILDER
gsec -add BUILDER -pw builder 2>nul



if "%ISC_USER%"=="" set ISC_USER=SYSDBA
if "%ISC_PASSWORD%"=="" set ISC_PASSWORD=masterkey

mkdir %DB_DIR%
mkdir %DB_DIR%\jrd
mkdir %DB_DIR%\msgs
mkdir %DB_DIR%\qli
mkdir %DB_DIR%\example5

SET INFILE=%INTERBASE%\isc4.gdb
SET GBKFILE=%DB_DIR%\jrd\isc4.gbk
SET OUTFILE=%DB_DIR%\jrd\isc.gdb
del /q %DB_DIR%\jrd\isc4.gbk
call :COPY_DB

SET OUTFILE=%DB_DIR%\msgs\msg.gdb
SET GBKFILE=msgs\msg.gbak
call :MAKE_DB

SET OUTFILE=%DB_DIR%\msgs\master_msg_db
call :MAKE_DB

SET OUTFILE=%DB_DIR%\qli\help.gdb
SET GBKFILE=.\misc\help.gbak
gbak -r -user builder -password builder %GBKFILE% %OUTFILE%
if not errorlevel 1 (@echo created %OUTFILE% in build_db dir tree) else (@echo Failed to create %OUTFILE%)

SET OUTFILE=%DB_DIR%\qli\master_help_db
gbak -r -user builder -password builder %GBKFILE% %OUTFILE%
if not errorlevel 1 (@echo created %OUTFILE% in build_db dir tree) else (@echo Failed to create %OUTFILE%)

goto :BUILD_EXAMPLE5

:BUILD_EXAMPLES
:: We could do this, if we wanted to
:: but for now it is not called, and untested
setlocal
@echo Building examples databases
set EXAMPLES=atlas emp slides nc_guide c_guide stocks
cd examples
for %%V in (%EXAMPLES%) do (
  echo Building example db %%V ...
  %INTERBASE%\bin\gdef %%V.gdl
  copy %%V.gdb %DB_DIR%\examples
  )
cd ..
endlocal


:BUILD_EXAMPLE5
del /q %DB_DIR%\example5\*.gdb
copy example5\*.sql %DB_DIR%\example5

PUSHD %DB_DIR%\example5\
cd

"%INTERBASE%\bin\isql" -i empbld.sql
"%INTERBASE%\bin\isql" -i intlbld.sql
del /q %DB_DIR%\example5\*.sql

SET INFILE=employee.gdb
SET GBKFILE=employee.gbk
SET OUTFILE=empbuild.gdb
call :COPY_DB

SET INFILE=intlemp.gdb
SET GBKFILE=intlemp.gbk
SET OUTFILE=intlbld.gdb
call :COPY_DB

POPD

goto :EOF

:HELP
@echo:
@echo:
@echo    Syntax... FB_Build_Win32_Build_Dbs.bat {DB_DIR} 
@echo    where {DB_DIR} is a drive:\path on the current drive.
@echo:
@echo    This batch file must be run from the root of the Firebird 
@echo    engine source (ie the top level 'interbase' directory.)
@echo:
@echo    You must have an installed and running Firebird or InterBase
@echo    server. 
@echo:
@echo    The INTERBASE environment variable must be set to the root
@echo    of the Firebird or InterBase server location. 
@echo:
@echo    See FB_Build_Win32_Readme.txt for more information
@echo    on setting up.
@echo:
@echo:

:EOF

