/*
 *	PROGRAM:	Firebird 1.0 control panel applet
 *	MODULE:		fbdialog.cpp
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

#include "stdafx.h"
#include "FBDialog.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMyDialog dialog


CFBDialog::CFBDialog(CWnd* pParent /*=NULL*/)
	:	CDialog(CFBDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFBDialog)
	m_FB_Version = _T("");
	m_Firebird_Status = _T("");
	//}}AFX_DATA_INIT

	m_uiTimer = 0;

    hScManager = 0;


	m_Server_Name	= SERVER_NAME; 
	m_Guardian_Name = GUARDIAN_NAME;

	fb_status.AutoStart = 0;
	fb_status.ServicesAvailable = 0;
	fb_status.ServiceStatus = 0;
	fb_status.UseGuardian = 0;
	fb_status.UseService = 0;
	fb_status.WasRunning  = 0;

	new_settings.AutoStart = 0;
	new_settings.UseGuardian  = 0;
	new_settings.UseService  = 0;
	new_settings.Restart  = 0;

}


void CFBDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFBDialog)
	DDX_Control(pDX, IDAPPLY, m_Apply);
	DDX_Control(pDX, IDC_USE_GUARDIAN, m_Use_Guardian);
	DDX_Control(pDX, IDC_MANUAL_START, m_Manual_Start);
	DDX_Control(pDX, IDC_APPLICATION, m_Run_As_Application);
	DDX_Control(pDX, IDC_SERVICE, m_Run_As_Service);
	DDX_Control(pDX, IDC_AUTO_START, m_Auto_Start);
	DDX_Control(pDX, IDC_RUN_TYPE, m_Run_Type);
	DDX_Control(pDX, IDC_BUTTON_STOP, m_Button_Stop);
	DDX_Control(pDX, IDC_STATUS_ICON, m_Icon);
	DDX_Text(pDX, IDC_FB_VERSION, m_FB_Version);
	DDV_MaxChars(pDX, m_FB_Version, 64);
	DDX_Text(pDX, IDC_FIREBIRD_STATUS, m_Firebird_Status);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFBDialog, CDialog)
	//{{AFX_MSG_MAP(CFBDialog)
	ON_BN_CLICKED(IDC_BUTTON_STOP, OnButtonStop)
	ON_WM_TIMER()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_SERVICE, OnService)
	ON_BN_CLICKED(IDC_MANUAL_START, OnManualStart)
	ON_BN_CLICKED(IDC_APPLICATION, OnApplication)
	ON_BN_CLICKED(IDC_AUTO_START, OnAutoStart)
	ON_BN_CLICKED(IDC_USE_GUARDIAN, OnUseGuardian)
	ON_BN_CLICKED(IDAPPLY, OnApply)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CMyDialog message handlers



BOOL CFBDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	m_Reset_Display_To_Existing_Values = TRUE;
	m_uiTimer = SetTimer(1, 500, NULL);
	
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

BOOL CFBDialog::Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName, DWORD dwStyle, const RECT& rect, CWnd* pParentWnd, UINT nID, CCreateContext* pContext) 
{
	// Extra code can be put here before instantiating the base class

	return CDialog::Create(IDD, pParentWnd);
}

void CFBDialog::OnOK() 
{
	// Extra validation can be added here

	//if IDAPPLY is enabled then click IDAPPLY to apply changes before we close
	if (m_Apply.IsWindowEnabled())
	{
		OnApply();
	}
	
	
	CDialog::OnOK();
}


