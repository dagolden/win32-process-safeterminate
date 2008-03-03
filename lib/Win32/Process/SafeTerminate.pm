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
$VERSION = eval $VERSION; # convert '1.23_45' to 1.2345

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = ( 'safe_terminate' );

require XSLoader;
XSLoader::load('Win32::Process::SafeTerminate', $VERSION);

1;

__END__

=begin wikidoc

= NAME

= ACKNOWLEDGEMENTS

* SafeTerminateProcess adapted from article by Andrew Tucker 
on Dr. Dobb's Portal: [http://www.ddj.com/windows/184416547] 
* XS code and typemap adapted from [Win32::Process]

=end wikidoc

=cut
