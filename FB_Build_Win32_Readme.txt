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
:: Contributor(s): ______________________________________.

/*
 *
 * Building Firebird on Win32 platforms
 *
 * Release Notes
 *
 *
 * See the change history at the top of the FB_Build_Win32.bat 
 * for details of new features and changed behaviour.
 *
 */


CONTENTS
--------

o WHAT'S NEW?
o INTRODUCTION
o REQUIREMENTS
o PREPARING TO BUILD
o SETTING UP THE BUILD DATABASES
o SETTING UP THE BUILD ENVIRONMENT
o WHAT NEXT
o CLEANING UP
o TIPS for working at the Command Prompt


INTRODUCTION
------------

This document discusses how to use the FB_Build_Win32 batch files to
do a build of Firebird on the Win32 platform. The aim of this set
of batch files is:

  o To simplify the Win32 build process
  o To remove the dependancy upon Cygwin
  o To automate as many of the preparations as possible


REQUIREMENTS
------------

o Operating System

  The following operating systems are supported:

    Win NT v4.0
    Win 2000

  It is anticipated that all versions of Win XP will also work.

o Disk space

  Once built, the compiled code, object files and source code will
  occupy over 60Mb of space on a compressed NTFS drive.

o Processor and RAM

  No minimum specification is required. The heritage of Firebird
  goes back to the days when processors were slower and memory expensive.
  It will build on anything that you can run the O/S on. On slow
  Pentiums expect the build to take a good half an hour. On the latest
  fast processors expect five to ten minutes.

o Compiler

  Building Firebird for Windows requires Microsoft Visual C++ v5
  or later. If the subsequent build is intended for a production
  environment the professional version should be used. This applies
  compiler optimisations not found in the standard version. However,
  in all other respects the standard version is fine.

o Other tools

  The build requires the Borland Make, available with all their
  compiler products. Borland Touch.exe is also required and should be 
  earlier on the path than other versions of touch.exe. Additionally, 
  some parts of the build require ImpLib and brc32. These are shipped 
  with the freely downloadable Borland C v5.5 compiler.

  You will also require a small subset of Unix Tools compiled for
  Win32. These are available from:

    http://firebird.sourceforge.net/download

  Filename:

    Firebird_Unix_Tools_for_Win32.zip




PREPARING TO BUILD
------------------

The batch files do almost all the work for you, but there are a
couple of things you need to do before you start the build.

o Make sure that the INTERBASE environment variable is set to the
  location of the root of the current Firebird or InterBase 
  install directory.

  ie, if you have installed it in c:\program files\firebird then set
  INTERBASE=c:\program files\firebird.

o Make sure that Interbase 6 or Firebird is running on this computer

o Place the required Unix tools in a location that is on your path,
  or add the path to the tools to your path.

  (See Control Panel | System | Environment).

o Check your path statement by typing PATH at a command prompt.

  If you have Cygwin and Borland C installed ensure sure that the
  Borland Make is discovered before the Cygwin / Gnu Make.

  Likewise, make sure that your Microsoft C compiler is on the path.

  You will also need to add %INTERBASE%\bin to the path.

o Copy the source
  If you have this readme you probably have the source. If not, get it.
  It is recommended that you work on a copy, although this may not
  always be possible.

o Open a console window.
  Everything is built from a command prompt. Make sure that you have
  not disabled command extensions!

  Change to the directory that contains the source and you
  are ready to go ie, if your source is in c:\code\firebird\interbase
  then do a cd to c:\code\firebird\interbase. You must start from the root
  of the source code tree.

o Put the Win32 Build batch files in the source root.
  The FB_Build_Win32*.bat files must run from the root directory
  of the source. They may already be there. If not - put them there.

o Ensure that ISC_USER and ISC_PASSWORD system variables are set correctly
  to current SYSDBA/password. If not, all bat files will use default
  SYSDBA/masterkey.

o Add user=builder password=builder with gsec or any other tool that allows
  you to add/modify/delete users.


SETTING UP THE BUILD DATABASES
------------------------------

Firebird 1.0 is partially built from information stored in existing
databases. Together they form a database tree that must be available
at build time. To build this tree you run:

  FB_Build_Win32_Build_DBs.bat drive:\path

