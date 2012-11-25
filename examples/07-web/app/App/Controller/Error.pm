package Spaghetti::Controller::Error;
use Pony::Object;

  sub init : Public
    {
      
    }
  
  sub get : Public
    {
      my $this = shift;
      my ($code) = @_;
      
      Spaghetti->log("Error");
      
      return [int $code, [], ['{"error": 1}']];
    }

1;