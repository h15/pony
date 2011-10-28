#!/usr/bin/perl

use Test::More tests => 31;

#
#   Check modules.
#
use lib '../lib';

use Pony::Db;
use Pony::Object;
use Digest::MD5 qw(md5_hex);

use_ok 'Pony::Object';
use_ok 'Pony::Db';
use_ok 'Pony::Db::Redis';

no strict 'refs';
ok( ${'Redis::VERSION'} > 1.9, 'Check version' );
use strict 'refs';

my %users = (
                 mail   => undef,
                 nick   => undef,
                 first  => undef,
                 last   => undef,
                 web    => undef,
                 secret => undef,
            );

#
#   Start connection.
#
my $db = new Pony::Db (
            Redis => { server => { server => '127.0.0.1:6379' },
                       prefix => 'Meih0Vi2' } );

ok( $db->raw->ping, 'Is server alive?' );

#
#   Simple test of base functions.
#
$db->create( user =>
             {
                 mail   => 'gosha@lorcode.org',
                 nick   => 'bugov',
                 first  => 'Gosha',
                 last   => 'Bugov',
                 web    => 'http://lorcode.org',
                 secret => md5_hex('secret'),
             },
             [qw/mail nick/] );

my $user = $db->read( user => { nick => 'bugov' } );
ok( $user->{nick} eq 'bugov', 'Create + Read' );

$db->update( user => { data  => { first => 'Georgy' },
                       where => { nick  => 'bugov'  } });

$user = $db->read( user => { nick => 'bugov' } );
ok( $user->{first} eq 'Georgy', 'Update' );

my $count = $db->count('user');
ok( $count ne '0', 'Count' );

$db->delete( user => { nick => 'bugov' }, [qw/mail nick/] );

#
#   Many records.
#
for my $n ( 0 .. 10_000 )
{
    @$user{ qw/mail nick secret/ } =
        ("user$n\@lorcode.org", "user$n", md5_hex "secret$n" );
    
    $db->create( user => %$user, [qw/mail nick/] );
    
    delete @$user{ qw/mail nick first last web secret/ };
}

for ( 1 .. 10 )
{
    my $n = int rand 10_000;
    $user = $db->read( user => { nick => "user$n" } );
    ok( $user->{nick} eq "user$n" );
}

for my $n ( 1000 .. 2000 )
{
    $db->update( user => { data  => { first => "User$n" },
                           where => { nick  => "user$n" } });
}

for ( 1 .. 10 )
{
    my $n = int rand 10_000;
    $user = $db->read( user => { nick => "user$n" } );
    ok( $user->{first} eq "User$n" );
}

for my $n ( 1500 .. 2500 )
{
    $db->delete( user => { id => $n } );
}

$count = $db->count('user');
ok( $count == 9_000, 'Delete' );

diag( "Testing Pony::Db::Redis $Pony::Db::Redis::VERSION" );

