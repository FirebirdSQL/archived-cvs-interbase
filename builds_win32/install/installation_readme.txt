Firebird Database Server 1.0
============================

This document is a guide to installation of Firebird on 
the Win32 platform.

Contents
--------

o Before installation
o Other Notes

Before Installation
-------------------

  IMPORTANT!

  This installation package will try to detect if an existing
  version of Firebird or InterBase is installed and/or running.

  You must either STOP the current server and/or delete the 
  currently installed version before continuing.


  Stopping the Server

  o If it is running as a service stop it from the Control Panel.
  o If it is an application just close it.


Other Notes
-----------

  Admin rights are needed to install Firebird as a service.

  This install script does nothing with the guardian (ibguard.exe). 
  There are no tools provided to run the guardian as a service. The only
  platform where this may present a problem is under Win NT. Here a user
  with admin rights is needed to restart ibserver as a server in the event
  of ibserver crashing. A later install package will include the option 
  to install the guardian as a service.


Installation from a batch file
------------------------------

The setup program can be run from a batch file. This is useful if you wish
to install the client across a network. The following parameters may be passed:


/SP- 
  Disables the This will install... Do you wish to continue? prompt at 
  the beginning of Setup. 

/SILENT, /VERYSILENT 
  Instructs Setup to be silent or very silent. When Setup is silent the 
  wizard and the background window are not displayed but the installation 
  progress window is. When a setup is very silent this installation 
  progress window is not displayed. Everything else is normal so for 
  example error messages during installation are displayed and the startup 
  prompt is (if you haven't disabled it with  the '/SP-' command line option 
  explained above) 

  If a restart is necessary and the '/NORESTART' command isn't used 
  (see below) and Setup is silent, it will display a Reboot now? 
  messagebox. If it's very silent it will reboot without asking. 

/NORESTART 
  Instructs Setup not to reboot even if it's necessary. 

/DIR="x:\dirname"  
  Overrides the default directory name displayed on the Select Destination 
  Directory wizard page. A fully qualified pathname must be specified. If 
  the [Setup] section directive DisableDirPage was set to yes, this command 
  line parameter is ignored. 

/GROUP="folder name" 
  Overrides the default folder name displayed on the Select Start Menu Folder 
  wizard page. If the [Setup] section directive DisableProgramGroupPage was 
  set to yes, this command line parameter is ignored. 

/NOICONS 
  Instructs Setup to initially disable the Don't create any icons check box 
  on the Select Start Menu Folder wizard page. 

/COMPONENTS="component name" 

  Choose from - Server, DevTools and Client

  Overrides the default components settings. Using this command line parameter 
  causes Setup to automatically select a custom type. 
