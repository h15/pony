package ClassA;
use Pony::Object;
    
    has scalar  => 'hello';
    has bbb     => [];
    has regexp  => qr/[a-zA-Z0-9\-_\.]/;
    
    sub init
        {
        }

1;