void CFBDialog::UpdateServerStatus() 
{
	
	HWND hTmpWnd = GetFirebirdHandle();
	if (hTmpWnd != NULL)
	{
		fb_status.WasRunning = true;
		m_Icon.SetIcon(AfxGetApp()->LoadIcon(IDI_ICON1)); 
		m_Button_Stop.SetWindowText("&Stop");
	}
	else
	{
		fb_status.WasRunning = false;
		m_Icon.SetIcon(AfxGetApp()->LoadIcon(IDI_ICON4));
		m_Button_Stop.SetWindowText("&Start");

	}

	fb_status.ServicesAvailable = ServiceSupportAvailable();
	if ( fb_status.ServicesAvailable )
	{
		m_Run_Type.EnableWindow(TRUE);
		m_Run_As_Service.EnableWindow(TRUE);
		m_Run_As_Application.EnableWindow(TRUE);
	}

	fb_status.ServiceStatus = GetServiceStatus();
	m_Firebird_Status.Format(fb_status.ServiceStatus);

	
	//Reset check boxes 
	//This is always true on startup. If the panel becomes more complicated
	// it also allows us to add a reset button later. Otherwise this
	// section is not called again.
	if (m_Reset_Display_To_Existing_Values)
	{
		fb_status.AutoStart = IsAutoStart();
		ResetCheckBoxes( fb_status );
	}
	m_Reset_Display_To_Existing_Values = false;

	UpdateData(FALSE);		
}

void CFBDialog::ResetCheckBoxes(CFBDialog::FB_STATUS status)
{
	if (( status.ServiceStatus == IDS_APPLICATION_RUNNING ) ||
		( status.ServiceStatus == IDS_APPLICATION_STOPPED ))
	{
		m_Run_As_Application.SetCheck(1);
		m_Run_As_Service.SetCheck(0);
	}
	else
	{
		m_Run_As_Application.SetCheck(0);
		m_Run_As_Service.SetCheck(1);
	}
	
	
	//Now are we starting automatically or not?
	if (status.AutoStart)
	{
		m_Auto_Start.SetCheck(1);
		m_Manual_Start.SetCheck(0);
	}
	else
	{
		m_Auto_Start.SetCheck(0);
		m_Manual_Start.SetCheck(1);
	}
	
	m_Use_Guardian.SetCheck(status.UseGuardian);
}

bool CFBDialog::IsAutoStart()
{
	fb_status.AutoStart = 0;

	if (GetServiceInstalled())
	{
	    LPQUERY_SERVICE_CONFIG status_info;
		SC_HANDLE hService = 0;
		DWORD dwBytesNeeded; 
		OpenServiceManager();

		char * service = "";
		char * display_name = "";
		if (fb_status.UseGuardian)
		{
			service = ISCGUARD_SERVICE;
			display_name = ISCGUARD_DISPLAY_NAME;
		}
		else
		{
			service = REMOTE_SERVICE;
			display_name = REMOTE_DISPLAY_NAME;
		}

		hService = OpenService (hScManager, service, SERVICE_QUERY_CONFIG);
		CloseServiceManager();
		if (hService != NULL) // then we are running as a Service
		{
			status_info = (LPQUERY_SERVICE_CONFIG) LocalAlloc(LPTR, 4096); 
			if (!QueryServiceConfig(hService,status_info,4096,&dwBytesNeeded))
			{
				dwBytesNeeded=GetLastError();
			}
			else
			{
				if (status_info->dwStartType == SERVICE_AUTO_START )
				{
					fb_status.AutoStart = 1;
				}
			}
			CloseServiceHandle (hService);
		}
	}
	else //Running as Application, so look for an entry in registry
	{
	    HKEY hkey;
		if (RegOpenKeyEx(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Run", 
			0, KEY_QUERY_VALUE, &hkey) == ERROR_SUCCESS)
		{
			DWORD dwType;
			CString strValue;
			DWORD dwSize = MAX_PATH;
			fb_status.AutoStart = !(RegQueryValueEx(hkey, "Firebird", NULL, &dwType, 
				(LPBYTE)strValue.GetBuffer(dwSize/sizeof(TCHAR)),&dwSize));

				;
		    RegCloseKey (hkey);
		}
	}
	return fb_status.AutoStart;
}

void CFBDialog::OnButtonStop() 
{
	if (GetFirebirdHandle()!=NULL)
		ServerStop();
	else	
		ServerStart();
}


