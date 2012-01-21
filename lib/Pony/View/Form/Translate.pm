package Pony::View::Form::Translate;
use Pony::Object qw/singleton/;

    has Lexicon => {};
    has lang    => '';
    
    sub init
        {
            my $this = shift;
               $this->lang = shift;
        }
    
    sub t
        {
            my $this = shift;
            my $word = shift;
            my $l    = $this->Lexicon->{lang};
            
            if ( exists $l->{$word} )
            {
                # Translate params.
                my @w = map { exists $l->{$_} ? $l->{$_} : $_ } @_;
                
                # Translate phrase.
                return sprintf $l->{$word}, @w;
            }
            
            return $word;
        }
    
1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut