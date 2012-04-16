package Pony::Object;

use feature ':5.10';
use Storable qw/dclone/;
use Module::Load;
use Carp qw(confess);
use Scalar::Util 'blessed';
use Attribute::Handlers;

our $VERSION = '0.001998';

# "You will never find a more wretched hive of scum and villainy.
#  We must be careful."

sub import
    {
        my $this   = shift;
        my $call   = caller;
        my $isa    = "${call}::ISA";
        my $single = 0;
        
        # Load all base classes.
        #
        
        while ( @_ )
        {
            my $param = shift;
            
            if ( $param eq 'singleton' )
            {
                $single = 1;
                next;
            }
            
            load $param;
            
            push @$isa, $param;
        }
        
        # Pony objects must be strict
        # and modern.
        
        strict  ->import;
        warnings->import;
        feature ->import(':5.10');
        
        # Turn on attribute support:
        # public, private, protected.
        
        enableAttributes();
        
        # Define "keywords".
        #
        
        *{$call.'::has'}       = sub { addProperty ($call, @_) };
        *{$call.'::public'}    = sub { addPublic   ($call, @_) };
        *{$call.'::private'}   = sub { addPrivate  ($call, @_) };
        *{$call.'::protected'} = sub { addProtected($call, @_) };
        
        # Define special methods.
        #
        
        *{$call.'::ALL'}    = sub { \%{ $call.'::ALL' } };
        *{$call.'::clone'}  = sub { dclone shift };
        *{$call.'::toHash'} = sub
        {
            my $this = shift;
            my %hash = map { $_, $this->{$_} } keys %{ $this->ALL() };
              \%hash;
        };
        
        *{$call.'::dump'} = sub {
                                    use Data::Dumper;
                                    $Data::Dumper::Indent = 1;
                                    Dumper(@_);
                                };
        
        *{$call.'::new'} = sub
        {
            # For singletons.
            #
            
            return ${$call.'::instance'} if defined ${$call.'::instance'};

            my $this = shift;

            # properties inheritance
            #
            
            for my $base ( @{ $this.'::ISA'} )
            {
                if ( $base->can('ALL') )
                {
                    my $all = $base->ALL;

                    for my $k ( keys %$all )
                    {
                        unless ( exists ${$call.'::ALL'}{$k} )
                        {
                            %{ $this.'::ALL' } = ( %{ $this.'::ALL' },
                                                   $k => $all->{$k} );
                        }
                    }
                }
            }
            
            my $obj = dclone { %{${this}.'::ALL'} };
            $this = bless $obj, $this;
            
            ${$call.'::instance'} = $this if $single;
            
            # 'After' for user.
            
            $this->init(@_) if $call->can('init');
            
            return $this;    
        };
    }

sub addProperty
    {
        my ( $this, $attr, $value ) = @_;
        
        given( $attr )
        {
            when( /^__/ ) { return addPrivate(@_) }
            when( /^_/  ) { return addProtected(@_) }
            default       { return addPublic(@_) }
        }
    }

sub addPublic
    {
        my ( $this, $attr, $value ) = @_;
        
        # Save pair (property name => default value)
        %{ $this.'::ALL' } = ( %{ $this.'::ALL' }, $attr => $value );
        
        *{$this."::$attr"} = sub : lvalue { my $this = shift; $this->{$attr} };
    }

sub addProtected
    {
        my ( $pkg, $attr, $value ) = @_;
        
        # Save pair (property name => default value)
        %{ $pkg.'::ALL' } = ( %{ $pkg.'::ALL' }, $attr => $value );
        
        *{$pkg."::$attr"} = sub : lvalue
        {
            my $this = shift;
            confess "Protected ${pkg}::$attr called" unless caller->isa($pkg);
            $this->{$attr};
        };
    }

sub addPrivate
    {
        my ( $pkg, $attr, $value ) = @_;
        
        # Save pair (property name => default value)
        %{ $pkg.'::ALL' } = ( %{ $pkg.'::ALL' }, $attr => $value );
        
        *{$pkg."::$attr"} = sub : lvalue
        {
            my $this = shift;
            confess "Private ${pkg}::$attr called" unless caller eq $pkg;
            $this->{$attr};
        };
    }

