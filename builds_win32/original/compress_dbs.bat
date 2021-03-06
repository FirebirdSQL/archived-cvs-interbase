@echo off
rem The contents of this file are subject to the Interbase Public
rem License Version 1.0 (the "License"); you may not use this file
rem except in compliance with the License. You may obtain a copy
rem of the License at http://www.Inprise.com/IPL.html
rem
rem Software distributed under the License is distributed on an
rem "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
rem or implied. See the License for the specific language governing
rem rights and limitations under the License.
rem
rem The Original Code was created by Inprise Corporation
rem and its predecessors. Portions created by Inprise Corporation are
rem Copyright (C) Inprise Corporation.
rem
rem All Rights Reserved.
rem Contributor(s): ______________________________________.
if "%1" == "" goto err
if not "%2" == "" goto err

echo Compressing DB in... %1
sed -f ..\$(SYSTEM)\compress.sed %1 > .\sed.TMP
copy .\sed.TMP %1
del .\sed.TMP
goto end

:err
echo "Usage: compress_dbs filename"

:end
