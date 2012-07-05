#!/usr/bin/env perl

use lib './lib';
use Test::More tests => 8;

use_ok 'Pony::Object';
use_ok 'Pony::Stash';

use Pony::Object;
use Pony::Stash;

    clean();

    {
        my $conf = new Pony::Stash('./t/03-stash/config.yaml');
           $conf->set( user => { table   => 'users',
                                 default => 'anonymous' } );
           
        my $u = $conf->findOrCreate( user => { table => 'u', default => 'anon' } );
        
        ok( 'users' eq $u->{table}, 'findOrCreate (find)' );
        
        my $a = $conf->findOrCreate( article => { table => 'article' } );
        
        ok( 'article' eq $a->{table}, 'findOrCreate (create)' );
        
        $a->{table} = 'art';
        $conf->set( article => $a );
        $a = $conf->get('article');
        
        ok( 'art' eq $a->{table}, 'update via set' );
    }

    my $u = Pony::Stash->get('user');

    ok( 'users' eq $u->{table}, 'get from singleton' );

    my $stash = new Pony::Stash;

    Pony::Stash->save;
    Pony::Stash->new->init('./t/03-stash/stash.yaml');

    $u = Pony::Stash->findOrCreate( user => { table => 'u', default => 'anon' } );

    ok( 'u' eq $u->{table}, 'findOrCreate (create). 2nd stash.' );

    Pony::Stash->save;
    Pony::Stash->new->init('./t/03-stash/config.yaml');

    $u = Pony::Stash->findOrCreate( user => { table => 'u', default => 'anon' } );

    ok( 'users' eq $u->{table}, 'findOrCreate (find). Back to 1st stash.' );

    #clean();

    diag( "Testing Pony::Stash $Pony::Stash::VERSION" );

    # Clean up
    #
    sub clean
        {
            open  C, '>./t/03-stash/config.yaml' or die;
            print C '';
            close C;
        }
