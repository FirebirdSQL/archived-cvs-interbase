/*
 *	PROGRAM:	JRD Access Method
 *	MODULE:		license.h
 *	DESCRIPTION:	Internal licensing parameters
 *
 * The contents of this file are subject to the Interbase Public
 * License Version 1.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.Inprise.com/IPL.html
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code was created by Inprise Corporation
 * and its predecessors. Portions created by Inprise Corporation are
 * Copyright (C) Inprise Corporation.
 *
 * All Rights Reserved.
 * Contributor(s): ______________________________________.
 * $Id$
 * Revision 1.5  2000/12/08 16:18:21  fsg
 * Preliminary changes to get IB_BUILD_NO automatically
 * increased on commits.
 *
 * setup_dirs will create 'jrd/build_no.h' by a call to
 * a slightly modified 'builds_win32/original/build_no.ksh'
 * that gets IB_BUILD_NO from 'this_build', that hopefully
 * will be increased automatically in the near future :-)
 *
 * I have changed 'jrd/iblicense.h' to use IB_BUILD_TYPE
 * from 'jrd/build_no.h'.
 * So all changes to version numbers, build types etc. can
 * now be done in 'builds_win32/original/build_no.ksh'.
 *
 */

#ifndef _JRD_LICENSE_H_
#define _JRD_LICENSE_H_

#include "../jrd/build_no.h"

#ifdef hpux
#ifdef hp9000s300
#ifdef HP300
#define IB_PLATFORM	"H3"
#endif
#ifdef HM300
#define IB_PLATFORM	"HM"
#endif
#else
#ifdef HP700
#define IB_PLATFORM	"HP"
#endif
#ifdef HP800
#define IB_PLATFORM	"HO"
#endif
#ifdef HP10
#define IB_PLATFORM	"HU"
#endif /* HP10 */
#endif
#endif

#ifdef mpexl
#define IB_PLATFORM	"HX"		/* HP MPE/XL */
#endif

#ifdef apollo
#if _ISP__A88K
#define IB_PLATFORM	"AP"
#else
#define IB_PLATFORM	"AX"
#endif
#endif

#ifdef sun
#ifdef sparc
#ifdef SOLARIS
#define IB_PLATFORM	"SO"
#else
#define IB_PLATFORM	"S4"
#endif
#endif
#ifdef i386
#define IB_PLATFORM     "SI"
#endif
#ifdef SUN3_3
#define IB_PLATFORM	"SU"
#endif
#ifndef IB_PLATFORM
#define IB_PLATFORM	"S3"
#endif
#endif

#ifdef ultrix
#ifdef mips
#define IB_PLATFORM	"MU"
#else
#define IB_PLATFORM	"UL"
#endif
#endif

#ifdef VMS
#ifdef __ALPHA
#define IB_PLATFORM     "AV"
#else
#define IB_PLATFORM	"VM"
#endif
#endif

#ifdef MAC
#define IB_PLATFORM	"MA"
#endif

#ifdef PC_PLATFORM
#ifdef WINDOWS_ONLY
#define IB_PLATFORM     "WS"
#else
#ifdef DOS_ONLY
#define IB_PLATFORM     "DS"
#endif
#endif
#undef NODE_CHECK
#define NODE_CHECK(val,resp) 
#endif

#ifdef NETWARE_386
#define IB_PLATFORM     "NW"
#endif

#ifdef OS2_ONLY
#define IB_PLATFORM     "O2"
#endif

#ifdef AIX
#define IB_PLATFORM	"IA"
#endif

#ifdef AIX_PPC
#define IB_PLATFORM	"PA"
#endif

#ifdef IMP
#define IB_PLATFORM	"IM"
#endif

#ifdef DELTA
#define IB_PLATFORM	"DL"
#endif

#ifdef XENIX
#ifdef SCO_UNIX
#define IB_PLATFORM	"SI"	/* 5.5 SCO Port */
#else
#define IB_PLATFORM	"XN"
#endif
#endif

#ifdef sgi
#define IB_PLATFORM	"SG"
#endif

#ifdef DGUX
#ifdef DG_X86
#define IB_PLATFORM     "DI"          /* DG INTEL */
#else
#define IB_PLATFORM	"DA"		/* DG AViiON */
#define M88K_DEFINED
#endif /* DG_X86 */
#endif /* DGUX */

#ifdef WIN_NT
#ifdef i386
#if (defined SUPERCLIENT || defined SUPERSERVER)
#if (defined WIN95)
#define IB_PLATFORM	"WI"
#else
#define IB_PLATFORM	"NIS"
#endif /* WIN95 */
#else
#define IB_PLATFORM	"NI"
#endif
#else
#ifdef alpha
#define IB_PLATFORM	"NA"
#else
#ifdef mips
#define IB_PLATFORM	"NM"
#else /* PowerPC */
#define IB_PLATFORM	"NP"
#endif
#endif
#endif
#endif

#ifdef NeXT
#ifdef	i386
#define IB_PLATFORM	"XI"
#else	/* m68040 */
#define IB_PLATFORM	"XM"
#endif
#endif

#ifdef EPSON
#define IB_PLATFORM	"EP"		/* epson */
#endif

#ifdef _CRAY
#define IB_PLATFORM	"CR"		/* Cray */
#endif

#ifdef ALPHA_NT
#define	IB_PLATFORM	"AN"		/* Alpha NT */
#endif

#ifdef DECOSF
#define	IB_PLATFORM	"AO"		/* Alpha OSF-1 */
#endif

#ifdef M88K
#define	IB_PLATFORM	"M8"		/* Motorola 88k */
#endif

#ifdef UNIXWARE
#define	IB_PLATFORM	"UW"		/* Unixware */
#endif

#ifdef NCR3000
#define	IB_PLATFORM	"NC"		/* NCR3000 */
#endif

#ifdef LINUX
#define IB_PLATFORM     "LI"         /* Linux on Intel */
#endif

#ifdef FREEBSD
#define IB_PLATFORM     "FB"         /* FreeBSD/i386 */
#endif

#ifdef NETBSD
#define IB_PLATFORM     "NB"         /* NetBSD */
#endif

#ifndef GDS_VERSION
#define GDS_VERSION	IB_PLATFORM "-" IB_BUILD_TYPE IB_MAJOR_VER "." IB_MINOR_VER "." IB_REV_NO "." IB_BUILD_NO
#endif

#endif /* _JRD_LICENSE_H_ */

