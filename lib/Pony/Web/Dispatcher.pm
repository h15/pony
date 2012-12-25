
# Class: Pony::Web::Dispatcher
# | It solves which route was requested
# | and what action should be runned.

package Pony::Web::Dispatcher;
use Pony::Object;
use Pony::Web::Response;
use Module::Load;
  
  protected app => undef;
  protected request => undef;
  protected response => undef;
  

  # Function: init
  #   Constructor.
  #
  # Access: Public
  #
  # Parameters:
  #   app - application instance.
  #   request - web server request.
  #
  # Returns:
  #   this

  sub init : Public
    {
      my $this = shift;
         $this->app = shift;
         $this->request = shift;
         $this->response = new Pony::Web::Response;
      
      return $this;
    }
  

  # Function: dispatch
  #   Run action for route or routes and return response.
  #
  # Access: Public
  #
  # Returns:
  #   Pony::Web::Response

  sub dispatch : Public
    {
      my $this = shift;
      my $route = $this->_runRouter();
      
      if ( ref($route) eq 'ARRAY' )
      {
        $this->_runAction( $route ) for @$route;
      }
      else
      {
        $this->_runAction( $route );
      }
      
      return $this->response;
    }
  
  
  # Function: _runRouter
  #   Get matched routes.
  #
  # Access: Protect
  #
  # Returns:
  #   Pony::Web::Router:Route || Array Ref

  sub _runRouter : Protected
    {
      my $this = shift;
      my $router = $this->app->getRouter();
      
      return $router->match( $this->request );
    }
  

  # Function: _runAction
  #   Load controller and run action.
  #
  # Access: Protected
  #
  # Parameters:
  #   route

  sub _runAction : Protected
    {
      my $this = shift;
      my $route = shift;
      
      my $controller = $route->getController();
      my $action = $route->getAction();
      
      my $appName = $this->app->stash->get('application');
      my $package = "${appName}::Controller::$controller";
      
      load $package;
      
      $this->response = $package->new($this->app, $this->request)
                                ->$action($this->app, $this->request);
    }
  
1;