int CFBDialog::DatabasesConnected()
// Return number of open databases
//** Note: We really need a way of getting number of attachments
//** without having to enter a username / password.
//** This could be done by doing a lock print and checking
//** for this line:
//**		Owners: *empty*
//**
{
	int nDatabases = 0;

	return nDatabases;
}


bool CFBDialog::ServerStart()
{
	bool result = false;

#if !defined(_DEBUG)
	BeginWaitCursor();
#endif

	if (m_Run_As_Service.GetCheck()) 
	{

		char * service = "";
		char * display_name = "";
		if (fb_status.UseGuardian)
		{
			service = ISCGUARD_SERVICE;
			display_name = ISCGUARD_DISPLAY_NAME;
		}
		else
		{
			service = REMOTE_SERVICE;
			display_name = REMOTE_DISPLAY_NAME;
		}


		OpenServiceManager();
		try
		{
			if (SERVICES_start (hScManager, service, display_name, 0, svc_error)
				==SUCCESS)
			result = true;
		}
		catch( ... ) 
		{
		}
		CloseServiceManager();

	}
	else
	{
		try
		{
			STARTUPINFO si;
			SECURITY_ATTRIBUTES sa;
			PROCESS_INFORMATION pi;
			char full_name[MAX_PATH] = "";
			::strcat(full_name,m_Server_Path);
			ZeroMemory (&si, sizeof(si));
			si.cb = sizeof (si);
			sa.nLength = sizeof (sa);
			sa.lpSecurityDescriptor = NULL;
			sa.bInheritHandle = TRUE;
			
			AppGetName(full_name);
			
			if (!CreateProcess (NULL, full_name, &sa, NULL, FALSE, 0, NULL, NULL, &si, &pi))
				ShowError(0,"Application Start");
			else
				result = true;
		}
		catch( ... )
		{
		}
	}

#if !defined(_DEBUG)
    EndWaitCursor();
#endif

return result;
}


bool CFBDialog::ServerStop()
{
	bool result = false;

	if (!DatabasesConnected())
	{
		if ( fb_status.UseService ) 
		{
			try
			{
#if !defined(_DEBUG)
				BeginWaitCursor();
#endif
				OpenServiceManager();
				SERVICES_stop(hScManager, REMOTE_SERVICE, REMOTE_DISPLAY_NAME, svc_error);

				// If things are out of sync there is a slight possibility 
				// that the guardian may be running, so let's try and stop that too.
				SERVICES_stop(hScManager, ISCGUARD_SERVICE, ISCGUARD_DISPLAY_NAME, svc_error);

				result = true;
			}
			catch (...) 
			{
			MessageBeep(-1);
			}

				CloseServiceManager();
#if !defined(_DEBUG)
			    EndWaitCursor();
#endif

		}
		else
		{
			try
			{
#if !defined(_DEBUG)
				BeginWaitCursor();
#endif
				KillApp();
				result = true;
			}
			catch (...) 
			{
			}
#if !defined(_DEBUG)
		    EndWaitCursor();
#endif
		}
	
	}
	
	return result;
}


void CFBDialog::KillApp()
{
	HWND hTmpWnd = GetFirebirdHandle();
	if (hTmpWnd != NULL)
	{
		::SendMessage(hTmpWnd, WM_CLOSE, 0, 0);
	}
}


bool CFBDialog::ServiceInstall(BOOL AutoStart)
{
	USHORT	status;
	char * ServerPath = const_cast<char *> ((LPCTSTR)m_Root_Path);

	OpenServiceManager();

	if (new_settings.UseGuardian) 
	{
		status = SERVICES_install (hScManager, ISCGUARD_SERVICE, ISCGUARD_DISPLAY_NAME,
			ISCGUARD_EXECUTABLE, ServerPath, NULL, AutoStart, svc_error);
		if (status != SUCCESS)
		{
			CloseServiceManager();
			return false;
		}

	/* Set AutoStart to manual in preparation for installing the ib_server service */
		AutoStart = false;

	}
	/* do the install of server */
	status = SERVICES_install (hScManager, REMOTE_SERVICE, REMOTE_DISPLAY_NAME,
				REMOTE_EXECUTABLE, ServerPath, NULL, AutoStart, svc_error);
	if (status != SUCCESS)
	{
		CloseServiceManager();
		return false;
	}

	CloseServiceManager();
	return true;
}


