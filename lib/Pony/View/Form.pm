package Pony::View::Form;
use Pony::Object;

    # " - Boy, it's lucky you have these compartments.
    #   - I use them for smuggling.
    #     I never thought I'd be smuggling myself in them.
    #     This is ridiculous. "
    
    # Some html form's properties.
    has action   => '';
    has method   => '';
    has attrs    => {};
    
    # Internal storeges.
    has elements => {};
    has errors   => {};
    
    sub getValue
        {
        
        }
    
    sub isValid
        {
        
        }
    
    sub render
        {
        
        }
    
1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
