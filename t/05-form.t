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

# Init forms' data for tests.
#

my @form;

$form[0] =
q{<form action="/user" method="post" id="form-user" >
<table class="pony-form">
<tr>
<td>E-mail</td>
<td><input class="pony-text" id="form-user-mail" value="" name="mail" required="1">
</td>
<td>*</td>
</tr>
</table>
</form>};

clean();

Pony::Stash->new('./t/03-stash/config.dat');

my $formText = new FormText;
my $a = $formText->render();

ok( $form[0] eq $a, 'Render simple for with text input' );

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
