;  Initial Developer's Public License.
;  The contents of this file are subject to the  Initial Developer's Public
;  License Version 1.0 (the "License"). You may not use this file except
;  in compliance with the License. You may obtain a copy of the License at
;    http://www.ibphoenix.com/idpl.html
;  Software distributed under the License is distributed on an "AS IS" basis,
;  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
;  for the specific language governing rights and limitations under the
;  License.
;
;  The Original Code is copyright 2001-2002 IBPhoenix Inc.
;
;  The Initial Developer of the Original Code is IBPhoenix Inc.
;
;  All Rights Reserved.
;
;  Contributor(s): ________________________________.

;   Usage Notes
;
;   This script must be compiled with My InnoSetup extensions
;
;   You must copy msvcrt.dll from your system32 directory
;   to the script directory before trying to compile.

;   To Do:
; o Detect if InterBase is installed and recommend its removal
;   This is because our examples dir. structure may not match
;   theirs. Currently, we are allowing a new install over an
;   existing install.
;
; o Better support for Win9x needed. We could set ibserver to
;   run automatically, for instance.
;


[Setup]
AppName=Firebird Database Server 1.0
;The following is important - all ISS install packages should
;duplicate this for v1. See the InnoSetup help for details.
AppID=FBDBServer1
AppVerName=Firebird 1.0.0
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={code:InstallDir|{pf}\Firebird}
DefaultGroupName=Firebird
AllowNoIcons=true
AlwaysCreateUninstallIcon=true
SourceDir=..\..\..\interbase
LicenseFile=builds_win32\install\IPLicense.txt
InfoBeforeFile=builds_win32\install\installation_readme.txt
InfoAfterFile=builds_win32\install\readme.txt
AlwaysShowComponentsList=true
BackColor=clBlue
BackColor2=clNavy
WizardImageFile=builds_win32\install\firebird_install_logo1.bmp
AdminPrivilegesRequired=true
UninstallDisplayIcon={app}\bin\ibserver.exe
OutputDir=builds_win32\install\install_image
OutputBaseFilename=Firebird-1.0.0-Win32
Compression=bzip
;WizardDebug=true

[Types]
Name: Server; Description: Full installation of server and development tools.
Name: Developer; Description: Installation of Client tools for Developers.
Name: Client; Description: Minimum client install.

[Components]
Name: Server; Description: Server; Types: Server
Name: DevTools; Description: Tools; Types: Server Developer
Name: Client; Description: Client; Types: Server Developer Client; Flags: fixed disablenouninstallwarning

[Tasks]
Name: group; Description: Create a Menu &Group; Components: Server DevTools Client
Name: desktopicon; Description: Create a &desktop icon; Components: Server DevTools Client; MinVersion: 4.0,0
;Name: SetupRegistry; Description: "Install registry settings"; Components: Server DevTools Client;
Name: InstallService; Description: "Install IBServer as a standalone service"; Components: Server; MinVersion: 0,4; GroupDescription: "Use the guardian service?"; Flags: Exclusive;
Name: InstallGuardian; Description: "Install IBServer using the guardian service"; Components: Server; MinVersion: 0,4; GroupDescription: "Use the guardian service?"; Flags: Exclusive;
Name: StartService; Description: "Start Firebird service when setup complete?"; Components: Server; MinVersion: 0,4;

[Files]
Source: builds_win32\install\IPLicense.txt; DestDir: {app}; Components: Server DevTools; CopyMode: alwaysoverwrite
;Source: builds_win32\install\IDPLicense.txt; DestDir: {app}; Components: Server DevTools Client; CopyMode: alwaysoverwrite; Tasks: odbc_driver1
Source: builds_win32\install\readme.txt; DestDir: {app}; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\ibconfig; DestDir: {app}; Components: Server; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall
Source: interbase\isc4.gdb; DestDir: {app}; Components: Server; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall
Source: interbase\isc4.gbk; DestDir: {app}; Components: Server; CopyMode: alwaysoverwrite
Source: interbase\interbase.log; DestDir: {app}; Components: Server; CopyMode: dontcopy; Flags: uninsneveruninstall skipifsourcedoesntexist external
Source: interbase\interbase.msg; DestDir: {app}; Components: Server DevTools Client; CopyMode: alwaysoverwrite
Source: interbase\bin\gbak.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\gdef.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\gfix.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\gpre.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\gsec.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\gstat.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\ibguard.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\iblockpr.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\ibserver.exe; DestDir: {app}\bin; Components: Server; CopyMode: alwaysoverwrite; Flags: restartreplace
Source: interbase\bin\ib_util.dll; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\instreg.exe; DestDir: {app}\bin; Components: Server DevTools Client; CopyMode: alwaysoverwrite
Source: interbase\bin\instsvc.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\isql.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\qli.exe; DestDir: {app}\bin; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\doc\*.*; DestDir: {app}\doc; Components: Server DevTools; CopyMode: alwaysoverwrite; Flags: skipifsourcedoesntexist external
Source: interbase\help\*.*; DestDir: {app}\help; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\include\*.*; DestDir: {app}\include; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\intl\*.*; DestDir: {app}\intl; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\lib\*.*; DestDir: {app}\lib; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\UDF\*.*; DestDir: {app}\UDF; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\examples\v5\*.*; DestDir: {app}\examples; Components: Server DevTools; CopyMode: alwaysoverwrite
Source: interbase\bin\gds32.dll; DestDir: {sys}\; Components: Server; CopyMode: normal; Flags: overwritereadonly sharedfile;
Source: interbase\bin\gds32.dll; DestDir: {sys}\; Components: DevTools Client; CopyMode: normal; Flags: overwritereadonly sharedfile;
Source: builds_win32\install\msvcrt.dll; DestDir: {sys}\; Components: Server DevTools Client; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall sharedfile;

