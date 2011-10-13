#!/usr/bin/env perl

use lib '../lib';

use strict;
use warnings;
use Test::More tests => 27;

use_ok( 'Pony::Object' );

package FirstPonyClass;
use Pony::Object;

    # properties
    has a => 'a';
    has d => 'd';
    
    # method
    has b => sub
        {
            my $this = shift;
               $this->a = 'b';
               
            return ( @_ ?
                        shift:
                        'b'  );
        };

    # traditional perl method
    sub c { 'c' }

package SecondPonyClass;
# extends FirstPonyClass
use Pony::Object qw/FirstPonyClass/;

    # test polymorphism
    has d => 'dd';

    has b => sub
        {
            my $this = shift;
               $this->a = 'bb';
               
            return ( @_ ?
                        shift:
                        'bb'  );
        };
    
    # new method
    has e => sub {'e'};

package ThirdPonyClass;
# extends SecondPonyClass FirstPonyClass
use Pony::Object qw/SecondPonyClass FirstPonyClass/;

package FourthPonyClass;
# extends FirstPonyClass SecondPonyClass
use Pony::Object qw/FirstPonyClass SecondPonyClass/;

package Singleton;
use Pony::Object singleton => qw/FirstPonyClass SecondPonyClass/;

package main;
    
    # Stand alone class.
    my $c1 = new FirstPonyClass;
    
    ok( 'a' eq $c1->a, 'Property default value' );
    ok( 'd' eq $c1->d );
    ok( 'b' eq $c1->b );
    ok( 'b' eq $c1->a, 'Change property in method' );
    ok( 'bb'eq $c1->b('bb'), 'Use method with param' );
    ok( 'c' eq $c1->c, 'Traditional perl method' );
    
    my $a = $c1->a = 'a';
    
    ok( 'a' eq $c1->a, 'Change property via "="' );
    ok( 'a' eq $a, 'Change property and return value like a simple var' );
    ok( 'b' eq ($c1->a = 'b'), 'Return value afret change property via "="' );
    
    $c1->d = [qw/a b/];
    
    ok( 'b' eq $c1->d->[1], 'Property is an array' );
    
    $c1->d = {qw/a b/};
    
    ok( 'b' eq $c1->d->{a}, 'Property is a hash' );
    
    # Inheritance tests.
    my $c2 = new SecondPonyClass;
    
    ok( 'a' eq $c2->a, 'Property default value from base class' );
    ok( 'dd'eq $c2->d, 'Property polymorphism' );
    ok( 'bb'eq $c2->b, 'Method polymorphism' );
    ok( 'bb'eq $c2->a, 'Change property in method ... again' );
    ok( 'e' eq $c2->e, 'New method' );
    
    # Multiple inheritance.
    my $c3 = new ThirdPonyClass;
    
    ok( 'dd' eq $c3->d, 'Property inheritance in multiple inheritance' );
    ok( 'bb' eq $c3->b, 'Method inheritance in multiple inheritance' );
    ok( 'bb' eq $c3->a, 'Change property in method ... and again' );
    
    my $c4 = new FourthPonyClass;
    
    ok( 'd' eq $c4->d, 'Property inheritance in multiple inheritance 2' );
    ok( 'b' eq $c4->b, 'Method inheritance in multiple inheritance 2' );
    ok( 'b' eq $c4->a, 'Change property in method ... and again 2' );
    
    # Singleton.
    my $s1 = new Singleton;
    ok( 'a' eq $s1->a );
    
    $s1->a = 's';
    ok( 's' eq $s1->a );
    
    my $s2 = new Singleton;
    ok( 's' eq $s2->a, 'Singleton test 1' );
    $s2->a = 'z';
    
    ok( 'z' eq $s1->a, 'Singleton test 2' );

    diag( "Testing Pony::Object $Pony::Object::VERSION" );
    
