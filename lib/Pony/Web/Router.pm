
# Class: Pony::Web::Router
#   Store routes, find routes for requests.
#
# See Also:
#   <Pony::Web::Router::Route>

package Pony::Web::Router;
use Pony::Object;
use Pony::Web::Router::Route;
use Pony::Object::Throwable;

  protected routes => [];
  
  
  # Function: add
  # | Add route or routes.
  # | Format: module, name1, url1, handler1, ..., nameN, urlN, handlerN.
  # |
  # | Example:
  # |   $this->router->add('',
  # |   qw{
  # |     user_read     /user/read/:id(d).html  App::Controller::User->read
  # |     user_profile  /profile/:id(d).html    App::Controller::User::read
  # |     _ /:module(\w)/:controller(\w+)/:action(\w+) _
  # |   });
  #
  # Access: Public
  #
  # Parameters:
  #   module - Module name (namespace prefix for controllers)
  #   name1 - name of first route
  #   url1 - url scheme of first route
  #   handler1 - handler for user request which looks like url in first route
  #   ...
  #   nameN - name of Nth route
  #   urlN - url scheme of Nth route
  #   handlerN - handler for user request which looks like url in Nth route
  #
  # Return: this
  
  sub add : Public
    {
      my $this = shift;
      my $module = shift;
      
      for( my $i = 0; $i < $#_; $i += 3 )
      {
        push @{ $this->routes },
          Pony::Web::Router::Route->new($module, @_[$i..$i+2]);
      }
      
      return $this;
    }
  
  
  # Function: match
  #   Search route by request.
  #
  # Access: Public
  #
  # Parameters:
  #   request - Pony::Web::Request
  #
  # Raise: 404
  #
  # Return: Pony::Web::Router::Route
  
  sub match : Public
    {
      my $this = shift;
      my $request = shift;
      
      for my $r ( @{ $this->routes } )
      {
        return $r->clone() if $r->match($request->getPath());
      }
      
      throw Pony::Object::Throwable("404");
    }

1;
