#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';

use lib './lib';
use lib './t';

use Test::More tests => 54;
use Object::ProtectedPony;
use Object::ProtectedPonyExt;

    my $p = new Object::ProtectedPony;
    
    eval { $p->a = 1 };
    ok( defined $@, 'Test protected property' );
    
    eval { $p->_getA() };
    ok( defined $@, 'Test protected method' );
    
    $p->setA(1);
    my $a = $p->getA();
    ok( $a eq '1', 'Change protected property via public method' );
    
    $p->b = 2;
    $p->sum();
    ok( $p->getC eq 3 );
    
    my $magic = $p->magic();
    ok( $magic eq 57006 );

#

    my $pe = new Object::ProtectedPonyExt;
    
    eval { $pe->a = 1 };
    ok( defined $@, 'Test protected property' );
    
    eval { $pe->_getA() };
    ok( defined $@, 'Test protected method' );
    
    $pe->setA(1);
    $a = $pe->getA();
    ok( $a eq '1', 'Change protected property via public method' );
    
    $pe->b = 2;
    $pe->sum();
    ok( $pe->getC eq 3 );
    
    $magic = $pe->magic();say $magic;
    ok( $magic eq 57006 );

1;

