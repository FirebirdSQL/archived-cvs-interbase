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
;   Contributor(s):
;     Tilo Muetze, Theo ? and Michael Rimov for improved detection
;     of an existing install directory.
;     Simon Carter for the WinSock2 detection.

;   Usage Notes:
;
;   This script must be compiled with My InnoSetup extensions 3.0.4-beta or later
;
;   You may need to copy msvcrt.dll from your system32 directory
;   to the script directory before trying to compile.

;   To Do:
;
;   o Detect if InterBase is installed and recommend its removal
;     This is because our examples dir. structure may not match
;     theirs. Currently, we are allowing a new install over an
;     existing install.
;
;
;   Known bugs:
;
;   o Uninstallation is likely to remove the registration entries for the
;     server even if the server is shared by another application. This is
;     because the registration utility does not make any checks for a
;     shared installation.
;
;     Until that is fixed the choices are:
;     o Don't remove the registry key at all
;     o Don't use instreg and manually specify the registry keys in the install script
;
;   o Inno Setup doesn't appear to provide a reliable way to detect and kill a
;     running server application when it does an uninstall. This means that the
;     server will remain running after the uninstall has completed. The uninstall
;     does uninstall all other components.
;
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
;AlwaysCreateUninstallIcon=true
SourceDir=..\..\..\interbase
LicenseFile=builds_win32\install\IPLicense.txt
InfoBeforeFile=builds_win32\install\installation_readme.txt
InfoAfterFile=builds_win32\install\readme.txt
AlwaysShowComponentsList=true
WizardImageFile=builds_win32\install\firebird_install_logo1.bmp
PrivilegesRequired=admin
UninstallDisplayIcon={app}\bin\ibserver.exe
OutputDir=builds_win32\install\install_image
OutputBaseFilename=Firebird-1.0.0-Win32
Compression=bzip

[Types]
Name: ServerInstall; Description: Full installation of server and development tools.
Name: DeveloperInstall; Description: Installation of Client tools for Developers and database administrators.
Name: ClientInstall; Description: Minimum client install - no server, no tools.

[Components]
Name: ServerComponent; Description: Server component; Types: ServerInstall
Name: DevAdminComponent; Description: Tools component; Types: ServerInstall DeveloperInstall
Name: ClientComponent; Description: Client component; Types: ServerInstall DeveloperInstall ClientInstall; Flags: fixed disablenouninstallwarning

[Tasks]
;Server tasks
Name: UseGuardianTask; Description: "Use the &Guardian to control the server?"; Components: ServerComponent; MinVersion: 4.0,4.0
Name: UseApplicationTask; Description: An &Application?; GroupDescription: "Run Firebird server as:"; Components: ServerComponent; MinVersion: 4,4; Flags: exclusive
Name: UseServiceTask; Description: A &Service?; GroupDescription: "Run Firebird server as:"; Components: ServerComponent; MinVersion: 0,4; Flags: exclusive
Name: AutoStartTask; Description: "Start &Firebird automatically everytime you boot up?"; Components: ServerComponent; MinVersion: 4,4;
;Developer Tasks
Name: MenuGroupTask; Description: Create a Menu &Group; Components: ServerComponent; MinVersion: 4,4;
;One for Ron
;Name: MenuGroupTask\desktopicon; Description: Create a &desktop icon; Components: ServerComponent; MinVersion: 4.0,4.0;

[Run]
;Always register Firebird
Filename: "{app}\bin\instreg.exe"; Parameters: "install ""{app}"" "; StatusMsg: Updating the registry; MinVersion: 4.0,4.0; Components: ClientComponent; Flags: runminimized

