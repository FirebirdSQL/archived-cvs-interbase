# Microsoft Developer Studio Generated NMAKE File, Based on FBControl.dsp
!IF "$(CFG)" == ""
CFG=FBControl - Win32 TestDebug
!MESSAGE No configuration specified. Defaulting to FBControl - Win32 TestDebug.
!ENDIF 

!IF "$(CFG)" != "FBControl - Win32 Release" && "$(CFG)" != "FBControl - Win32 Debug" && "$(CFG)" != "FBControl - Win32 TestDebug"
!MESSAGE Invalid configuration "$(CFG)" specified.
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
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "FBControl - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\FBControl.cpl" "$(OUTDIR)\FBControl.pch" "$(OUTDIR)\FBControl.bsc"


CLEAN :
	-@erase "$(INTDIR)\ctrlpan.obj"
	-@erase "$(INTDIR)\ctrlpan.sbr"
	-@erase "$(INTDIR)\FBControl.obj"
	-@erase "$(INTDIR)\FBControl.pch"
	-@erase "$(INTDIR)\FBControl.res"
	-@erase "$(INTDIR)\FBControl.sbr"
	-@erase "$(INTDIR)\FBDialog.obj"
	-@erase "$(INTDIR)\FBDialog.sbr"
	-@erase "$(INTDIR)\FBPanel.obj"
	-@erase "$(INTDIR)\FBPanel.sbr"
	-@erase "$(INTDIR)\services.obj"
	-@erase "$(INTDIR)\services.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\FBControl.bsc"
	-@erase "$(OUTDIR)\FBControl.cpl"
	-@erase "$(OUTDIR)\FBControl.exp"
	-@erase "$(OUTDIR)\FBControl.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MT /W3 /GX /Ox /Ow /Og /Os /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "SUPERSERVER" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\FBControl.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC_PROJ=/l 0x40c /fo"$(INTDIR)\FBControl.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\FBControl.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\ctrlpan.sbr" \
	"$(INTDIR)\FBControl.sbr" \
	"$(INTDIR)\FBDialog.sbr" \
	"$(INTDIR)\FBPanel.sbr" \
	"$(INTDIR)\services.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\FBControl.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\FBControl.pdb" /machine:I386 /def:".\FBControl.def" /out:"$(OUTDIR)\FBControl.cpl" /implib:"$(OUTDIR)\FBControl.lib" 
DEF_FILE= \
	".\FBControl.def"
LINK32_OBJS= \
	"$(INTDIR)\ctrlpan.obj" \
	"$(INTDIR)\FBControl.obj" \
	"$(INTDIR)\FBDialog.obj" \
	"$(INTDIR)\FBPanel.obj" \
	"$(INTDIR)\services.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\FBControl.res"

"$(OUTDIR)\FBControl.cpl" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "FBControl - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\FBControl.cpl" "$(OUTDIR)\FBControl.pch" "$(OUTDIR)\FBControl.bsc"


CLEAN :
	-@erase "$(INTDIR)\ctrlpan.obj"
	-@erase "$(INTDIR)\ctrlpan.sbr"
	-@erase "$(INTDIR)\FBControl.obj"
	-@erase "$(INTDIR)\FBControl.pch"
	-@erase "$(INTDIR)\FBControl.res"
	-@erase "$(INTDIR)\FBControl.sbr"
	-@erase "$(INTDIR)\FBDialog.obj"
	-@erase "$(INTDIR)\FBDialog.sbr"
	-@erase "$(INTDIR)\FBPanel.obj"
	-@erase "$(INTDIR)\FBPanel.sbr"
	-@erase "$(INTDIR)\services.obj"
	-@erase "$(INTDIR)\services.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\FBControl.bsc"
	-@erase "$(OUTDIR)\FBControl.cpl"
	-@erase "$(OUTDIR)\FBControl.exp"
	-@erase "$(OUTDIR)\FBControl.ilk"
	-@erase "$(OUTDIR)\FBControl.lib"
	-@erase "$(OUTDIR)\FBControl.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\FBControl.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC_PROJ=/l 0x809 /fo"$(INTDIR)\FBControl.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\FBControl.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\ctrlpan.sbr" \
	"$(INTDIR)\FBControl.sbr" \
	"$(INTDIR)\FBDialog.sbr" \
	"$(INTDIR)\FBPanel.sbr" \
	"$(INTDIR)\services.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\FBControl.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=gds32_ms.lib shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /incremental:yes /pdb:"$(OUTDIR)\FBControl.pdb" /debug /machine:I386 /def:".\FBControl.def" /out:"$(OUTDIR)\FBControl.cpl" /implib:"$(OUTDIR)\FBControl.lib" /pdbtype:sept /libpath:"$(INTERBASE)/lib" 
