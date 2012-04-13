package Object::ProtectedPony;
use Pony::Object;

    has _a => 'a';
    has  b => 'b';
    has _c => undef;
    
    sub getA
        {
            return shift->_getA();
        }
    
    sub setA
        {
            my $this = shift;
            $this->_a = shift;
        }
    
    has _getA => sub
        {
            return shift->_a;
        };

1;