;If on NT/Win2k etc and 'Install and start service' requested
Filename: "{app}\bin\instsvc.exe"; Parameters: "install ""{app}"" {code:ServiceStartFlags|""""}"; StatusMsg: "Setting up the service"; MinVersion: 0,4.0; Components: ServerComponent; Flags: runminimized; Tasks: UseServiceTask;
Filename: "{app}\bin\instsvc.exe"; Description: "Start Firebird Service now?"; Parameters: start; StatusMsg: Starting the server; MinVersion: 0,4.0; Components: ServerComponent; Flags: runminimized postinstall; Tasks: UseServiceTask

;If 'start as application' requested
Filename: "{code:StartApp|{app}\bin\ibserver.exe}"; Description: "Start Firebird now?"; Parameters: "-a"; StatusMsg: Starting the server; MinVersion: 0,4.0; Components: ServerComponent; Flags: nowait postinstall; Tasks: UseApplicationTask


[Registry]
;These will be the future Firebird entries
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL; Flags: uninsdeletekeyifempty; Components: ClientComponent
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\; Flags: uninsdeletekey; Components: ClientComponent
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; Flags: uninsdeletekey; Components: ClientComponent
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; ValueType: string; ValueName: RootDirectory; ValueData: {app}; Components: ClientComponent
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; ValueType: string; ValueName: ServerDirectory; ValueData: {app}\bin; Components: ClientComponent

; If user has chosen to use guardian and not to install as service then we need to make sure that the guardian flag is set.
Root: HKLM; Subkey: SOFTWARE\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: GuardianOptions; ValueData: {code:UseGuardian|0}; Components: ServerComponent
Root: HKLM; Subkey: SOFTWARE\FirebirdSQL\Firebird\CurrentVersion; ValueType: string; ValueName: GuardianOptions; ValueData: {code:UseGuardian|0}; Components: ServerComponent

;If use has chosen to start as App they may well want to start automatically. That is handled by a function below.
;Unless we set a marker here the uninstall will leave some annoying debris.
Root: HKLM; Subkey: SOFTWARE\Microsoft\Windows\CurrentVersion\Run; ValueType: string; ValueName: Firebird; ValueData: ""; Flags: uninsdeletevalue; Tasks: UseApplicationTask;

[Icons]
Name: "{group}\Firebird Server"; Filename: {app}\bin\ibserver.exe; Parameters: "-a"; Flags: runminimized; MinVersion: 4.0,4.0; Tasks: MenuGroupTask; Check: InstallServerIcon; IconIndex: 0; Comment: "Run Firebird server (without guardian)";
Name: "{group}\Firebird Guardian"; Filename: {app}\bin\ibguard.exe; Parameters: "-a"; Flags: runminimized; MinVersion: 4.0,4.0; Tasks: MenuGroupTask; Check: InstallGuardianIcon; IconIndex: 1; Comment: "Run Firebird server (with guardian)";
Name: "{group}\Firebird 1.0 Release Notes"; Filename: {app}\doc\Firebird_v1_ReleaseNotes.pdf; MinVersion: 4.0,4.0; Tasks: MenuGroupTask; IconIndex: 1; Comment: "Firebird 1.0 release notes. (Requires Acrobat Reader.)";
Name: "{group}\Firebird 1.0 Readme"; Filename: {app}\readme.txt; MinVersion: 4.0,4.0; Tasks: MenuGroupTask;
Name: "{group}\Uninstall Firebird"; Filename: {uninstallexe}; Comment: "Uninstall Firebird"

[Files]
Source: builds_win32\install\IPLicense.txt; DestDir: {app}; Components: ClientComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: builds_win32\install\readme.txt; DestDir: {app}; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\ibconfig; DestDir: {app}; Components: ServerComponent; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall
Source: interbase\isc4.gdb; DestDir: {app}; Components: ServerComponent; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall
Source: interbase\isc4.gbk; DestDir: {app}; Components: ServerComponent; CopyMode: alwaysoverwrite
Source: interbase\interbase.log; DestDir: {app}; Components: ServerComponent; CopyMode: dontcopy; Flags: uninsneveruninstall skipifsourcedoesntexist external
Source: interbase\interbase.msg; DestDir: {app}; Components: ClientComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\gbak.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\gbak.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite;
Source: interbase\bin\gdef.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\bin\gfix.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\gfix.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite;
Source: interbase\bin\gpre.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\bin\gsec.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\gsec.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\gstat.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\ibguard.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\iblockpr.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\ibserver.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile;
Source: interbase\bin\ib_util.dll; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\instreg.exe; DestDir: {app}\bin; Components: ClientComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\instsvc.exe; DestDir: {app}\bin; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\bin\isql.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\bin\qli.exe; DestDir: {app}\bin; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\doc\*.*; DestDir: {app}\doc; Components: DevAdminComponent; CopyMode: alwaysoverwrite; Flags: skipifsourcedoesntexist external
Source: interbase\help\*.*; DestDir: {app}\help; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\include\*.*; DestDir: {app}\include; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\intl\gdsintl.dll; DestDir: {app}\intl; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\lib\*.*; DestDir: {app}\lib; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\UDF\*.*; DestDir: {app}\UDF; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: interbase\examples\v5\*.*; DestDir: {app}\examples; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: interbase\bin\gds32.dll; DestDir: {sys}\; Components: ClientComponent; CopyMode: normal; Flags: overwritereadonly sharedfile
Source: builds_win32\install\msvcrt.dll; DestDir: {sys}\; Components: ClientComponent; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall sharedfile
Source: extlib\fbudf\Release\fbudf.dll; DestDir: {app}\UDF; Components: ServerComponent; CopyMode: alwaysoverwrite; Flags: sharedfile
Source: extlib\fbudf\fbudf.sql; DestDir: {app}\examples; Components: ServerComponent; CopyMode: alwaysoverwrite
Source: extlib\fbudf\fbudf.txt; DestDir: {app}\doc; Components: ServerComponent; CopyMode: alwaysoverwrite
Source: extlib\ib_util.pas; DestDir: {app}\include; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: firebird\install\doc_all_platforms\Firebird_v1_ReleaseNotes.pdf; DestDir: {app}\doc; Components: DevAdminComponent; CopyMode: alwaysoverwrite
Source: firebird\install\doc_all_platforms\Firebird_v1_*.html; DestDir: {app}\doc; Components: DevAdminComponent; CopyMode: alwaysoverwrite

[UninstallRun]
Filename: {app}\bin\instsvc.exe; Parameters: stop; StatusMsg: "Stopping the service"; MinVersion: 0,4.0; Components: ServerComponent; Flags: runminimized; Tasks: UseServiceTask;
Filename: {app}\bin\instsvc.exe; Parameters: remove -g; StatusMsg: "Removing the service"; MinVersion: 0,4.0; Components: ServerComponent; Flags: runminimized; Tasks: UseServiceTask;
Filename: {app}\bin\instreg.exe; Parameters: remove; StatusMsg: "Updating the registry"; MinVersion: 4.0,4.0; Components: ClientComponent; Flags: runminimized;

[UninstallDelete]
Type: files; Name: {app}\*.lck
Type: files; Name: {app}\*.evn

[_ISTool]
EnableISX=true

[Code]
program Setup;

const
  sWinSock2 = 'ws2_32.dll';
  sNoWinsock2 = 'Please Install Winsock 2 Update before continuing';
  sMSWinsock2Update = 'http://www.microsoft.com/windows95/downloads/contents/WUAdminTools/S_WUNetworkingTools/W95Sockets2/Default.asp';
  sWinsock2Web = 'Winsock 2 is not installed.'#13#13'Would you like to Visit the Winsock 2 Update Home Page?';

var
  Winsock2Failure: Boolean;
  
function CheckWinsock2(): Boolean;
begin
  Result := True;
  //Check if Winsock 2 is installed (win 95 only)
  if (not UsingWinNt) and (not FileExists(AddBackslash(GetSystemDir) + sWinSock2)) then begin
    Winsock2Failure := True;
    Result := False;
    end
  else
  	Winsock2Failure := False;
end;

procedure DeInitializeSetup();
var
  ErrCode: Integer;
begin
  // Did the install fail because winsock 2 was not installed?
  if Winsock2Failure then
    // Ask user if they want to visit the Winsock2 update web page.
  	if MsgBox(sWinsock2Web, mbInformation, MB_YESNO) = idYes then
  	  // User wants to visit the web page
      InstShellExec(sMSWinsock2Update, '', '', SW_SHOWNORMAL, ErrCode);
end;

function InitializeSetup(): Boolean;
var
  i: Integer;
begin
  result := true;

  if not CheckWinsock2 then
    exit;

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

  Result := ExpandConstant(sRootDir);

end;

function UseGuardian(Default: String): String;
begin
if ShouldProcessEntry('ServerComponent', 'UseGuardianTask')= srYes then
  Result := '1'
else
  Result := '0';
end;

function ServiceStartFlags(Default: String): String;
begin
  Result := '';
  if ShouldProcessEntry('ServerComponent', 'UseGuardianTask')= srYes then begin
    if ShouldProcessEntry('ServerComponent', 'AutoStartTask')= srYes then
      Result := ' -auto -g '
    else
      Result := ' -g ';
    end
  else
    if ShouldProcessEntry('ServerComponent', 'AutoStartTask')= srYes then
      Result := ' -auto ';

end;

function InstallGuardianIcon(): Boolean;
begin
  result := false;
  if ShouldProcessEntry('ServerComponent', 'UseApplicationTask')= srYes then
    if ShouldProcessEntry('ServerComponent', 'UseGuardianTask')= srYes then
      result := true;
end;

function InstallServerIcon(): Boolean;
begin
  result := false;
  if ShouldProcessEntry('ServerComponent', 'UseApplicationTask')= srYes then
    if ShouldProcessEntry('ServerComponent', 'UseGuardianTask')= srNo then
      result := true;
end;

function StartApp(Default: String): String;
var
  AppPath: String;
begin
  AppPath:=ExpandConstant('{app}');
  //Now start the app as
  if ShouldProcessEntry('ServerComponent', 'UseGuardianTask')= srYes then
    Result := AppPath+'\bin\ibguard.exe'
  else
    Result := AppPath+'\bin\ibserver.exe';
end;

procedure CurStepChanged(CurStep: Integer);
var
  AppStr: String;
begin
if CurStep=csFinished then begin
  //If user has chosen to install an app and run it automatically set up the registry accordingly
  //so that the server or guardian starts evertime they login.
  if ShouldProcessEntry('ServerComponent', 'AutoStartTask')= srYes then begin
    AppStr := StartApp('')+' -a';

    RegWriteStringValue (HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'Firebird', AppStr);

  end;
end;

end;


begin
end.
