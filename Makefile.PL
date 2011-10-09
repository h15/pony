use inc::Module::Install 1.0;
use strict;
use warnings;
use Cwd;
use 5.010001;

perl_version '5.010001';
name 'Pony';
author 'Georgy Bazhukov <gosha.bugov@gmail.com>';
resources 'license'     => 'http://dev.perl.org/licenses/';
resources 'repository'  => 'git://github.com/h15/pony.git';

my $dir = getcwd;

all_from "$dir/lib/Pony/Object.pm";

test_requires "Test::More"      => 0.96;

no_index directory => 'examples';

install_script 'install';

tests_recursive 't';

auto_install();

WriteAll();
