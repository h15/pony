#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';
use lib './t';

use Test::More tests => 4;

use_ok 'Pony::Object';

use Pony::Object;
use Object::ProtectedPony2;
use Object::ProtectedPony3;

    my $p = new Object::ProtectedPony2;
    
    $p->setA(1);
    ok( $p->getA() eq 1, 'Test protected method internal call');
    
    eval { $p->_getA() };
    ok( defined $@, 'Test protected method external call');
    
    $p->setA(2);
    ok( $p->getA() eq 2, 'Change protected property');


    my $p1 = new Object::ProtectedPony3;
    
    $p1->setA(1);
    ok( $p1->getA() eq 1, 'Test protected method internal call');
    
    eval { $p1->_getA() };
    ok( defined $@, 'Test protected method external call');
    
    $p1->setA(2);
    ok( $p1->getA() eq 2, 'Change protected property');

1;