bool CFBDialog::ServiceRemove()
{
	USHORT	status;

	OpenServiceManager();

	status = SERVICES_remove (hScManager, ISCGUARD_SERVICE, ISCGUARD_DISPLAY_NAME, svc_error);
	if (status == IB_SERVICE_RUNNING)
	{
		CloseServiceManager();
		return false;
	}

	status = SERVICES_remove (hScManager, REMOTE_SERVICE, REMOTE_DISPLAY_NAME, svc_error);
	if (status == IB_SERVICE_RUNNING)
	{
		CloseServiceManager();
		return false;
	}

	CloseServiceManager();
	return true;

}


bool CFBDialog::AppInstall(bool AutoStart)
{
	//AppInstall is probably a misnomer. The calling procedure
	//will have already removed the service. All we need to do now
	//is configure the registry if AutoStart has been set.
	if (AutoStart)
	{
		//Add line to registry 
		HKEY hkey;
		if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run", 
			0, KEY_WRITE, &hkey) == ERROR_SUCCESS)
		{
			
			char  full_name[MAX_PATH] = "";
			::strcat(full_name,m_Server_Path);
			AppGetName(full_name);
			if (RegSetValueEx (hkey, "Firebird", 0,REG_SZ, (unsigned char *) full_name, sizeof(full_name) )  == ERROR_SUCCESS)
			{
				return true;
			}
			else
			{
				ShowError(0, "AppInstall");
				return false;
			}
		}
		else
		{
			ShowError(0, "AppInstall");
			return false;
		}
	}

	return true;
}


bool CFBDialog::AppRemove()
{
	//Remove registry entry if set to start automatically on boot.
	HKEY hkey;
	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run", 
			0, KEY_QUERY_VALUE | KEY_WRITE, &hkey) == ERROR_SUCCESS)

	{
		if (RegQueryValueEx(hkey, "Firebird", NULL, NULL, NULL, NULL)== ERROR_SUCCESS)
		{
			if (RegDeleteValue(hkey, "Firebird") == ERROR_SUCCESS)
				return true;
			else
			{
				ShowError(0, "AppRemove");
				return false;
			}
		}
		else
		{
		//If an error is thrown it must be because there is no
		//entry in the registry so we shouldn't need to show an error.
			return false;
		}

	}
	else
	{
		ShowError(0, "AppRemove");
		return false;
	}

}


static USHORT svc_error (SLONG	status, TEXT *string, SC_HANDLE	service)
{
	bool RaiseError = true;

	//process the kinds of errors we may be need to 
	//deal with quietly
	switch ( status )
	{
		case ERROR_SERVICE_CANNOT_ACCEPT_CTRL:
			RaiseError = false;

		case ERROR_SERVICE_ALREADY_RUNNING:
			RaiseError = false;

		case ERROR_SERVICE_DOES_NOT_EXIST:
			RaiseError = false;

	}

	if (RaiseError)
		CFBDialog::ShowError(status, string);
	
	if (service != NULL)
		CloseServiceHandle (service);

	return (USHORT) status;
}

BOOL CFBDialog::ProcessMessages()
{
	MSG Msg;
	
	while (::PeekMessage(&Msg, NULL, 0, 0, PM_NOREMOVE))
	{
		if (!AfxGetApp()->PumpMessage())
		{
			::PostQuitMessage(0); return FALSE;
		}
	}

	LONG lIdle = 0;
	while (AfxGetApp()->OnIdle(lIdle++));
	return TRUE;
}

