#!/usr/bin/env perl

use lib './lib';
use Test::More tests => 10;

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

package FormManyFields;
use Pony::Object qw/Pony::View::Form/;

    has action => '/registration';
    has method => 'post';
    has id     => 'form-registration';

    sub create
        {
            my $this = shift;
            
            $this->addElement
            (
                name => text =>
                {
                    required    => 1,
                    label       => 'Name',
                }
            );
            
            $this->addElement
            (
                mail => text =>
                {
                    required    => 1,
                    label       => 'E-mail',
                    validators  =>
                    {
                        Like    => qr/[\.\-\w\d]+\@(?:[\.\-\w\d]+\.)+[\w]{2,5}/,
                    }
                }
            );
            
            $this->addElement
            (
                password => password =>
                {
                    required    => 1,
                    label       => 'Password',
                    validators  =>
                    {
                        Length  => [ 8, 32 ],
                        Have    => [ qw/- 1 a A/ ],
                    }
                }
            );
            
            $this->addElement
            (
                password2 => password =>
                {
                    required    => 1,
                    label       => 'Retype password',
                    validators  =>
                    {
                        Length  => [ 8, 32 ],
                        Have    => [ qw/- 1 a A/ ],
                    }
                }
            );
            
            $this->addElement( submit => submit => {ignore => 1} );
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

$form[1] =
q{<form action="/registration" method="post" id="form-registration" >
<table class="pony-form">
<tr>
<td>Name</td>
<td><input class="pony-text" id="form-registration-name" value="" name="name" required="1">
</td>
<td>*</td>
</tr><tr>
<td>E-mail</td>
<td><input class="pony-text" id="form-registration-mail" value="" name="mail" required="1">
</td>
<td>*</td>
</tr><tr>
<td>Password</td>
<td><input class="pony-password" type=password id="form-registration-password" name="password" required="1">
</td>
<td>*</td>
</tr><tr>
<td>Retype password</td>
<td><input class="pony-password" type=password id="form-registration-password2" name="password2" required="1">
</td>
<td>*</td>
</tr><tr>
<td></td>
<td><input class="pony-submit" type=submit id="form-registration-submit" name="submit">
</td>
<td></td>
</tr>
</table>
</form>};

$form[2] = q{<form action="/registration" method="post" id="form-registration" >
<table class="pony-form">
<tr>
<td>Name</td>
<td><input class="pony-text" id="form-registration-name" value="" name="name" required="1">
</td>
<td>*</td>
</tr><tr>
<td>E-mail</td>
<td><input class="pony-text" id="form-registration-mail" value="" name="mail" required="1">
</td>
<td>*</td>
</tr><tr>
<td>Password</td>
<td><input class="pony-password" type=password id="form-registration-password" name="password" required="1">
<div class="error"><ul class=error><li>too short</li><li>does not valid</li></ul></div></td>
<td>*</td>
</tr><tr>
<td>Retype password</td>
<td><input class="pony-password" type=password id="form-registration-password2" name="password2" required="1">
<div class="error"><ul class=error><li>does not valid</li></ul></div></td>
<td>*</td>
</tr><tr>
<td></td>
<td><input class="pony-submit" type=submit id="form-registration-submit" name="submit">
</td>
<td></td>
</tr>
</table>
</form>};

clean();

Pony::Stash->new('./t/03-stash/config.dat');
Pony::Stash->set( PonyValidatorPrefixes => ['Pony::View::Form::Validator'] );

my $formText = new FormText;
my $a = $formText->render();

ok( $form[0] eq $a, 'Render simple for with text input' );

my $formReg = new FormManyFields;
   $a = $formReg->render();

ok( $form[1] eq $a, 'Render advanced form' );

my $data =  {
                name => 'Gosha',
                mail => 'gosha.bugov@gmail.com',
                password => '1234567',
                password2 => '123456789',
            };

$formReg->data = $data;
$formReg->isValid();

my $e = $formReg->errors;

ok( 2 eq keys %$e, 'Errors 1' );
ok( 'too short' eq $e->{'password'}->[0][0], 'Errors 2' );
ok( 'does not valid' eq $e->{'password'}->[0][1], 'Errors 3' );
ok( 'does not valid' eq $e->{'password2'}->[0][0], 'Errors 4' );

$a = $formReg->render();

ok( $form[2] eq $a, 'Render advanced form after error' );

    # Clean up
    #
    sub clean
        {
            open  C, '>./t/03-stash/config.dat' or die;
            print C '';
            close C;
        }


clean();
