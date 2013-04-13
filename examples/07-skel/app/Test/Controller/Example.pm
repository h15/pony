# Class: Test::Controller::Example
#   Example controller.
# Extends:
#   Pony::Web::Controller

package Test::Controller::Example;
use Pony::Object qw/Pony::Web::Controller/;

  use Pony::Web::Response;


  # Method: testTextAction
  #   Example action #1
  # Return: Pony::Web::Response
  
  sub testTextAction : Public
    {
      my $this = shift;
      return Pony::Web::Response->new(
        'Hello from Test::Controller::Example');
    }
  
1;


