
# Class: App
#   Example application.
#
# Extends:
#   Pony::Web

package App;
use Pony::Object singleton => 'Pony::Web';
  
  # Function: startup
  #   Runs once.
  # 
  # Access: Public

  sub startup : Public
    {
      my $this = shift;
      
      $this->router->add('',
      qw{
        user_read     /user/read/:id(d).html  App::Controller::User->read
        user_profile  /profile/:id(d).html    App::Controller::User->read
        _ /:module(\w)/:controller(\w+)/:action(\w+) _
      });
    }

1;
