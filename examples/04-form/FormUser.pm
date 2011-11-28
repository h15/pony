package FormUser;
use Pony::Object 'Pony::View::Form';

    has action => '/user';
    has method => 'post';
    has id     => 'form-user';
    
    sub init
        {
            my $this = shift;
               $this->addElement( mail     => text     => {required => 1} );
               $this->addElement( password => password => {required => 1} );
               $this->addElement( submit   => submit   => {ignore   => 1} );
        }

    1;