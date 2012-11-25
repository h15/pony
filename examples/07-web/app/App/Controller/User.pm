package Spaghetti::Controller::User;
use Pony::Object;

  sub init : Public
    {
      my $this = shift;
      my ($app, $req) = @_;
    }

  sub read : Public
    {
      my $this = shift;
      
      return "hello";
    }

1;