DEF_FILE= \
	".\FBControl.def"
LINK32_OBJS= \
	"$(INTDIR)\ctrlpan.obj" \
	"$(INTDIR)\FBControl.obj" \
	"$(INTDIR)\FBDialog.obj" \
	"$(INTDIR)\FBPanel.obj" \
	"$(INTDIR)\services.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\FBControl.res"

"$(OUTDIR)\FBControl.cpl" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "FBControl - Win32 TestDebug"

OUTDIR=.\TestDebug
INTDIR=.\TestDebug
# Begin Custom Macros
OutDir=.\TestDebug
# End Custom Macros

ALL : "c:\winnt\system32\FBControl.cpl" "$(OUTDIR)\FBControl.pch" "$(OUTDIR)\FBControl.bsc"


CLEAN :
	-@erase "$(INTDIR)\ctrlpan.obj"
	-@erase "$(INTDIR)\ctrlpan.sbr"
	-@erase "$(INTDIR)\FBControl.obj"
	-@erase "$(INTDIR)\FBControl.pch"
	-@erase "$(INTDIR)\FBControl.res"
	-@erase "$(INTDIR)\FBControl.sbr"
	-@erase "$(INTDIR)\FBDialog.obj"
	-@erase "$(INTDIR)\FBDialog.sbr"
	-@erase "$(INTDIR)\FBPanel.obj"
	-@erase "$(INTDIR)\FBPanel.sbr"
	-@erase "$(INTDIR)\services.obj"
	-@erase "$(INTDIR)\services.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\FBControl.bsc"
	-@erase "$(OUTDIR)\FBControl.exp"
	-@erase "$(OUTDIR)\FBControl.lib"
	-@erase "$(OUTDIR)\FBControl.pdb"
	-@erase "c:\winnt\system32\FBControl.cpl"
	-@erase "c:\winnt\system32\FBControl.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\FBControl.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC_PROJ=/l 0x809 /fo"$(INTDIR)\FBControl.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\FBControl.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\ctrlpan.sbr" \
	"$(INTDIR)\FBControl.sbr" \
	"$(INTDIR)\FBDialog.sbr" \
	"$(INTDIR)\FBPanel.sbr" \
	"$(INTDIR)\services.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\FBControl.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=gds32_ms.lib shlwapi.lib /nologo /version:1.0 /subsystem:windows /dll /incremental:yes /pdb:"$(OUTDIR)\FBControl.pdb" /debug /machine:I386 /def:".\FBControl.def" /out:"c:/winnt/system32/FBControl.cpl" /implib:"$(OUTDIR)\FBControl.lib" /pdbtype:sept /libpath:"$(INTERBASE)/lib" 
DEF_FILE= \
	".\FBControl.def"
LINK32_OBJS= \
	"$(INTDIR)\ctrlpan.obj" \
	"$(INTDIR)\FBControl.obj" \
	"$(INTDIR)\FBDialog.obj" \
	"$(INTDIR)\FBPanel.obj" \
	"$(INTDIR)\services.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\FBControl.res"

"c:\winnt\system32\FBControl.cpl" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("FBControl.dep")
!INCLUDE "FBControl.dep"
!ELSE 
!MESSAGE Warning: cannot find "FBControl.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "FBControl - Win32 Release" || "$(CFG)" == "FBControl - Win32 Debug" || "$(CFG)" == "FBControl - Win32 TestDebug"
SOURCE=.\ctrlpan.cpp

"$(INTDIR)\ctrlpan.obj"	"$(INTDIR)\ctrlpan.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\FBControl.cpp

"$(INTDIR)\FBControl.obj"	"$(INTDIR)\FBControl.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\FBDialog.cpp

"$(INTDIR)\FBDialog.obj"	"$(INTDIR)\FBDialog.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\FBPanel.cpp

"$(INTDIR)\FBPanel.obj"	"$(INTDIR)\FBPanel.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=..\services.c

"$(INTDIR)\services.obj"	"$(INTDIR)\services.sbr" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "FBControl - Win32 Release"

CPP_SWITCHES=/nologo /MT /W3 /GX /Ox /Ow /Og /Os /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "SUPERSERVER" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\FBControl.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\FBControl.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "FBControl - Win32 Debug"

CPP_SWITCHES=/nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\FBControl.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\FBControl.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "FBControl - Win32 TestDebug"

CPP_SWITCHES=/nologo /MTd /W3 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "_WINDLL" /D "CPL_APPLET" /D "SUPERSERVER" /U "TRACE" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\FBControl.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\FBControl.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\FBControl.rc

"$(INTDIR)\FBControl.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

