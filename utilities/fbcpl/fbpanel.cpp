/*
 *  PROGRAM:        Firebird 1.0 control panel applet
 *  MODULE:         fbpanel.cpp
 *  DESCRIPTION:    The FBPanel unit does the following things:
 *                    - It manages the display of the icon in the 
 *                      Control Panel manager 
 *                    - It tests whether Firebird is installed 
 *                    - If Fb is installed it sets the status of items 
 *                      that can be read from the Firebird registry entries
 *                      and launches the Applet.
 *
 *                  Everything else is handled by the fbdialog unit. This is 
 *                  not a good thing as UI stuff is integrated with management 
 *                  and diagnostic stuff. A better design for Fb 1.5 would be 
 *                  to separate everything out and share the code with the 
 *                  existing command line tools that manage services and 
 *                  installation settings.
 *
 * The contents of this file are subject to the Independant Developer's 
 * Public License Version 1.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy
 * of the License at http://www.ibphoenix.com/idpl.html
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code was created by Paul Reeves
 * Copyright (C) 2003 Paul Reeves
 *
 * All Rights Reserved.
 * Contributor(s): ______________________________________.
 *
 *
 */


#include "stdafx.h"
#include "FBPanel.h"
#include <Shlwapi.h>
#include "../registry.h"



/*
 *
 */

LONG CFBPanel::OnInquire(UINT uAppNum, NEWCPLINFO* pInfo) 
{
    // Fill in the data
    pInfo->dwSize = sizeof(NEWCPLINFO); // important
    pInfo->dwFlags = 0;
    pInfo->dwHelpContext = 0;
    pInfo->lData = 0;
    pInfo->hIcon = ::LoadIcon(AfxGetResourceHandle(), MAKEINTRESOURCE(IDI_ICON1));
    strcpy(pInfo->szName, "Firebird Server Manager");
    strcpy(pInfo->szInfo, "Configure Firebird Database Server");
    strcpy(pInfo->szHelpFile, "");
    return 0; // OK (don't send CPL_INQUIRE msg)
}

LONG CFBPanel::OnDblclk(HWND hwndCPl, UINT uAppNum, LONG lData)
{

    // Create the dialog box using the parent window handle
    CFBDialog dlg(CWnd::FromHandle(hwndCPl));

    // Check if Firebird is installed by reading the registry
    HKEY hkey;
	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, REG_KEY_ROOT_CUR_VER, 0, KEY_QUERY_VALUE, &hkey) 
		== ERROR_SUCCESS)
	{
		DWORD   buffSize = sizeof(dlg.m_FB_Version);
		char version[64];
		buffSize = sizeof(version); /* reserve place for null and the \ */

		if (RegQueryValueEx (hkey, "Version", NULL, NULL, (unsigned char *)version, 
			&buffSize) == ERROR_SUCCESS)
		{
		dlg.m_FB_Version = version;
		}
		else
		{
		dlg.m_FB_Version = "not known";
		}
		
		char rootpath[MAX_PATH-2];
		buffSize = sizeof(rootpath);
		if (RegQueryValueEx(hkey, "RootDirectory",NULL, NULL, (unsigned char *)rootpath, &buffSize)
			== ERROR_SUCCESS)
		{
			PathAddBackslash(rootpath);
			dlg.m_Root_Path = rootpath;
		}

		char serverpath[MAX_PATH-2];
		buffSize = sizeof(serverpath);
		if (RegQueryValueEx(hkey, "ServerDirectory",NULL, NULL, (unsigned char *)serverpath, &buffSize)
			== ERROR_SUCCESS)
		{
			PathAddBackslash(serverpath);
			dlg.m_Server_Path = serverpath;
		}

		char opt[3];
		if (RegQueryValueEx(hkey, "GuardianOptions",NULL, NULL, (unsigned char *)opt, &buffSize)
			== ERROR_SUCCESS)
		{
			// !=0 is an MS hack to turn off a compiler performance warning.
			dlg.fb_status.UseGuardian = (atoi(opt) !=0);
		}

        RegCloseKey(hkey);

	    // Show the dialog box
		if (dlg.DoModal() != IDOK) return 0;
    }
	else
	{
		//raise an error
		dlg.MessageBox("Firebird does not appear to be installed correctly.","Installation Error",MB_OK);
	}
    return 0;
}	
	

