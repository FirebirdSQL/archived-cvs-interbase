# Microsoft Developer Studio Project File - Name="FBControl" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=FBControl - Win32 TestDebug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "FBControl.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "FBControl.mak" CFG="FBControl - Win32 TestDebug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "FBControl - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "FBControl - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "FBControl - Win32 TestDebug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "FBControl - Win32 Release"

# PROP BASE Use_MFC 5
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 5
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_WINDLL" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /MT /W3 /GX /Ox /Ow /Og /Os /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "SUPERSERVER" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x809 /d "NDEBUG"
# ADD RSC /l 0x40c /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /machine:I386 /out:"Release/FirebirdControl.cpl"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "FBControl - Win32 Debug"

# PROP BASE Use_MFC 5
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "FBControl___Win32_Debug"
# PROP BASE Intermediate_Dir "FBControl___Win32_Debug"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 5
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr /YX /FD /GZ /c
# SUBTRACT BASE CPP /X
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr /YX /FD /GZ /c
# SUBTRACT CPP /X
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x809 /d "_DEBUG"
# ADD RSC /l 0x809 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 gds32_ms.lib shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /debug /machine:I386 /out:"c:/winnt/system32/FBControl.cpl" /pdbtype:sept /libpath:"$(INTERBASE)/lib"
# ADD LINK32 gds32_ms.lib shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /debug /machine:I386 /out:"Debug/FirebirdControl.cpl" /pdbtype:sept /libpath:"$(INTERBASE)/lib"

!ELSEIF  "$(CFG)" == "FBControl - Win32 TestDebug"

# PROP BASE Use_MFC 5
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "FBControl___Win32_TestDebug"
# PROP BASE Intermediate_Dir "FBControl___Win32_TestDebug"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 5
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "TestDebug"
# PROP Intermediate_Dir "TestDebug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr /YX /FD /GZ /c
# SUBTRACT BASE CPP /X
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr /YX /FD /GZ /c
# SUBTRACT CPP /X
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x809 /d "_DEBUG"
# ADD RSC /l 0x809 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 gds32_ms.lib shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /debug /machine:I386 /out:"c:/winnt/system32/FBControl.cpl" /pdbtype:sept /libpath:"$(INTERBASE)/lib"
# ADD LINK32 gds32_ms.lib shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /debug /machine:I386 /out:"c:/winnt/system32/FirebirdControl.cpl" /pdbtype:sept /libpath:"$(INTERBASE)/lib"

!ENDIF 

# Begin Target

# Name "FBControl - Win32 Release"
# Name "FBControl - Win32 Debug"
# Name "FBControl - Win32 TestDebug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\ctrlpan.cpp
# End Source File
# Begin Source File

SOURCE=.\FBControl.cpp
# End Source File
# Begin Source File

SOURCE=.\FBControl.def
# End Source File
# Begin Source File

SOURCE=.\FBDialog.cpp
# End Source File
# Begin Source File

SOURCE=.\FBPanel.cpp
# End Source File
# Begin Source File

SOURCE=..\services.c
# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp
# ADD CPP /Yc"stdafx.h"
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\ctrlpan.h
# End Source File
# Begin Source File

SOURCE=.\FBControl.h
# End Source File
# Begin Source File

SOURCE=.\FBDialog.h
# End Source File
# Begin Source File

SOURCE=.\FBPanel.h
# End Source File
# Begin Source File

SOURCE=..\registry.h
# End Source File
# Begin Source File

SOURCE=.\Resource.h
# End Source File
# Begin Source File

SOURCE=.\servi_proto.h
# End Source File
# Begin Source File

SOURCE=.\StdAfx.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\FBControl.rc
# End Source File
# Begin Source File

SOURCE=.\res\FBControl.rc2
# End Source File
# Begin Source File

SOURCE=.\res\icon4.ico
# End Source File
# Begin Source File

SOURCE=.\res\salrt23i.ico
# End Source File
# Begin Source File

SOURCE=.\res\server.ico
# End Source File
# Begin Source File

SOURCE=.\res\server_stop.ico
# End Source File
# Begin Source File

SOURCE=.\res\sgard23i.ico
# End Source File
# End Group
# End Target
# End Project
