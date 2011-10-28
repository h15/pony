#!/usr/bin/env perl

use Cwd;
use lib getcwd . '/../lib';
use Test::More tests => 2;

package main;
use Pony::Object;
use Pony::Db;
use Orm::User;

    Pony::Db->new( Redis => { prefix => '123' } );
    
    my $user = new Orm::User;
       $user->load({id=>3});
       $user->del;
       die;
       $user->name = 'User';
       $user->mail = 'user@host.com';
       $user->web  = 'http://lorcode.org';
       $user->regdate = time;
       $user->save;
    die dump $user;
    my $hash = $user->raw->read(user => { id => $user->id });
    
    ok( 'User' eq $user->name   );
    ok( 'User' eq $hash->{name} );
#    $user->load({ name => 'User' });
    
