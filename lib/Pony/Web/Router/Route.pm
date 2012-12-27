
# Class: Pony::Web::Router::Route
#   Routing rule for Pony::Web::Dispatcher

package Pony::Web::Router::Route;
use Pony::Object;
use Pony::Object::Throwable;

  protected name => undef;
  protected pattern => undef;
  protected format => undef;
  protected checkFormat => {};
  protected params => [];
  protected matches => [];
  protected default => undef;
  protected module => undef;
  protected controller => undef;
  protected action => undef;
  
  # Function: init
  # | Create route.
  # | Example:
  # |   $this->router->add('',
  # |   qw{
  # |     user_read     /user/read/:id(d).html  App::Controller::User->read
  # |     user_profile  /profile/:id(d).html    App::Controller::User->read
  # |     _ /:module(\w)/:controller(\w+)/:action(\w+) _
  # |   });
  #
  # Access: Public
  #
  # Parameters:
  #   module - module Namespace
  #   name - name of this route
  #   url - string, which describes route url
  #   handler - which handler should handles this request
  #
  # Returns:
  #   this
  
  sub init : Public
    {
      my $this = shift;
         $this->module = shift || 'default';
         $this->name = shift;
      my $url = shift;
      my $handler = shift;
      
      # '_' means that this route hasn't name.
      $this->name = undef if $this->name eq '_';
      
      # Parse url.
      for my $part ( split /[\/.]/, $url )
      {
        given( $part )
        {
          when( /^[\w\d_\-]$/ )
          {
            # Just url part.
            $this->pattern .= "\/$part";
            $this->format .= "/$part";
          }
          when( /^\(.+?\)$/ )
          {
            # Skip in url-matching.
          }
          when( /^:(.+?)\((.+?)\)$/ )
          {
            # Param with it's format.
            push @{ $this->params }, $1;
            $this->pattern .= "\/($2)";
            $this->format .= "/%s";
            $this->checkFormat = { %{ $this->checkFormat }, $1 => $2 };
          }
          default
          {
            throw Pony::Object::Throwable("Can't parse $part in route url.");
          }
        }
      }
      
      # Parse handler.
      if ( $handler =~ /->/ )
      {
        # Call handler as action of controller.
        ($this->controller, $this->action) = split '->', $handler;
      }
      else
      {
        # Call handler as function.
        $this->action = $handler;
      }
      
      return $this;
    }
  
  # Function: match
  #   Check route and get params.
  #
  # Access: Public
  #
  # Parameters:
  #   path - requested path
  #
  # Return: clone of $this || undef
  
  sub match : Public
    {
      my $this  = shift;
      my $path  = shift;
      my $regex = $this->pattern;
      my $route = $this->clone();
      
      return $route if ( @{ $route->matches } = $path =~ /^\/$regex$/ );
      return undef;
    }

1;
