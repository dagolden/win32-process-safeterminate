#include <stdlib.h>		// avoid BCC-5.0 brainmelt
#include <math.h>		// avoid VC-5.0 brainmelt
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#if defined(__cplusplus)
#include <stdlib.h>
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.H"

MODULE = Win32::Process::SafeTerminate PACKAGE = Win32::Process::SafeTerminate

    #    SafeTerminateProcess adapted from article by Andrew Tucker 
    #    on Dr. Dobb's Portal: http://www.ddj.com/windows/184416547 
    #
    #    Safely terminate a process by creating a remote thread
    #    in the process that calls ExitProcess

BOOL 
SafeTerminateProcess(hProcess, uExitCode)
    HANDLE hProcess
    UINT uExitCode
CODE:
    DWORD dwTID, dwCode, dwErr = 0;
    HANDLE hProcessDup = INVALID_HANDLE_VALUE;
    HANDLE hRT = NULL;
    HINSTANCE hKernel = GetModuleHandle("Kernel32");
    BOOL bSuccess = FALSE;

    BOOL bDup = DuplicateHandle(GetCurrentProcess(), 
                                hProcess, 
                                GetCurrentProcess(), 
                                &hProcessDup, 
                                PROCESS_ALL_ACCESS, 
                                FALSE, 
                                0);

    // Detect the special case where the process is 
    // already dead...
    if ( GetExitCodeProcess((bDup) ? hProcessDup : hProcess, &dwCode) && 
         (dwCode == STILL_ACTIVE) ) 
    {
        FARPROC pfnExitProc;
           
        pfnExitProc = GetProcAddress(hKernel, "ExitProcess");

        hRT = CreateRemoteThread((bDup) ? hProcessDup : hProcess, 
                                 NULL, 
                                 0, 
                                 (LPTHREAD_START_ROUTINE)pfnExitProc,
                                 (PVOID)uExitCode, 0, &dwTID);

        if ( hRT == NULL )
            dwErr = GetLastError();
    }
    else
    {
        dwErr = ERROR_PROCESS_ABORTED;
    }


    if ( hRT )
    {
        // Must wait process to terminate to 
        // guarantee that it has exited...
        WaitForSingleObject((bDup) ? hProcessDup : hProcess, 
                            INFINITE);

        CloseHandle(hRT);
        bSuccess = TRUE;
    }

    if ( bDup )
        CloseHandle(hProcessDup);

    if ( !bSuccess )
        SetLastError(dwErr);

    RETVAL = bSuccess;
OUTPUT:
    RETVAL
    uExitCode
