#!/usr/bin/env perl

use lib './lib';
use lib './t';

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 33;

use_ok 'Pony::Object';
use_ok 'Data::Dumper';
use_ok 'Acme::Comment';

use Pony::Object;
use Object::FirstPonyClass;
use Object::SecondPonyClass;
use Object::ThirdPonyClass;
use Object::FourthPonyClass;
use Object::Singleton;
use Object::SingletonExt;

    /**
     * Multi line C-style comment test.
     */

    // One line C-style comment test.

    # Stand alone class.
    my $c1 = new Object::FirstPonyClass;
    
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
    my $c2 = new Object::SecondPonyClass;
    
    ok( 'a' eq $c2->a, 'Property default value from base class' );
    ok( 'dd'eq $c2->d, 'Property polymorphism' );
    ok( 'bb'eq $c2->b, 'Method polymorphism' );
    ok( 'bb'eq $c2->a, 'Change property in method ... again' );
    ok( 'e' eq $c2->e, 'new Object::method' );
    
    # Multiple inheritance.
    my $c3 = new Object::ThirdPonyClass;
    
    ok( 'dd' eq $c3->d, 'Property inheritance in multiple inheritance' );
    ok( 'bb' eq $c3->b, 'Method inheritance in multiple inheritance' );
    ok( 'bb' eq $c3->a, 'Change property in method ... and again' );
    
    my $c4 = new Object::FourthPonyClass;
    
    ok( 'd' eq $c4->d, 'Property inheritance in multiple inheritance 2' );
    ok( 'b' eq $c4->b, 'Method inheritance in multiple inheritance 2' );
    ok( 'b' eq $c4->a, 'Change property in method ... and again 2' );
    
    # Singleton.
    my $s1 = new Object::Singleton;
    ok( 'a' eq $s1->a );
    
    $s1->a = 's';
    ok( 's' eq $s1->a );
    
    my $s2 = new Object::Singleton;    
    ok( 's' eq $s2->a, 'Singleton test 1' );
    $s2->a = 'z';
    
    ok( 'z' eq $s1->a, 'Singleton test 2' );
    
    my $s3 = new Object::SingletonExt;
    ok( 'a' eq $s3->a, 'extends Singleton' );
    ok( 'hh'eq $s3->h, 'extends Singleton 2' );
    $s3->a = 'g';
    
    my $s4 = new Object::SingletonExt;
    ok( 'a' eq $s4->a, 'extends Singleton is not singleton' );
    ok( 'hh'eq $s4->h, 'extends Singleton polymorphism' );
    
    diag( "Testing Pony::Object $Pony::Object::VERSION" );
    
