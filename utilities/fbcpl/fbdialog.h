/*
 *	PROGRAM:	Firebird 1.0 control panel applet
 *	MODULE:		FBDialog.h
 *	DESCRIPTION:	Main file to provide GUI based server control functions
 *					for Firebird 1.0
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


/////////////////////////////////////////////////////////////////////////////
// CFBDialog dialog

#if !defined(_FBDialog_)
#define _FBDialog_

//#pragma once

#include "resource.h"		// main symbols

#include <winsvc.h>

#undef TRACE

extern "C"{
#include "../../jrd/common.h"
#include "../install_nt.h"
#include "servi_proto.h"
#include "../registry.h"
}

extern USHORT svc_error (SLONG, TEXT *, SC_HANDLE);

const char * const CLASS_NAME = "IB_Server";
const char * const WINDOW_NAME = "InterBase Server";

#define SERVER_NAME		"ibserver.exe"
#define GUARDIAN_NAME	"ibguard.exe"


class CFBDialog : public CDialog
{
// Construction
public:
	CFBDialog(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CFBDialog)
	enum { IDD = IDD_FBDIALOG };
	CButton	m_Apply;
	CButton	m_Use_Guardian;
	CButton	m_Manual_Start;
	CButton	m_Run_As_Application;
	CButton	m_Run_As_Service;
	CButton	m_Auto_Start;
	CButton	m_Run_Type;
	CButton	m_Button_Stop;
	CStatic	m_Icon;
	CString	m_FB_Version;
	CString	m_Firebird_Status;
	//}}AFX_DATA

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFBDialog)
	public:
	virtual BOOL Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName, DWORD dwStyle, const RECT& rect, CWnd* pParentWnd, UINT nID, CCreateContext* pContext = NULL);
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL


//Our Stuff 
	public:
	CString m_Server_Name;
	CString m_Guardian_Name;
	CString m_Server_Path;
	CString m_Root_Path;


    SERVICE_STATUS status_info;

	HWND GetFirebirdHandle();

	bool FirebirdInstalled();

	static void ShowError(SLONG	status, TEXT *string);

	struct FB_STATUS
	{
		bool UseGuardian;
		bool ServicesAvailable;
		int  ServiceStatus;
		bool UseService;
		bool AutoStart;
		bool WasRunning;
	} 	fb_status;

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFBDialog)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	afx_msg void OnButtonStop();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnDestroy();
	afx_msg void OnService();
	afx_msg void OnManualStart();
	afx_msg void OnApplication();
	afx_msg void OnAutoStart();
	afx_msg void OnUseGuardian();
	afx_msg void OnApply();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

	UINT m_uiTimer;
	SC_HANDLE hScManager;

	struct NEW_SETTINGS
	{
		bool UseGuardian;
		bool UseService;
		bool AutoStart;
		bool Restart;
	} new_settings;

	bool m_Reset_Display_To_Existing_Values;
	bool m_Restore_old_status;

	bool ServerStop();
	bool ServerStart();
	bool ServiceInstall(BOOL AutoStart);
	bool ServiceRemove();
	bool AppInstall(bool AutoStart);
	bool AppRemove();
	void AppGetName(char * app);

	int DatabasesConnected();

	void UpdateServerStatus();
	bool ServiceSupportAvailable();
	int GetServiceStatus();
	bool GetServiceInstalled();
	bool IsAutoStart();
	void KillApp();
	
	void ApplyChanges();
	void EnableApplyButton();
	void DisableApplyButton();


	void OpenServiceManager();
	void CloseServiceManager();

	void ResetCheckBoxes( CFBDialog::FB_STATUS status );
	void UpdateGuardianUseInRegistry( bool UseGuardian );
	void SetAutoStart( bool AutoStart );
	//void ChangeGuardianServiceUsage( bool UseGuardian );


	BOOL ProcessMessages();

};


#endif
