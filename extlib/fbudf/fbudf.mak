# Microsoft Developer Studio Generated NMAKE File, Based on fbudf.dsp
!IF "$(CFG)" == ""
CFG=fbudf - Win32 Debug
!MESSAGE No configuration specified. Defaulting to fbudf - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "fbudf - Win32 Release" && "$(CFG)" != "fbudf - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "fbudf.mak" CFG="fbudf - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "fbudf - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "fbudf - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "fbudf - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\fbudf.dll"


CLEAN :
	-@erase "$(INTDIR)\fbudf.obj"
	-@erase "$(INTDIR)\fbudf.pch"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\fbudf.dll"
	-@erase "$(OUTDIR)\fbudf.exp"
	-@erase "$(OUTDIR)\fbudf.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "$(INTERBASE)/include" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "FBUDF_EXPORTS" /Fp"$(INTDIR)\fbudf.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\fbudf.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=GDS32_MS.LIB /nologo /dll /incremental:no /pdb:"$(OUTDIR)\fbudf.pdb" /machine:I386 /out:"$(OUTDIR)\fbudf.dll" /implib:"$(OUTDIR)\fbudf.lib" /libpath:"$(INTERBASE)/lib" 
LINK32_OBJS= \
	"$(INTDIR)\fbudf.obj" \
	"$(INTDIR)\StdAfx.obj"

"$(OUTDIR)\fbudf.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "fbudf - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\fbudf.dll"


CLEAN :
	-@erase "$(INTDIR)\fbudf.obj"
	-@erase "$(INTDIR)\fbudf.pch"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\fbudf.dll"
	-@erase "$(OUTDIR)\fbudf.exp"
	-@erase "$(OUTDIR)\fbudf.ilk"
	-@erase "$(OUTDIR)\fbudf.lib"
	-@erase "$(OUTDIR)\fbudf.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W4 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "FBUDF_EXPORTS" /D "_WINDLL" /Fp"$(INTDIR)\fbudf.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\fbudf.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=GDS32_MS.LIB /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\fbudf.pdb" /debug /machine:I386 /out:"$(OUTDIR)\fbudf.dll" /implib:"$(OUTDIR)\fbudf.lib" /pdbtype:sept /libpath:"$(INTERBASE)/lib" 
LINK32_OBJS= \
	"$(INTDIR)\fbudf.obj" \
	"$(INTDIR)\StdAfx.obj"

"$(OUTDIR)\fbudf.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("fbudf.dep")
!INCLUDE "fbudf.dep"
!ELSE 
!MESSAGE Warning: cannot find "fbudf.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "fbudf - Win32 Release" || "$(CFG)" == "fbudf - Win32 Debug"
SOURCE=.\fbudf.cpp

"$(INTDIR)\fbudf.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\fbudf.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "fbudf - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "$(INTERBASE)/include" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "FBUDF_EXPORTS" /Fp"$(INTDIR)\fbudf.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\fbudf.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "fbudf - Win32 Debug"

CPP_SWITCHES=/nologo /MTd /W4 /Gm /GX /ZI /Od /I "$(INTERBASE)/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "FBUDF_EXPORTS" /D "_WINDLL" /Fp"$(INTDIR)\fbudf.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\fbudf.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

