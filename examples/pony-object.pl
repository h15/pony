package test;
use Pony::Object;

    # property
    has a => 'default value';

    # method
    has b => sub
        {
            my $this = shift;
            
            unless ( @_ )
            {
                say 'You are in method "b"';
            }
            else
            {
                say shift;
            }
        };

    # traditional perl method
    sub c
        {
            say 'Hello from method "c"';
        }

package test2;
use Pony::Object qw/test/;

    has a => 'Redefined value';

package main;
use Pony::Object;
    
    my $var = new test2;

    # test properties
    say $var->a;

    $var->a = 'new value';
    say $var->a;

    $var->a = [qw/new value/];
    say $var->a->[0];

    $var->a = {qw/new value/};
    say $var->a->{new};

    # test methods
    $var->b;
    $var->b('Another text in method "b"');

    $var->c;

