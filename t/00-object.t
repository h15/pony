#!/usr/bin/env perl

use lib './lib';
use lib './t';

use strict;
use warnings;

use Test::More tests => 55;

use_ok 'Pony::Object';
use_ok 'Data::Dumper';

use Pony::Object;
use Object::FirstPonyClass;
use Object::SecondPonyClass;
use Object::ThirdPonyClass;
use Object::FourthPonyClass;
use Object::Singleton;
use Object::SingletonExt;
use Object::DeepCopy;
use Object::DeepCopyExt;
use Object::DeepCopyExtExt;

package main;
    
    # Stand alone class.
    #
    
    my $c1 = new Object::FirstPonyClass;
    #say dump $c1;die;
    
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
    #
    
    my $c2 = new Object::SecondPonyClass;
    
    ok( 'a' eq $c2->a, 'Property default value from base class' );
    ok( 'dd'eq $c2->d, 'Property polymorphism' );
    ok( 'bb'eq $c2->b, 'Method polymorphism' );
    ok( 'bb'eq $c2->a, 'Change property in method ... again' );
    ok( 'e' eq $c2->e, 'new Object::method' );
    
    # Multiple inheritance.
    #
    
    my $c3 = new Object::ThirdPonyClass;
    
    ok( 'dd' eq $c3->d, 'Property inheritance in multiple inheritance' );
    ok( 'bb' eq $c3->b, 'Method inheritance in multiple inheritance' );
    ok( 'bb' eq $c3->a, 'Change property in method ... and again' );
    
    my $c4 = new Object::FourthPonyClass;
    
    ok( 'd' eq $c4->d, 'Property inheritance in multiple inheritance 2' );
    ok( 'b' eq $c4->b, 'Method inheritance in multiple inheritance 2' );
    ok( 'b' eq $c4->a, 'Change property in method ... and again 2' );
    
    # Singleton.
    #
    
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
    
    # Deep copy
    #
    
    my $w1 = new Object::DeepCopy;
    my $w2 = new Object::DeepCopy;
    
    push @{ $w1->ary }, qw/one two three/;
    push @{ $w2->ary }, qw/1 2 3/;
    
    ok( @{ $w2->ary } eq 3, 'Deep Copy: simple array' );
    
    my $w3 = new Object::DeepCopy;
    my $w4 = new Object::DeepCopy;
    
    for my $i ( 1 .. 3 )
    {
        $w3->struct->{group}->{"item$i"}->{foo} = "val1$i";
        $w3->struct->{group}->{"item$i"}->{bar} = "val2$i";
    }
    
    $w1->struct->{group} = { qw/one 1 two 2 three 3/ };
    
    ok( $w3->struct->{group}->{item2}->{foo} eq "val12", 'Deep Copy 1' );
    ok( $w3->struct->{group}->{item3}->{bar} eq "val23", 'Deep Copy 2' );
    ok( $w4->struct->{group}->{item2}->{foo} eq "value", 'Deep Copy 3' );
    ok( $w4->struct->{group}->{item3}->{bar} eq "value", 'Deep Copy 4' );
    ok( $w3->struct->{group}->{item2}->{foo} eq "val12", 'Deep Copy 5' );
    ok( $w3->struct->{group}->{item3}->{bar} eq "val23", 'Deep Copy 6' );
    
    my $dce1 = new Object::DeepCopyExt;
    my $dce2 = new Object::DeepCopyExt;
    
    ok( $dce1->struct->{group}->{item2}->{foo}
        eq "value", 'Deep Copy inheritance 1' );
    ok( $dce1->struct->{group}->{item3}->{bar}
        eq "value", 'Deep Copy inheritance 2' );
    
    $dce2->struct->{group} = { qw/one 1 two 2 three 3/ };
    
    ok( $dce2->struct->{group}->{one} eq 1, 'Deep Copy inheritance 3' );
    ok( $dce2->struct->{group}->{two} eq 2, 'Deep Copy inheritance 4' );
    ok( $dce1->struct->{group}->{item2}->{foo}
        eq "value", 'Deep Copy inheritance 5' );
    
    my $dcee1 = new Object::DeepCopyExtExt;
    my $dcee2 = new Object::DeepCopyExtExt;
    
    ok( $dcee1->struct->{group}->{item2}->{foo}
        eq "value", 'Deep Copy inh inh 1' );
    ok( $dcee1->struct->{group}->{item3}->{bar}
        eq "value", 'Deep Copy inh inh 2' );
    
    $dcee2->struct->{group} = { qw/one 1 two 2 three 3/ };
    
    ok( $dcee2->struct->{group}->{one} eq 1, 'Deep Copy inh inh 3' );
    ok( $dcee2->struct->{group}->{two} eq 2, 'Deep Copy inh inh 4' );
    ok( $dcee1->struct->{group}->{item2}->{foo}
        eq "value", 'Deep Copy inh inh 5' );
    
    # ALL
    #
    
    my $all = $c1->ALL();
    
    ok( 'a' eq $all->{a}, 'Check ALL property 1' );
    ok( 'd' eq $all->{d}, 'Check ALL property 2' );
    
    $all = $dcee1->ALL();
    
    ok( 'value' eq $all->{struct}->{group}->{item1}->{foo},
                                        'Check ALL property 3' );
    
    $all = $s3->ALL();
    
    ok( 'a' eq $all->{a}, 'Check ALL property 4' );
    ok( 'hh'eq $all->{h}, 'Check ALL property 5' );
    
    # Copy object
    #
    
    my $copyObj1 = new Object::FirstPonyClass;
    my $copyObj2 = $copyObj1;#->clone();
    
    $copyObj1->a = 'j';
    say dump $copyObj2;
    ok( $copyObj2->a eq 'a', 'Test object copy' );
    
    diag( "Testing Pony::Object $Pony::Object::VERSION" );
    
