package Pony;

use warnings;
use strict;
no  strict 'refs';
use feature ':5.10';
use Storable qw/freeze/;

sub import
    {
        my $this = shift;
        my $call = caller;
        my $isa  = $call . '::ISA';
        
        push @$isa, @_;
        
        strict->import;
        warnings->import;
        feature->import(':5.10');
        
        *{$call.'::has'} = sub { addAttr($call, @_) };
    }

sub addAttr
    {
        my ( $this, $attr, $value ) = @_;
        
        given ( ref $value )
        {
            when ( 'CODE' )
            {
                *{$this."::$attr"} = $value;
            }
            
            default
            {       
                eval "unless ( $this->can('new') )
                      {
                          sub ${this}::new
                              {
                                  my \$this = shift;
                                  my \%obj = \%{${this}::all};
                                  bless \\\%obj, \$this;
                              }
                      }
                      
                      \%{${this}::all} = ( \%{${this}::all},
                                          $attr => \$value );
                      
                      sub ${this}::$attr : lvalue
                      {
                          my \$this = shift;
                             \$this->{$attr};
                      }";
            }
        }
    }

1;

__END__

=head1 EXAMPLE

    package test;
    use Pony;
    
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
    
    package main;
    use Pony;
    use test;
    
    my $var = new test;
    
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

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut

