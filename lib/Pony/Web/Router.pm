
# Class: Pony::Web::Router
#   Store routes, find routes for requests.
#
# See Also:
#   <Pony::Web::Router::Route>

package Pony::Web::Router;
use Pony::Object;
use Pony::Web::Router::Route;
use Pony::Web::Exception;

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
      
      for my $line ( $this->_createRouteLinesFromText($_[0]) )
      {
        # $extension is optional parameter
        my ($name, $pattern, $extension, $handler) = split /\s+/, $line;
        
        if (not defined $handler) {
          $handler = $extension;
          ($extension) = $pattern =~ /\.([\w\d]+)$/;
        }
        
        push @{ $this->routes }, Pony::Web::Router::Route->new(
          module => $module,
          name => $name,
          url => $pattern,
          extension => $extension,
          handler => $handler
        );
      }
      
      return $this;
    }
  
  
  # Function: match
  #   Search route by request.
  # Access: Public
  # Parameters:
  #   request - Pony::Web::Request
  # Raise: Pony::Web::Exception 404
  # Return: Pony::Web::Router::Route
  
  sub match : Public
    {
      my $this = shift;
      my $request = shift;
      my $route;
      
      for my $r ( @{ $this->routes } )
      {
        return $route if $route = $r->match($request->getPath());
      }
      
      throw Pony::Web::Exception(code => 404, message => 'Page not found');
    }
  
  
  # Method: _createRouteLinesFromText
  #   Split text by \n, trim lines, remove empty lines.
  # Access: Protected
  # Return: Array of Str
  
  sub _createRouteLinesFromText : Protected
    {
      my $this = shift;
      my $text = shift;
      
      my @lines = split "\n", $text;
      map { s/^\s*(.*?)\s*$/$1/ } @lines;
      @lines = grep { length $_ > 0 } @lines;
      
      return @lines;
    }
  
1;