void CFBDialog::ShowError(SLONG	status, TEXT *string )
{
	LPTSTR lpMsgBuf;
	DWORD error_code = GetLastError();
	DWORD Size;
	CString error_title = "";

	Size = FormatMessage( 
		FORMAT_MESSAGE_ALLOCATE_BUFFER | 
		FORMAT_MESSAGE_FROM_SYSTEM | 
		FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL,
		error_code,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
		(LPTSTR) &lpMsgBuf,	0, NULL );

	error_title.Format("Error Code %d raised in %s",error_code, (LPCTSTR) string );

	::MessageBox( NULL, lpMsgBuf, (LPCTSTR) error_title, MB_OK | MB_ICONINFORMATION );
	LocalFree( lpMsgBuf );
}

void CFBDialog::EnableApplyButton()
{
	m_Apply.EnableWindow(TRUE);
	m_Button_Stop.EnableWindow(FALSE);
}

void CFBDialog::DisableApplyButton()
{
	m_Apply.EnableWindow(FALSE);
	m_Button_Stop.EnableWindow(TRUE);
}
		

void CFBDialog::OnTimer(UINT nIDEvent) 
{
	UpdateServerStatus();
}


void CFBDialog::OnDestroy() 
{
	CDialog::OnDestroy();
	
	// Kill the update timer
	if (m_uiTimer) KillTimer(m_uiTimer);

}


void CFBDialog::OnService() 
{
	EnableApplyButton();
}


void CFBDialog::OnManualStart() 
{
	EnableApplyButton();
}


void CFBDialog::OnApplication() 
{
	EnableApplyButton();
}


void CFBDialog::OnAutoStart() 
{
	EnableApplyButton();
}


void CFBDialog::OnUseGuardian() 
{
	EnableApplyButton();
}


void CFBDialog::OnApply() 
{
	ApplyChanges();

}


void CFBDialog::ApplyChanges()
{
	// Stop the update timer
	if (m_uiTimer) KillTimer(m_uiTimer);


	//find out what has changed and implement the changes
	try
	{	
	//Stage 1
		//Stop the Server 
		//we don't restart unless we were running
		//and we successfully stop the server.
		new_settings.Restart = false;	
		if ( fb_status.WasRunning )
			if ( ServerStop() )
				new_settings.Restart = true;

#if defined(_DEBUG)
			UpdateServerStatus();
#endif
		ProcessMessages();

	//Stage 2 - Gather details of changes to make

		//Manage change to startup - from/to manual or auto
		BOOL ChangeStartType = FALSE;
		ChangeStartType = (	( (BOOL) fb_status.AutoStart &&  m_Manual_Start.GetCheck() ) || 
			((BOOL)  !fb_status.AutoStart &&  m_Auto_Start.GetCheck() ) );
		
		if ( ChangeStartType )
			new_settings.AutoStart = !fb_status.AutoStart;
		else 
			new_settings.AutoStart = fb_status.AutoStart;
		
		
		//Do we change Guardian Usage?
		BOOL ChangeGuardianUse = FALSE;
		ChangeGuardianUse = ( ( (BOOL) !fb_status.UseGuardian && m_Use_Guardian.GetCheck() ) || 
			( (BOOL) fb_status.UseGuardian && !m_Use_Guardian.GetCheck() ) );
		if ( ChangeGuardianUse )
			new_settings.UseGuardian = !fb_status.UseGuardian;
		else
			new_settings.UseGuardian = fb_status.UseGuardian;

		
		//Finally, test for change between service and application usage.
		BOOL ChangeRunStyle = FALSE;
		
		ChangeRunStyle = ( ( (BOOL) fb_status.UseService && m_Run_As_Application.GetCheck() )  ||
			( !(BOOL) fb_status.UseService && m_Run_As_Service.GetCheck() ) );
		
		if (ChangeRunStyle)
			new_settings.UseService = !fb_status.UseService;
		else
			new_settings.UseService = fb_status.UseService;

		
	//Stage 3 - implement changes

#if !defined(_DEBUG)
		BeginWaitCursor();
#endif

		//Three things to do
		// a) If we are switching run style then pull down what is already there
		if ( ChangeRunStyle || ChangeGuardianUse )
		{
			if ( fb_status.UseService )
			{
				ServiceRemove();
			}
			else
				AppRemove();
		}
		
		
		// b) update the registry
		UpdateGuardianUseInRegistry( new_settings.UseGuardian );


		// c) install the new configuration
		if ( ChangeRunStyle || ChangeGuardianUse )
		{
			
			if ( new_settings.UseService )
			{
				ServiceInstall( new_settings.AutoStart );
			}
			else
			{
				AppInstall(new_settings.AutoStart);
			}
		}
		else
		{
			//If we are not changing the run style and not changing guardian usage
			//we only have the autostart setting left to change
			SetAutoStart( new_settings.AutoStart );
		}

		
		if ( new_settings.Restart && ( GetFirebirdHandle() == NULL) )
		{
			ProcessMessages();
			ServerStart();
		}

		DisableApplyButton();

	}
	catch ( ... )
	{
	}

#if !defined(_DEBUG)
    EndWaitCursor();
#endif


	//Whatever the outcome of ApplyChanges we need to refresh the dialog
	m_uiTimer = SetTimer( 1, 500, NULL );

}


