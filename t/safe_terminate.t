# Copyright (c) 2008 by David Golden. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;

plan tests => 5;

use Win32::Process 
    qw/ NORMAL_PRIORITY_CLASS CREATE_SUSPENDED STILL_ACTIVE /;
use Win32::Process::SafeTerminate qw/safe_terminate/;

my ($process, $exitcode, $pid);

Win32::Process::Create(
    $process,
    $^X,
    qq{$^X -e "1 while 1},
    0,
    NORMAL_PRIORITY_CLASS,
    "."
) or die $^E;

ok( $process, "Started child process" );

$process->GetExitCode($exitcode);
is( $exitcode, STILL_ACTIVE, "Child process is active" );

ok( safe_terminate($process, 15), "Called safe_terminate with exit code 15" )
    or diag "ERROR: $^E";

$process->GetExitCode($exitcode);
isnt( $exitcode, STILL_ACTIVE, "Child process is dead" );
is( $exitcode, 15, "Child process exited with code 15" );

# cleanup in case SafeTerminate didn't
$process->GetExitCode($exitcode);
if ( $exitcode == STILL_ACTIVE ) {
    diag "!!! Cleaning up unkilled process !!!\n";
    $process->Kill(15);
}


