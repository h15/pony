package Pony::View::Form::Element::Submit;
use Pony::Object qw/Pony::View::Form::Element/;

    has valueForm =>
        q/<input class="pony-submit" type=submit id="%s" name="%s">/;
    
    sub render
        {
            my $this = shift;
            my $formId = shift;
            
            sprintf $this->valueForm, "$formId-".$this->id, $this->name;
        }

1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
