package Pony::Object;

use feature ':5.10';

our $VERSION = '0.000002';

sub import
    {
        my $this = shift;
        my $call = caller;
        my $isa  = "${call}::ISA";
        
        push @$isa, shift while @_;
        
        strict  ->import;
        warnings->import;
        feature ->import(':5.10');
        
        *{$call.'::has'} = sub { addAttr($call, @_) };
        
        eval qq{
        
          sub ${call}::new
          {
            my \$this  = shift;
            
            for my \$base ( \@{"\${this}::ISA"} )
            {
              my \$all = \$base->ALL;
              
              for my \$k ( keys \%\$all )
              {
              
                unless ( exists \${"${call}::ALL"}{\$k} )
                {
                  \%{"\${this}::ALL"} = ( \%{"\${this}::ALL"},
                                          \$k => \$all->{\$k} );
                } 
                
              }
            }
                                    
            my \%obj = \%{"${call}::ALL"};
            \$this = bless \\\%obj, \$this;
            
            sub ${call}::ALL { \\\%{"${call}::ALL"} }
            
            \$this->init(\@_) if $call->can('init');
            
            return \$this;
          }
        
        };
    }

sub addAttr
    {
        my ( $this, $attr, $value ) = @_;
        
        given ( ref $value )
        {
            # methods
            when ( 'CODE' )
            {
                *{$this."::$attr"} = $value;
            }
            
            # properties
            default
            {       
                eval qq {
                
                    \%{"${this}::ALL"} = ( \%{"${this}::ALL"},
                                          $attr => \$value );
                    
                    sub ${this}::$attr : lvalue
                    {
                      my \$this = shift;
                         \$this->{$attr};
                    }
                    
                }
            }
        }
    }

1;

__END__

=head1 EXAMPLE

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
    
    package main;
    use Pony::Object;
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

