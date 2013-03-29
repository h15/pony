# Class: Pony::Web::Controller
#   Abstruct controller.
# Extends:
#   Pony::Object

package Pony::Web::Controller;
use Pony::Object -abstract;

  protected app => undef;
  protected request => undef;
  
  
  # Method: init
  # Parameters:
  #   app - Pony::Web
  #   request - Pony::Web::Request
  
  sub init : Public
    {
      my $this = shift;
      ($this->app, $this->request) = @_;
    }
  
1;