The path given must be on the current drive and must be the full path.
ie, if you are on the C: drive you might type something like

    FB_Build_Win32_Build_DBs.bat c:\firebird\build_dbs

The batch file will then create the necessary databases.

This directory tree only needs to persist for the lifetime of the
build. You can delete it and recreate it as required.

Once it is built you can move it somewhere else if you wish.
The build takes the location of the build databases as a separate
parameter and any valid Firebird location (server:drive:\path) is
allowed. However, it is recommended that you leave this database 
tree in a location that can be accessed locally from a command 
prompt.


SETTING UP THE BUILD ENVIRONMENT
--------------------------------

After you have created the build databases you are ready for the
final step - preparing the source for the build. This is done by
running FB_Build_Win32.bat from the console. Here is a typical
command line:

  FB_Build_Win32.bat x:\path\to\build_dbs

There are a couple of points to note here.

 o You can specify a remote database path in the normal manner.
   However, this should be avoided if possible, as it will not be
   possible to test if the messages database is up-to-date.

 o Optionally you can add a second parameter -DDEV if you wish
   to do a debug build. There is a glitch in the Win32 build
   process and it will break if you try to do a development build
   before you have done a production build. So don't pass -DDEV
   on the first time around.

The batch file does a few checks to make sure that you have carried out
all the preceding instructions correctly. It then proceeds to set up the
necessary directory structures and create the databases needed for the
build.

When the build preparations are complete it then calls 'build_lib.bat'.
This is the batch file which actually does the build. A second console
window is opened and tail is used to follow the output. At this point,
just sit back and enjoy the show.

Don't worry about the myriad of warnings. They are known and expected.
However, if any error is triggered the build will immediately stop.

When build_lib.bat stops you will see either BUILD_FAIL or BUILD_OK
somewhere on the screen. If the build has failed then open up
build_lib_PROD_nnn.log or build_lib_DEV_nnn.log (depending on which
build type you have chosen) and check for the error at the end. Once
you have remedied the problem just close the secondary console windows,
'up arrow' in the main console window and re-run your FB_Build_Win32
command.

If you have done a DEV build the source browser database will now be 
automatically built for you. You can use this to help debug the new
server.


WHAT NEXT
---------

If you have BUILD_OK then congratulations! You have successfully built
Firebird on Win32. Now you need to test it. That is a subject for
another day.


CLEANING UP
-----------

If you want to restore your source tree and environment to a pristine 
state then run 

  FB_build_Win32.bat CLEAN

This will have the following effect

  o All environment variables set by the build will be cleared.

  o (Almost) all files created during the build will be deleted.

    NOTE: The Build logs will remain at the root of the 
    source directory. Rename, delete, or move them as required.
    They are automatically overwritten by subsequent builds of
    the same build number.

  o The Build_DBs tree is left untouched.

Alternatively, you can run

  FB_build_Win32.bat CLEAN ENV

and clear just the environment variables that were set by the 
build process.


TIPS for working at the Command Prompt
--------------------------------------

Scrollable Consoles:

  Open the Properties dialogue of a Console window. In the Screen Buffer
  Size set the Height = 5000 and the Width = 96. When prompted, save
  properties for future windows. This will give you a scrollable console
  Window. You will be able to retrieve the output from an entire session
  this way.


Command-Line Completion in a Console:

  In the registry find this key

    HKEY_CURRENT_USER\Software\Microsoft\Command Processor

  and set this value

    CompletionChar = 9

  Then type a letter at the prompt, press the TAB key and an attempt
  will be be to complete the command. Not as neat as under a Unix shell,
  but way better than nothing.


Saving session commands:

  The Console doesn't save the command history from session to session.
  However if you type:

    Doskey /history > %temp%\history.txt

  you can write out each unique command you have typed in this
  session. If you really don't want to lose anything, go into the
  Console Properties dialogue to increase the buffer size and
  uncheck 'Discard old duplicates'.


Retrieving a command:

  Press F7 to get a list of commands you have typed during the current
  session. See Doskey /? for more info on working with the command
  history.


(If you have comments or amendments to make to this document please
 email preeves@ibphoenix.com)
