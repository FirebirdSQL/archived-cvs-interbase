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
:: Contributor(s): __________________________________.
::


::After a debug build, this will take all the .sbr files and
:: create a browse database.

@echo off
dir /s /b *.sbr > bscmake.files
sed /fbcpl/d bscmake.files > bscmake.input
bscmake /n /o ib_debug\bin\ibserver.bsc @bscmake.input
del /q bscmake.input
del /q bscmake.files
@echo Completed building MSVC browse database


