#!/usr/bin/env perl

BEGIN
    {
        unshift @INC, '../lib';
    }

use Pony::Db;
use Pony::Object;

#
# Init db
#
Pony::Db->new( Redis => { prefix => '123' } );

use Pony::Orm;

my $orm = new Pony::Orm;
   $orm->keys = [ qw/name mail/ ];
   $orm->set  = 'user';

my $user = $orm->load ({
                        name    => 'User',
                        mail    => 'user@host.com',
                        web     => 'http://lorcode.org',
                        regdate => time,
                    });


say dump $user;

__END__
#
#   Test Orm::User
#
use Orm::User;

my $user = new Orm::User;
my $id = $user->load({
                        name    => 'User',
                        mail    => 'user@host.com',
                        web     => 'http://lorcode.org',
                        regdate => time,
                    });

print $id;