sub enableAttributes
    {
        sub UNIVERSAL::Protected : ATTR(CODE)
            {
                my ( $pkg, $symbol, $ref ) = @_;
                my $method = *{$symbol}{NAME};
                
                *{$symbol} = sub
                {
                    confess "Protected ${pkg}::$method() called" unless caller->isa($pkg);
                    goto &$ref;
                }
            }

        sub UNIVERSAL::Private : ATTR(CODE)
            {
                my ( $pkg, $symbol, $ref ) = @_;
                my $method = *{$symbol}{NAME};
                
                *{$symbol} = sub
                {
                    confess "Private ${pkg}::$method() called" unless caller eq $pkg;
                    goto &$ref;
                }
            }

        sub UNIVERSAL::Public : ATTR(CODE)
            {
                # do nothing
            }
    }

1;

__END__

=head1 NAME

Pony::Object the object system.

=head1 OVERVIEW

Pony::Object is an object system, which provides simple way to use cute objects.

=head1 SYNOPSIS

    use Pony::Object;

=head1 DESCRIPTION

When some package using Pony::Object, it's becoming strict (and shows warnings)
and modern (can use perl 5.10 features like as C<say>). Also C<dump> function
is using now as Data::Dumper. It's useful on debugging.

=head2 Specific moments

Besides new function C<dump> Pony::Object has other specific moments.

=head3 has

Keyword C<has> says Pony::Object about new object fields.
All fields are public. You can also describe object methods via C<has>...
If you want.

    package News;
    use Pony::Object;
    
        # Fields
        has 'title';
        has text => '';
        has authors => [ qw/Alice Bob/ ];
        
        # Methods
        has printTitle => sub
            {
                my $this = shift;
                say $this->title;
            }

        sub printAuthors
            {
                my $this = shift;
                print @{ $this->authors };
            }
    1;

    package main;
    use News;
    
    my $news = new News;
    $news->printAuthors();
    $news->title = 'Something important';
    $news->printTitle();

Pony::Object fields are changing via "=". For example: $obj->field = 'a'.

=head3 new

Pony::Object hasn't method C<new>. In fact, of course it has. But C<new> is an
internal function, so you should not use it if you want not have additional fun.
Instead of this Pony::Object has C<init> function, where you can write the same,
what you wanna write in C<new>. C<init> is after-hook for C<new>.

    package News;
    use Pony::Object;
    
        has title => undef;
        has lower => undef;
        
        sub init
            {
                my $this = shift;
                $this->title = shift;
                $this->lower = lc $this->title;
            }
    1;

    package main;
    use News;
    
    my $news = new News('Big Event!');
    
    print $news->lower;

=head3 ALL

If you wanna get all default values of Pony::Object-based class
(fields, of course), you can call C<ALL> method. I don't know why you need them,
but you can do it.

    package News;
    use Pony::Object;
    
        has 'title';
        has text => '';
        has authors => [ qw/Alice Bob/ ];
        
    1;

    package main;
    use News;
    
    my $news = new News;
    
    print for keys %{ $news->ALL() };

=head3 Inheritance

To define base classes you should set them as params on Pony::Object use.
For example, use Pony::Object 'Base::Class';

    package FirstPonyClass;
    use Pony::Object;
    
        # properties
        has a => 'a';
        has d => 'd';
        
        # method
        has b => sub
            {
                my $this = shift;
                   $this->a = 'b';
                   
                return ( @_ ?
                            shift:
                            'b'  );
            };
        
        # traditional perl method
        sub c { 'c' }
    
    1;

    package SecondPonyClass;
    # extends FirstPonyClass
    use Pony::Object qw/FirstPonyClass/;
    
        # Redefine property.
        has d => 'dd';
        
        # Redefine method.
        has b => sub
            {
                my $this = shift;
                   $this->a = 'bb';
                   
                return ( @_ ?
                            shift:
                            'bb'  );
            };
        
        # New method.
        has e => sub {'e'};
    
    1;

=head3 Singletons

For singletons Pony::Object has simplpe definition. You just should declare that
on use Pony::Object;

    package Notes;
    use Pony::Object 'singleton';
    
        has list => [];
        
        sub add
            {
                my $this = shift;
                push @{ $this->list }, @_;
            }
        
        sub flush
            {
                my $this = shift;
                $this->list = [];
            }
    
    1;

    package main;
    use Notes;
    
    my $n1 = new Notes;
    my $n2 = new Notes;
    
    $n1->add( qw/eat sleep/ );
    $n1->add( 'Meet with Mary at 8 o`clock' );
    
    $n2->flush;
    
    # Em... When I must meet Mary? 

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 - 2012, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
