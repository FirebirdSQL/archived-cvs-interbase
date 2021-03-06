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
:: Contributor(s): _______________________________________________.
::

@echo off
::  This batch file is used to clean a source tree that has
::  previously built a version of Firebird. It primarily removes
::  object files, debug files (*.sbr,*.pdb) and the builds in the
::  interbase and ib_debug directories
:: 
:: This script originally built by Paul Reeves 13-Apr-2001
::
:: Change History
:: 10-Dec-2001  Added code to clean out gpre generated files,            PR
::              .rsp files, .gbk files in example5,
::              msgs\interbase.msg.
::


if NOT "%1"=="do_it" goto :HELP

echo Cleaning source tree ...

set IB_COMPONENTS=alice burp dsql dudley example5 extlib gpre intl ipserver isql iscguard jrd lock msgs qli remote utilities wal

::Note: Dudley\ddl.c, expand.c, expr.c generate.c hsh.c lex.c parse.c trn.c
::      are listed as dot_e_files in the Makefile for Dudley. They are NOT!

for %%V in (%IB_COMPONENTS%) do (
  cd %%V
  echo cleaning component %%V ...
  del /q *.sbr
  del /q *.pdb
  del /q *.exe
  del /q *.gdb
  del /q *.rsp
  del /q makefile.lib
  del /q .cvsignore

  (if "%%V"=="alice"     (del /q met.c ))
  (if "%%V"=="burp"      (del /q backup.c restore.c burp.exe ))
  (if "%%V"=="dsql"      (del /q array.c blob.c metd.c dot_e_files ))
  (if "%%V"=="dudley"    (del /q exe.c extract.c dudley.exe ))
  (if "%%V"=="example5"  (del /q *.gbk intlbld.c *.ilk dbs makefile.bc makefile.msc ))
  (if "%%V"=="extlib"    (del /q *.bind ))

  (if "%%V"=="gpre"      (del /q met.c gpre.exe ))
  (if "%%V"=="isql"      (del /q extract.c isql.c show.c isql.exe ))
  (if "%%V"=="iscguard"  (del /q iscguard.exe ))
  (if "%%V"=="intl"      (del /q gdsintl*.* ))

  (if "%%V"=="jrd"       (del /q blf.c codes.c dfw.c dpm.c dyn.c dyn_def.c dyn_del.c dyn_mod.c dyn_util.c envelope.c fun.c grant.c ini.c met.c pcmet.c scl.c stats.c ))
  (if "%%V"=="jrd"       (del /q debug_entry.bind dot_e_files gds.h gds32*.bind gdsalias.asm ibeng32*.bind))

  (if "%%V"=="lock"      (del /q iblockpr.exe ))
  (if "%%V"=="msgs"      (del /q build_file.c change_msgs.c check_msgs.c enter_msgs.c modify_msgs.c interbase.msg *.exe indicator.* ))
  (if "%%V"=="qli"       (del /q help.c meta.c proc.c show.c qli.exe ))
  (if "%%V"=="utilities" (del /q dba.c security.c dba.exe gsec.exe install_reg.exe install_svc.exe print_pool.exe fbcpl\Release\*.* ))
  (if exist MS_obj\nul   (rmdir /s /q MS_obj))
  cd ..
  )

if exist interbase\nul rmdir /s /q interbase
if exist ib_debug\nul rmdir /s /q ib_debug

for %%V in ( include.mak compress_dbs.bat expand_dbs.bat expand_cfile.bat builds_win32\metadata.gdb) do (
  echo Deleting %%V
  if exist %%V del /q %%V
  )

del /q *template.bat
del /q builds_win32\*.sed
del /q std.mk

(goto :EOF)

:HELP
@echo:
@echo   This script must be run from the top of source directory
@echo   tree. It is quite dangerous, as it will delete whole directory
@echo   trees without prompting. However, they are generated by the
@echo   build process, so you shouldn't have put your stuff there
@echo   anyway.
@echo:
@echo   To run this script pass "do_it" as a parameter.
@echo:
@echo     ie FB_Build_Win32_Clean.bat do_it
@echo:


:EOF


