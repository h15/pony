package Pony::View::Form::Element;
use Pony::Object;
    
    has id       => '';
    has name     => '';
    has label    => '';
    has value    => '';
    has required =>  0;
    has ignore   =>  0;
    has errors   => [];
    
    sub render
        {
            return sprintf '<div class="error">%s</div>',
                           'Render is not defined!'
        }
    
    sub isValid
        {
        
        }

1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
