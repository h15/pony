package Object::FirstPonyClass;
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
