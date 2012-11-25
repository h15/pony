package Pony::Web::Dispatcher;
use Pony::Object;
  
  use Pony::Web::Response;
  use Module::Load;
  
  protected app => undef;
  protected request => undef;
  protected response => undef;
  
  sub init : Public
    {
      my $this = shift;
         $this->app = shift;
         $this->request = shift;
         $this->response = new Pony::Web::Response;
      
      return $this;
    }
  
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
  
  sub _runRouter : Protected
    {
      my $this = shift;
      my $router = $this->app->getRouter();
      
      return $router->match( $this->request );
    }
  
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