void CFBDialog::UpdateGuardianUseInRegistry( bool UseGuardian )
{
	HKEY hkey;
	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, REG_KEY_ROOT_CUR_VER, 0, KEY_SET_VALUE, &hkey) 
		== ERROR_SUCCESS)
	{
		char opt[3];
		itoa( UseGuardian, (char *)opt, 10);
		if (RegSetValueEx(hkey, "GuardianOptions",NULL, REG_SZ, (unsigned char *)opt, sizeof(opt))
			== ERROR_SUCCESS)
		{
			fb_status.UseGuardian = UseGuardian;
		}
		else
		{
			ShowError(0,"UpdateGuardianUseInRegistry");
			return;
		}
	}
}


void CFBDialog::SetAutoStart(bool AutoStart)
{
	if (new_settings.UseService)
	{
		SC_LOCK sclLock; 
		DWORD dwStartType; 
		SC_HANDLE hService;
		
		OpenServiceManager();
		// Need to acquire database lock before reconfiguring. 
		sclLock = LockServiceDatabase(hScManager); 
		
		// If the database cannot be locked, report the details. 
		if (sclLock == NULL) 
		{
			ShowError(NULL,"Could not lock service database"); 
			return;
		}
		
		// The database is locked, so it is safe to make changes. 
		
		char * service = "";
		char * display_name = "";
		
		if (fb_status.UseGuardian)
		{
			service = ISCGUARD_SERVICE;
			display_name = ISCGUARD_DISPLAY_NAME;
		}
		else
		{
			service = REMOTE_SERVICE;
			display_name = REMOTE_DISPLAY_NAME;
		}
		
		
		// Open a handle to the service. 
		hService = OpenService( 
			hScManager,				// SCManager database 
			service,				// name of service 
			SERVICE_CHANGE_CONFIG);	// need CHANGE access 
		if (hService == NULL) 
			ShowError(NULL,"OpenService in SetAutoStart"); 
		
		dwStartType = (new_settings.AutoStart) ? SERVICE_AUTO_START : SERVICE_DEMAND_START; 
		
		if (! ChangeServiceConfig( 
			hService,        // handle of service 
			SERVICE_NO_CHANGE, // service type: no change 
			dwStartType,       // change service start type 
			SERVICE_NO_CHANGE, // error control: no change 
			NULL,              // binary path: no change 
			NULL,              // load order group: no change 
			NULL,              // tag ID: no change 
			NULL,              // dependencies: no change 
			NULL,              // account name: no change 
			NULL,              // password: no change 
			display_name ) )
		{
			ShowError(NULL,"ChangeServiceConfig in SetAutoStart"); 
		}
		
		
		// Release the database lock. 
		UnlockServiceDatabase(sclLock); 
		
		// Close the handle to the service. 
		CloseServiceHandle(hService); 

		CloseServiceManager();
	
	}
	else
	{
		if (new_settings.AutoStart)
			// AppInstall is probably a misnomer - all it does is set
			// the registry to start the guardian or the server 
			// on boot.
			AppInstall(new_settings.AutoStart);
		else
			//Likewise, AppRemove is not well named. It only
			//removes the Firebird entry from the RUN section
			//of the registry
			AppRemove();
	}
}


