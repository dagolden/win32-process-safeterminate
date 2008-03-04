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
    #    in the process to terminate that calls ExitProcess
    #
    #    Exit code defaults to 15 (e.g. SIGTERM)

BOOL 
safe_terminate(dwPID, uExitCode=15)
    DWORD   dwPID
    UINT    uExitCode
PREINIT:
    BOOL    bSuccess = FALSE;
    DWORD   dwTID, dwCode = 0;
    HANDLE  hProcess = NULL ;
    HANDLE  hRemoteThread = NULL;
    HINSTANCE hKernel;
    FARPROC pfnExitProc;
CODE:
    // If we can't open the process with PROCESS_TERMINATE rights,
    // then we have to give up
    if ( dwPID ) {
        hProcess = OpenProcess(
            SYNCHRONIZE | 
            PROCESS_TERMINATE | 
            PROCESS_DUP_HANDLE | 
            PROCESS_QUERY_INFORMATION, 
            FALSE, dwPID
        );
    }

    if ( hProcess ) {
        hKernel = GetModuleHandle("Kernel32");

        // Don't shoot a dead horse
        if ( ( GetExitCodeProcess(hProcess, &dwCode) ) && 
             ( dwCode == STILL_ACTIVE) ) 
        {
            pfnExitProc = GetProcAddress(hKernel, "ExitProcess");

            hRemoteThread = CreateRemoteThread( 
                hProcess, 
                NULL, 
                0, 
                (LPTHREAD_START_ROUTINE)pfnExitProc,
                (PVOID)uExitCode, 0, &dwTID
            );

            if ( hRemoteThread )
            {
                // Must wait process to terminate to 
                // guarantee that it has exited...
                WaitForSingleObject(hProcess, INFINITE);
                CloseHandle(hRemoteThread);
                bSuccess = TRUE;
            }
        }

        CloseHandle(hProcess);
    }

    RETVAL = bSuccess;
OUTPUT:
    RETVAL
