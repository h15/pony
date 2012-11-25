package Spaghetti::Router;
use Pony::Object;

  use Module::Load;
  use Spaghetti::Controller::Error;

  sub dispatch : Public
    {
      my $this = shift;
      my ( $app, $req ) = @_;
      
      # DEBUG info
      say dump $req if $app->stash->get('mod') eq 'DEBUG';
      
      # Get data
      my $url = $req->{env}->{PATH_INFO};
      my $method = $req->{env}->{REQUEST_METHOD};
      
      if ( $url =~ m/^\/\w+$/ )
      {
        my $c = substr $url, 1;
        my $a = $this->_getAction($method);
        
        # Load module.
        my $class = "Spaghetti::Controller::$c";
        eval { load $class };
        
        # Error on miss controller or action.
        return Spaghetti::Controller::Error->new($app, $req)->get(500)
          if $@ || !$class->can($a);
        
        # Log.
        Spaghetti->log("Dispatch: $class->$a");
        
        # Run action.
        return $class->new($app, $req)->$a();
      }
      else
      {
        return Spaghetti::Controller::Error->new($app, $req)->get(401);
      }
    }
  
  sub _getAction : Protected
    {
      my $this = shift;
      my $method = shift;
      
      given( lc $method )
      {
        when ( 'post'   ) { return 'create' }
        when ( 'get'    ) { return 'read'   }
        when ( 'update' ) { return 'update' }
        when ( 'delete' ) { return 'delete' }
      }
    }

1;
