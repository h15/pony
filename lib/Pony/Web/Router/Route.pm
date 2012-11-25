package Pony::Web::Router::Route;
use Pony::Object;

  protected _name => undef;
  protected _regexp => undef;
  protected _format => undef;
  protected _params => undef;
  protected _default => undef;
  protected _controller => undef;
  protected _action => undef;
  
  # Function: init
  # | Create route.
  # | Example:
  # |   $router->add(user_read => '/(user)/profile/(show)/:id(%d)');
  # Access: Public
  # Parameters:
  #   $url - string, which describes route url
  # Returns:
  #   $this
  
  sub init : Public
    {
      my $this = shift;
      my $url = shift;
      
      for my $part ( split '/', $url )
      {
        given( $part )
        {
          when( /\(.+?\)/ )
        }
      }
      
      
      return $this;
    }

1;
