Firebird Database Server 1.0
============================

This document is a guide to installation of Firebird on 
the Win32 platform.

Contents
--------

o Before installation
o Installing on a system with InterBase
o Installation assumptions
o Uninstallation
o Other Notes
o Installation from a batch file


Before Installation
-------------------

  IMPORTANT!

  This installation package will try to detect if an existing
  version of Firebird or InterBase is installed and/or running.

  You must either STOP the current server and/or remove the 
  currently installed version before continuing.


  Stopping the Server

  o If it is running as a service stop it via 'Control Panel | Services'.
  o If it is running as an application just close it by right-clicking on 
    the taskbar icon and selecting 'Shutdown'.


  Removing an existing server
  
  It is recommended that you uninstall a previous version of Firebird 
  or InterBase, but it is not a requirement. See the Uninstallation 
  section below for more details of the Firebird uninstallation routine.


Installing on a system with InterBase
-------------------------------------

  Firebird 1.0 cannot be run at the same time as InterBase (any version). 
  You must uninstall InterBase before installing Firebird. This may change 
  with future releases. 

  It is recommended that you do NOT install Firebird over an existing 
  InterBase install. Install it to a new directory and use gbak to backup
  your old isc4.gdb. Restore it under a new name. Stop the Firebird server.
  Rename the database to isc4.gdb and then restart the server.

  If you have special settings in ibconfig you can place them in the new 
  ibconfig. Don't forget that they wont take effect until you restart the
  server.

Installation assumptions
------------------------

  o Admin rights are needed to install Firebird as a service. This requirement 
    does not apply to Win95, Win98 or Win ME.

  o If an existing, newer version of GDS32.DLL exists you will be prompted to 
    overwrite it. It is recommended to answer YES if you are doing a server 
    install.

  o If an existing version of MSVCRT.DLL exists it is no longer updated. The 
    installation will install it only if it does not exist on the target
    system.

  o If certain configuration files exist in the installation directory 
    they will preserved. The files are

      isc4.gdb
      interbase.log
      ibconfig



Uninstallation
--------------

  The Firebird uninstall routine preserves the following key files:

    isc4.gdb
    interbase.log
    ibconfig

  No attempt is made to uninstall files that were not part of the original 
  installation.

  Shared files such as gds32.dll will be deleted if the share count 
  indicates that no other application is using it.

  The registry keys that were created will be removed.

  The uninstallation routine will not stop a server running as an application. 
  It will leave the server running but continue with the uninstall. The server 
  (and probably the Guardian, too) will need to be stopped and deleted manually.

  The uninstallation routine will stop and delete a server that has been installed
  as a service.


Other Notes
-----------

  Firebird requires WinSock2. All Win32 platforms should have this, except
  for Win95. A test for the Winsock2 library is made during install. If
  it is not found the install will fail. You can visit this link:

    http://support.microsoft.com/default.aspx?scid=kb;EN-US;q177719

  to find out how to go about upgrading.


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
