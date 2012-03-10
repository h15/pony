#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 54;

use_ok 'Pony::Object';

package ProtectedPony;
use Pony::Object;

    protected a => 'a';
    public    b => 'b';
    protected c => undef;
    
    sub getA
        {
            return shift->_getA();
        }
    
    sub setA
        {
            shift->a = shift;
        }
    
     sub _getA : protected
        {
            return shift->a;
        }

1;

package main;

    my $p = new ProtectedPony;
    
    eval { $p->a = 1 };
    ok( $@ ne undef, 'Test protected property');
    
    eval { $p->_getA() };
    ok( $@ ne undef, 'Test protected method');
    
    my $a = $p->getA();
    ok( $a eq 'a' );
    
    $p->setA(1);
    
    ok( $p->getA() eq 1, 'Change protected property');
