#!/usr/bin/env perl

use Cwd;
use lib getcwd . '/../lib';
use Test::More tests => 2;

package main;
use Pony::Object;
use Pony::Db;
use Orm::User;

    Pony::Db->new( Redis => { prefix => '123' } );
    
    # Create ORM object and init with some data.
    my $user0 = new Orm::User;
       $user0->load({ name => 'User111111' });
    
    if (! $user0->exists )
    {
        my $user1 = new Orm::User;
           $user1->name = 'User111111';
           $user1->mail = 'user111111@host.com';
           $user1->web  = 'http://lorcode.org';
           $user1->regdate = time;
           $user1->save;
        
        my $user2 = new Orm::User;
           $user2->load({ id => $user1->id });
        die;
        say dump $user2;
        
        $user2->del;
    }
    
__END__
    #die dump $user;
    my $hash = $user->raw->read(user => { id => $user->id });
    say dump $hash;
    ok( 'User' eq $user->name   );
    ok( 'User' eq $hash->{name} );
#    $user->load({ name => 'User' });
    
