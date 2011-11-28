package Pony::View::Form;
use Pony::Object;

    # " - Boy, it's lucky you have these compartments.
    #   - I use them for smuggling.
    #     I never thought I'd be smuggling myself in them.
    #     This is ridiculous. "
    
    # Some html form's properties.
    has action => '';
    has method => '';
    has id     => '';
    has attrs  => {};
    
    # Internal storeges.
    has elements => {};
    has errors   => {};
    has data     => {};
    
    sub getValue
        {
        
        }
    
    # Check values of all elements.
    # Return 1 or 0 and if some error happies
    # - it will be added to errors property.
    
    sub isValid
        {
            my $this = shift;
            
            for my $k ( keys %{ $this->elements } )
            {
                my $e = $this->elements->{$k};
                
                next if $e->{ignore};
                
                # Does exist required element?
                if (! exists $this->data->{$k} && $e->{required} )
                {
                    push @{ $this->errors->{$k} }, 'required';
                }
                
                my $d = $this->data->{$k};
                
                # Harvest element's errors.
                unless ( $e->isValid($d) )
                {
                    push @{ $this->errors->{$k} }, $e->errors;
                }
            }
            
            return 0 if keys %{ $this->errors };
            return 1;
        }
    
    sub render
        {
        
        }
    
    sub addElement
        {
            my ( $this, $name, $type, $options ) = @_;
            my $package = 'Pony::View::Form::Element::' . ucfirst $type;
            
            eval 'use $package';
            
            $this->elements->{$name} = $package->new($name, $options);
        }
    
1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
