::  Initial Developer's Public License.
::  The contents of this file are subject to the  Initial Developer's Public
::  License Version 1.0 (the "License"). You may not use this file except
::  in compliance with the License. You may obtain a copy of the License at
::    http://www.ibphoenix.com/idpl.html
::  Software distributed under the License is distributed on an "AS IS" basis,
::  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
::  for the specific language governing rights and limitations under the
::  License.
::
::  The Original Code is copyright 2002 Paul Reeves.
::
::  The Initial Developer of the Original Code is Paul Reeves.
::
::  All Rights Reserved.
::
::  Contributor(s): ________________________________.
::
::  Usage Notes:
::
::  This script is intended to be run after a successful build of the server
::  under the Win32 environment. It will take the value in 
::  %PRODUCT_VER_STRING% and insert it into the ISS script. This will then 
::  create an installable executable that contains the build number in the 
::  filename. Any resulting install will also display the build number in 
::  Control Panel | Add/Remove Programs.
::
::  To use it CD to the builds_win32/install directory and then run the 
::  batch file.
::
sed s/1.0.0/%PRODUCT_VER_STRING%/ FirebirdInstall.iss > FirebirdInstall%PRODUCT_VER_STRING%.iss
start FirebirdInstall%PRODUCT_VER_STRING%.iss
