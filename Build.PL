#!/usr/bin/env perl

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new
(
	module_name         => 'Pony',
	dist_abstract       => 'web developer\'s libs',
	license             => 'perl',
	dist_author         => 'Georgy Bazhukov <gosha@bugov.net>',
	dist_version_from   => 'lib/Pony.pm',
	build_requires =>
	{
		'Test::More' => 0,
	},
	requires =>
	{
		'perl' => '5.010',
		'Storable' => 0,
		'Carp' => 0,
	},
	meta_merge =>
	{
		resources =>
		{
			repository => 'https://github.com/h15/pony',
		},
		keywords => [ qw/web framework/ ],
	},
	add_to_cleanup     => [],
	create_makefile_pl => 'traditional',
);

$builder->create_build_script();
