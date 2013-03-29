# Class: Pony::Web::Router::Route
#   Routing rule for Pony::Web::Dispatcher

package Pony::Web::Router::Route;
use Pony::Object;

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
  protected extension => undef;
  
  
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
      my $params = {@_};
      ($this->module, $this->name, $this->extension) = @$params{qw/module name extension/};
      my ($url, $handler) = @$params{qw/url handler/};
      
      # '_' means that this route hasn't name.
      $this->name = undef if $this->name eq '_';
      
      my ($urlWithoutExtension) = $url =~ /^(.*?)\.([\w\d]+)$/;
      $url = $urlWithoutExtension if defined $urlWithoutExtension;
      
      # Parse url.
      for my $part (split /\//, $url)
      {
        given( $part )
        {
          when( '' )
          {
            
          }
          when( /^[\w\d_\-]+$/ )
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
      
      # Append extension if it's necessary.
      if (defined $urlWithoutExtension)
      {
        $this->pattern .= '\.' . $this->extension;
        $this->format .= '.' . $this->extension;
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
      
      return $route if ( @{ $route->matches } = $path =~ /^$regex$/ );
      return undef;
    }
  
  
  # Method: getController
  #   Getter for controller
  # Access: public
  # Return: Str
  
  sub getController : Public
    {
      my $this = shift;
      return $this->controller;
    }
  
  
  # Method: getAction
  #   Getter for action
  # Access: public
  # Return: Str
  
  sub getAction : Public
    {
      my $this = shift;
      return $this->action;
    }
  
1;
