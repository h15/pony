#!/usr/bin/env perl

use lib './lib';
use Test::More tests => 2;

use_ok 'Pony::Object';
use_ok 'Pony::View::Form';
use_ok 'Pony::Stash';

use Pony::Object;
use Pony::Stash;

package FormText;
use Pony::Object qw/Pony::View::Form/;

    has action => '/user';
    has method => 'post';
    has id     => 'form-user';
    
    sub create
        {
            my $this = shift;
            
            $this->addElement ( mail => text => { required  => 1,
                                                  label     => 'E-mail' } );
        }

    1;

package main;

clean();

Pony::Stash->new('./t/03-stash/config.dat');

my $formText = new FormText;

print $formText->render();

    /**
     *  Clean up
     */
    sub clean
        {
            open  C, '>./t/03-stash/config.dat' or die;
            print C '';
            close C;
        }


clean();
