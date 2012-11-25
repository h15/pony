
# " – What a piece of junk!
#   – She'll make point five past lightspeed.
#     She may not look like much, but she's got it where it counts, kid.
#     I've made a lot of special modifications myself. "

package Pony::Web;
use Pony::Object -singleton;
  
  use Plack::Request;
  use Module::Load;
  
  use Pony::Web::Request;
  use Pony::Web::Response;
  use Pony::Web::Dispatcher;
  use Pony::Stash;

  public stash => undef;
  public app => undef;
  
  sub init : Public
    {
      my $this = shift;
         $this->stash = new Pony::Stash('./conf/application.yaml');
      
      my $app = Pony::Stash->get('application');
      
      load $app;
      
      $this->app = $app->new;
      
      return $this;
    }
  
  sub clop : Public
    {
      my $this = shift;
      my $env = shift;
         $env = new Plack::Request($env);
      
      my $request     = new Pony::Web::Request($env);
      my $dispatcher  = new Pony::Web::Dispatcher;
      
      my $response = $dispatcher->dispatch($this->app, $request);
      
      return $response->render();
    }

1;

