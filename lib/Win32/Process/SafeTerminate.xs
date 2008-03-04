    # lib/Win32/Process/SafeTerminate.pm
    # Copyright (c) 2008 by David Golden. All rights reserved.
    # Licensed under terms of Perl itself (the "License").
    # You may not use this file except in compliance with the License.
    # A copy of the License was distributed with this file or you may obtain a 
    # copy of the License from http://dev.perl.org/licenses/

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
safe_terminate(process_obj, uExitCode)
    SV *    process_obj 
    UINT   uExitCode
PREINIT:
    BOOL    bSuccess = FALSE;
    DWORD   dwTID, dwCode = 0;
    HANDLE  hProcess = NULL;
    HANDLE  hRemoteThread = NULL;
    HINSTANCE hKernel;
    FARPROC pfnExitProc;
    I32     call_ok;
CODE:
    if ( ! uExitCode ) 
        uExitCode = 15;

    if ( process_obj ) {
        dSP;
        PUSHMARK(SP);
        XPUSHs(process_obj);
        PUTBACK;
        call_ok = call_method("get_process_handle",G_SCALAR);

        if ( call_ok != 1) 
            croak("Couldn't retrieve process handle");
            
        hProcess = (HANDLE) POPl;
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
                (LPVOID)uExitCode, 0, &dwTID
            );

            if ( hRemoteThread )
            {
                // Must wait process to terminate to 
                // guarantee that it has exited...
                // through really should wait only a bit and give up
                // in case of deadlock
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
