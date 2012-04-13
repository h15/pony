#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';
use lib './t';

use Test::More tests => 54;

use_ok 'Pony::Object';

use Pony::Object;
use Object::ProtectedPony;

    my $p = new Object::ProtectedPony;
    #$p->_a = 1;
    #say $p->_a;
    $p->setA(1);
    say $p->getA();
__END__
    eval { $p->_a = 1 };
    ok( $@ ne undef, 'Test protected property');
    
    eval { $p->_getA() };
    ok( $@ ne undef, 'Test protected method');
    
    my $a = $p->getA();
    ok( $a eq 'a' );
    
    $p->setA(1);
    
    ok( $p->getA() eq 1, 'Change protected property');

1;