[Icons]
Name: {group}\Firebird; Filename: {app}\bin\ibserver.exe; MinVersion: 4.0,0; Tasks: group; IconIndex: 0
Name: {userdesktop}\Firebird; Filename: {app}\bin\ibserver.exe; MinVersion: 4.0,0; Tasks: desktopicon; IconIndex: 0

[Registry]
;These will be the future Firebird entries
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\; Flags: uninsdeletekey
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; Flags: uninsdeletekey
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; ValueType: string; ValueName: RootDirectory; ValueData: {app}
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; ValueType: string; ValueName: ServerDirectory; ValueData: {app}\bin; Components: Server DevTools;

[Run]
;Register Firebird
Filename: {app}\bin\instreg.exe; Parameters: "install ""{app}"" "; StatusMsg: "Updating the registry"; MinVersion: 4.0,4.0; Components: Server DevTools Client; Flags: runminimized;
;Install and start service if on NT/Win2k etc
Filename: {app}\bin\instsvc.exe; Parameters: "install ""{app}"" -auto"; StatusMsg: "Setting up the service"; MinVersion: 0,4.0; Components: Server; Flags: runminimized; Tasks: InstallService;
Filename: {app}\bin\instsvc.exe; Parameters: "install ""{app}"" -auto -g"; StatusMsg: "Setting up the service"; MinVersion: 0,4.0; Components: Server; Flags: runminimized; Tasks: InstallGuardian;
Filename: {app}\bin\instsvc.exe; Parameters: start; StatusMsg: "Starting the server"; MinVersion: 0,4.0; Components: Server; Flags: runminimized; Tasks: StartService;

[UninstallRun]
Filename: {app}\bin\instsvc.exe; Parameters: stop; StatusMsg:  "Stopping the service"; MinVersion: 0,4.0; Components: Server; Flags: runminimized;
Filename: {app}\bin\instsvc.exe; Parameters: remove -g; StatusMsg:  "Removing the service"; MinVersion: 0,4.0; Components: Server; Flags: runminimized;
Filename: {app}\bin\instreg.exe; Parameters: remove; StatusMsg:  "Updating the registry"; MinVersion: 4.0,4.0; Components: Server DevTools Client; Flags: runminimized;

[UninstallDelete]
Type: files; Name: "{app}\{%COMPUTERNAME}.lck"
Type: files; Name: "{app}\{%COMPUTERNAME}.evn"

[_ISTool]
EnableISX=true

[Code]
program Setup;

function InitializeSetup(): Boolean;
var
  i: Integer;
begin
  result := true;

  //Look for a running copy of InterBase, or an old version of Firebird.
  i:=0;
  i:=FindWindowByClassName('IB_Server') ;
  if i<>0 then begin
    result := false;
    //We could be clever and try to stop the server.
    //If that fails we could try to close the app.
    //For now, let's be cowards and take the easy way out and
    //leave the user to do the work.
    MsgBox('An existing Firebird or InterBase Server is running. You must close the '+
           'application or stop the service before continuing.', mbError, MB_OK);
    end;
    
  //sooner or later Firebird will have its own class name for the server
  if i<>0 then begin
    i:=0;
    i:=FindWindowByClassName('FB_Server') ;
    if i<>0 then begin
      result := false;
      MsgBox('An existing Firebird Server is running. You must close the '+
             'application or stop the service before continuing.', mbError, MB_OK);
    end;
  end;

end;

function InstallDir(Default: String): String;
var
	sRootDir: String;
begin
	sRootDir := '';
  // Try to find the value of "RootDirectory" in the Firebird
  // registry settings
  if (RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SOFTWARE\FirebirdSQL\Firebird\CurrentVersion',
    'RootDirectory', sRootDir) = False) then
      // If the Firebird registry settings doesn't exist try to
      // find the Borland ones
      RegQueryStringValue(HKEY_LOCAL_MACHINE,
        'SOFTWARE\Borland\InterBase\CurrentVersion',
        'RootDirectory', sRootDir);

  //if we still haven't found anything then try the INTERBASE env var
  if (sRootDir = '') then
    sRootDir:=getenv('INTERBASE');

  //Suggestion from Michael Rimov that returns the specified default
  //if no existing registry setting is found.
  if (sRootDir = '') then
    sRootDir := Default;

  Result := ChangeDirConst(sRootDir);

end;

begin
end.
