
==================================
Firebird 1.0.3       (Win32 Build)
==================================

o Introduction
o Intended Users
o New Features
o Bugs fixed in this release
o Bugs fixed in previous maintenance releases
o Installation
o Known Issues
o Reporting Bugs
o Requesting New Features


Introduction
============

Welcome to Firebird 1.0.3. This represents the latest bug-fix release
of the Firebird 1.0 series. The Release Notes document has details of 
all the new features and the bug-fixes in the original release of 
Firebird 1.0. 

There are just two new features in this release, along with a handful 
of bug-fixes. This readme explains them. 


Intended Users
==============

Overall we believe this release to be more stable and more reliable than ANY 
previous release of Firebird 1.0 or InterBase 6.n. The initial release of 
Firebird 1.0 has seen around 280,000 downloads from the main Sourceforge 
site. There is no reason to be overly concerned about using this release 
in  a production environment. However, before deploying ANY software into a 
production environment it should always be tested properly on a development 
system. This is standard practice.


New Features
============

There are two new features in this release:

o The artificial maximum index limit per table has been removed.
  This limit was set at 64 indexes and provided consistency across
  page sizes and regardless of the number of columns that made up the 
  index. Under most circumstances even 64 indexes for a table is too 
  many. Insert and update performance can deteriorate significantly when 
  numerous indexes are defined.
  
  The purpose of this feature is to support data warehouse type 
  applications where data is updated by a batch process, rather than 
  interactively. When using this feature it is advisable to disable the 
  indexes prior to a data load. 
  
  The new limits for indexes are:
  
   Page Size     Single column        Double Column
   ------------------------------------------------
       1 k             60                    48
       2 k            124                    99
       4 k            252                   203
       8 k            508                   406
      16 k           1020                   816

  
o A control panel applet is now part of the Win32 installation 
  package. It will install automatically by default but this option
  can be turned off at install time. 


Bugs fixed in this release (all platforms)
==========================================

The bugs fixed are :

o The Service Manager api is now available to the command-line tools 
  again. This was (un)fortunately the only bug known to be introduced 
  by Firebird 1.0.2

o An event handler bug was fixed. Some Operating Systems that supported 
  multi-threading were using out of band notification for events. This 
  would lead to occasional, hard to diagnose problems.

o SIGPIPE errors on *nix Super Server builds were being logged excessively.
  This problem was benign, as long as enough disc space was available. 

o Connection times had a built in delay of 1 second per attachment. This was 
  fixed for Firebird 1.5 and the change back-ported to the Firebird 1.0.n 
  code.
  
o A couple of buffer overruns have been fixed.


Bugs fixed in previous maintenance releases
========================================================

The main bugs fixed in Firebird 1.0.2 were :

o There was problem with connection strings on Unix platforms that
  could lead to database corruption.

o 64-bit file i/o is now properly supported under Linux

o Table name aliases are now allowed in INSERT statements. 

o String expression evaluation now throws an error if the expression 
  could be greater than 64k. Previously an error was thrown if the 
  expression evaluated to a possible size of greater than 32k.

o Minor problems with Two-Phase commit were fixed.

o INT64 datatype now supported correctly in Arrays.

o SF Bug #545725 - internal connections to database now reported 
  as user.

o SF Bug #538201 - crash with extract from null date.

o SF Bug #534208 - select failed when udf was returning blob.

o SF Bug #533915 - Deferred work trashed the contents of 
  RDB$RUNTIME.

o SF Bug #526204 - GPRE Cobol Variable problems fixed.

There was no official Firebird 1.0.1 release.


Installing the self-installing executable
=========================================

Please run the executable and read the accompanying installation 
instructions that are contained within the setup wizard.


Known Issues
============

There are no known issues at this time. (29-May-2003).


Reporting Bugs
==============

o Are you sure you understand how Firebird works?

  Perhaps you are seeing the correct behaviour and you really have a 
  support question. In this case contact the ib-support list server.
 
  You may subscribe here: 

    mailto:ib-support-subscribe@yahoogroups.com


o Still think it is a bug? 

  Check the list of Open Bugs. This can be found at

    http://prdownloads.sourceforge.net/firebird/Firebird_v1_OpenBugs.html

  An older version is contained in the doc directory of this release.

Otherwise, if you are reasonably sure it is a bug then please 
try to develop a reproducible test case. You can then submit it
to the Firebird bug tracker at:

  http://sourceforge.net/tracker/?atid=109028&group_id=9028&func=browse


Requesting New Features
=======================

Before submitting feature requests please review the existing 
feature request list. Chances are that someone has already thought 
of it. See this link for a current list:

  http://prdownloads.sourceforge.net/firebird/Firebird_v1_OpenFeatures.html

or look in the doc directory of this release for a slightly older version.

Feature requests should be submitted via:

  http://sourceforge.net/tracker/?atid=109028&group_id=9028&func=browse


