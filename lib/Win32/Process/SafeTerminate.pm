# lib/Win32/Process/SafeTerminate.pm
# Copyright (c) 2008 by David Golden. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

package Win32::Process::SafeTerminate;
use strict;
use warnings;

our $VERSION = '0.01';
$VERSION = eval $VERSION; 

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = ( 'safe_terminate' );

require XSLoader;
XSLoader::load('Win32::Process::SafeTerminate', $VERSION);

1;

__END__

=begin wikidoc

= NAME

Win32::Process::SafeTerminate -- Safer termination of Win32::Process objects

= VERSION

This documentation describes version %%VERSION%%.

= SYNOPSIS


= DESCRIPTION


= USAGE


= BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
[http://rt.cpan.org/Dist/Display.html?Queue=Win32-Process-SafeTerminate]

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= ACKNOWLEDGMENTS 

* Safe termination C code adapted from article by Andrew Tucker 
on Dr. Dobb's Portal: [http://www.ddj.com/windows/184416547] 
* Some XS code and typemap adapted from [Win32::Process]

= AUTHOR

David A. Golden (DAGOLDEN)

= COPYRIGHT AND LICENSE

Copyright (c) 2008 by David A. Golden

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at 
[http://www.apache.org/licenses/LICENSE-2.0]

Files produced as output though the use of this software, shall not be
considered Derivative Works, but shall be considered the original work of the
Licensor.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end wikidoc

=cut
