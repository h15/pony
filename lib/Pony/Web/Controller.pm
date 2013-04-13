# Class: Pony::Web::Controller
#   Abstruct controller.
# Extends:
#   Pony::Object

package Pony::Web::Controller;
use Pony::Object -abstract;
  
  use Pony::Web::Response;
  
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
  
  
  # Method: render
  #   Render data
  # Parameters:
  #   tpl - Str - template name
  #   data - Array || HashRef - data
  # Return: ArrayRef
  
  sub render : Protected
    {
      my ($this, $tpl, @data) = @_;
      my $res = new Pony::Web::Response;
      return $res->renderTemplate($tpl, @data);
    }
  
1;
