
==================================
Firebird 1.0.0 Release Candidate 2
         (Win32 Build)
==================================


o Introduction
o Intended Users
o Installation
o Known Issues
o Reporting Bugs
o Requesting New Features


Introduction
============

Welcome to Firebird 1.0.0 RC2. This represents a feature complete
build of Firebird 1.0. It is the product of many months work by the 
Firebird team. See the Release Notes document for details of al the 
new features and the bug-fixes it contains. 


Intended Users
==============

Overall we believe this release to be more stable and more reliable than ANY 
previous release of Firebird or InterBase 6.n. As such there is no reason to 
be overly concerned about using it in a production environment. However, 
before deploying ANY software into a production environment it should always 
be tested properly on a development system. This applies to the current 
release as much as ever.

If you have extracted this file from Firebird-1.0.0-RC2-Win32.zip then you 
have the snapshot build only. It is recommended that the snapshot build of 
RC2 be deployed onto a system that already has an installation of Firebird 
or InterBase. These notes do not document installation of a snapshot build 
onto a clean system.

If you have the self-installing Win32 executable then you may be more 
adventurous in deploying it. 


Installating the snapshot .zip file
===================================


If you have a snapshot build it is recommended that you install over 
an existing install of Firebird or InterBase 6.n

o Stop the InterBase service (if one is running) or else close the 
  ibserver.exe if it is running as an application

o Extract all the files from the archive to the current Firebird or 
  InterBase directory.

o In Control Panel 

    - make sure you have the INTERBASE environment variable defined as a 
      system variable (not user).

    - Prefix your PATH statement with %INTERBASE%\bin

o Rename %SYSTEM32%\gds32.dll to %SYSTEM32%\gds32.dll.orig

o If isc4.gdb does not exist then rename 'Copy of isc4.gdb' to isc4.gdb.

o Restart the InterBase service via the control panel or run the 
  ibserver.exe application


Installing the self-installing executable
=========================================

Pleas run the executable and read the accompanying installation 
instructions that are contained within the setup wizard.


Known Issues
============

There are no known issues at this time. (20-Dec-2001). IBPhoenix are 
maintaining a FAQ of issues that arise out of the RC builds. You can 
see this in the doc/ directory. The latest version is available 
from http://www.ibphoenix.com


Reporting Bugs
==============

o Are you sure you understand how Firebird works?

  Perhaps you are seeing the correct behaviour and you really have a 
  support question. In this case contact the ib-support list server.
 
  You may subscribe here: 

    mailto:ib-support-subscribe@yahoogroups.com


o Still think it is a bug? 

  Check the list of Open Bugs. This can be found at

    http://firebird.sourceforge.net/rabbits/pcisar/FirebirdBugsOpen.html

  An older version is contained in the doc directory of this release.

Otherwise, if you are reasonably sure it is a bug then please 
try to develop a reproducible test case. You can then submit it
to the Firebird bug tracker at:

  http://sourceforge.net/tracker/?atid=109028&group_id=9028&func=browse


Requesting New Features
=======================

Firebird 1.0 is feature complete. Don't ask.

Work will shortly be starting on Firebird 2.0. Before submitting feature 
requests please review the existing feature request list. Chances are 
that someone has already thought of it. See this link for a current list:

  http://firebird.sourceforge.net/rabbits/pcisar/FirebirdFeatureRequestOpen.html

or look in the doc directory of this release for a slightly older version.

Feature requests should be submitted via:

  http://sourceforge.net/tracker/?atid=109028&group_id=9028&func=browse


