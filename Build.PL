# Build.PL
# Copyright (c) 2008 by David Golden. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use Module::Build;
my $build = Module::Build->new(
    module_name => 'Win32::Process::SafeTerminate',
    dist_author => 'David Golden <dagolden@cpan.org>',
    license => 'perl',
    create_readme => 1,
#   create_makefile_pl  => 'traditional',
    requires => {
        'perl' => '5.004',
    },
    build_requires => {
        'Test::More' => 0.47,
    },
    meta_add            => { 
        no_index => { 
            directory => [ qw{
                examples
                inc
                t
            }],
        } 
    },
);
$build->create_build_script;