HWND CFBDialog::GetFirebirdHandle()
{
	return ::FindWindow(CLASS_NAME, WINDOW_NAME);
}


bool CFBDialog::ServiceSupportAvailable()
{
	//Are services available? 

	OSVERSIONINFO   OsVersionInfo;

	/* need to set the sizeof this structure for NT to work */
	OsVersionInfo.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx ((LPOSVERSIONINFO) &OsVersionInfo);

	/* true for NT family, false for 95 family */
	return (OsVersionInfo.dwPlatformId == VER_PLATFORM_WIN32_NT);

}

void CFBDialog::OpenServiceManager()
{
	if (hScManager == NULL)
		hScManager = OpenSCManager (NULL, SERVICES_ACTIVE_DATABASE, GENERIC_READ | GENERIC_EXECUTE | GENERIC_WRITE );

	if (!hScManager)
		ShowError(0, "OpenServiceManager");
}

void CFBDialog::CloseServiceManager()
{
	try
	{
		CloseServiceHandle (hScManager);
	}
	catch (...)
	{
	}

	hScManager = NULL;
}


int CFBDialog::GetServiceStatus()
{
	SC_HANDLE hService;
	CString service;
	CString display_name;

	int result = IDS_APPLICATION_STOPPED;
	
	if (fb_status.UseGuardian)
	{
		service = ISCGUARD_SERVICE;
		display_name = ISCGUARD_DISPLAY_NAME;
	}
	else
	{
		service = REMOTE_SERVICE;
		display_name = REMOTE_DISPLAY_NAME;
	}
	
    OpenServiceManager();
    hService = OpenService (hScManager, service, GENERIC_READ );
	if (hService == NULL)
	{
		if (GetLastError() != ERROR_SERVICE_DOES_NOT_EXIST)
		{
			ShowError(0, "GetServiceStatus");
		}
	}

    CloseServiceManager();

	if (hService != NULL)
	{
		fb_status.UseService = TRUE;

		QueryServiceStatus(hService,&status_info); 
		CloseServiceHandle (hService);
		switch (status_info.dwCurrentState)
		{
			case SERVICE_STOPPED :
			{
				if (GetFirebirdHandle())
					result = IDS_APPLICATION_RUNNING;
				else
					result = IDS_SERVICE_STOPPED;
				break;
			}
			case SERVICE_START_PENDING :
			{
				result = IDS_SERVICE_START_PENDING;
				break;
			}
			case SERVICE_STOP_PENDING : 
			{
				result = IDS_SERVICE_STOP_PENDING;
				break;
			}
			case SERVICE_RUNNING : 
			{
				result = IDS_SERVICE_RUNNING;
				break;
			}
			case SERVICE_CONTINUE_PENDING :
			{
				result = IDS_SERVICE_CONTINUE_PENDING;
				break;
			}
			case SERVICE_PAUSE_PENDING : 
			{
				result = IDS_SERVICE_PAUSE_PENDING;
				break;
			}
			case SERVICE_PAUSED :
			{
				result = IDS_SERVICE_PAUSED;
				break;
			}
			default :
			{
				result = IDS_APPLICATION_STOPPED;
				break;
			}
		}
	}
	else
	{
		fb_status.UseService = FALSE;

		//Firebird might still be running so...
		if (GetFirebirdHandle() != NULL) 
			result = IDS_APPLICATION_RUNNING;
	}
	
	return result;
	
}

bool CFBDialog::GetServiceInstalled()
{
	return fb_status.UseService;
}


void CFBDialog::AppGetName(char * app)
{
	//This just returns the name of the application to start

	if (fb_status.UseGuardian)
	{
		::strcat(app,m_Guardian_Name);
	}
	else
	{
		::strcat(app,m_Server_Name);
	}
	char opt[4] = " -a";
	::strcat(app,opt);
}
