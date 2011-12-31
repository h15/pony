package Object::SecondPonyClass;
# extends FirstPonyClass
use Pony::Object qw/Object::FirstPonyClass/;

    # test polymorphism
    has d => 'dd';

    has b => sub
        {
            my $this = shift;
               $this->a = 'bb';
               
            return ( @_ ?
                        shift:
                        'bb'  );
        };
    
    # new 01_object::method
    has e => sub {'e'};

1;
