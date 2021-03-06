/*
 *
 *     The contents of this file are subject to the Initial
 *     Developer's Public License Version 1.0 (the "License");
 *     you may not use this file except in compliance with the
 *     License. You may obtain a copy of the License at
 *     http://www.ibphoenix.com/idpl.html.
 *
 *     Software distributed under the License is distributed on
 *     an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either
 *     express or implied.  See the License for the specific
 *     language governing rights and limitations under the License.
 *
 *
 *  The Original Code was created by Claudio Valderama C. for IBPhoenix.
 *  The development of the Original Code was sponsored by Craig Leonardi.
 *
 *  Copyright (c) 2001 IBPhoenix
 *  All Rights Reserved.
 */


// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__F60BDFDF_7A2D_11D5_8EEB_4854E8274D24__INCLUDED_)
#define AFX_STDAFX_H__F60BDFDF_7A2D_11D5_8EEB_4854E8274D24__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#if defined (_WIN32)
// Insert your headers here
#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers
//#include <windows.h>
//#include <windef.h>
#endif

// TODO: reference additional headers your program requires here

//#ifdef __cplusplus
//extern "C" {
//#endif

#pragma warning(disable:4514) //unreferenced inline function has been removed

#include <math.h>
//#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/timeb.h>
#include <locale.h>
//#include "ib_util.h"
//#include "ib_udf.h"
#include "ibase.h"

//#ifdef __cplusplus
//}
//#endif


//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__F60BDFDF_7A2D_11D5_8EEB_4854E8274D24__INCLUDED_)
