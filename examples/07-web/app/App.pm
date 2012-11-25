
# Class: App
#   Application singleton.
# Extends:
#   Pony::Application

package App;
use Pony::Object singleton => 'Pony::Web';

  use App::Router;
  use Pony::Stash;
  
  public host => undef;
  public port => undef;
  public path => undef;
  public router => undef;
  public stash => undef;
  
  sub init : Public
    {
      my $this = shift;
      my %param = @_;
      
      ( $this->host, $this->port, $this->path ) = @param{qw/host port path/};
      
      $this->stash = new Pony::Stash;
      $this->router = new App::Router;
      $this->log('Server started');
    }
  
  sub log : Public
    {
      my $this = shift;
      my $text = shift;
      
      printf "[%d %s] %s\n", App->new->counter,
                             scalar localtime(), $text;
    }

1;
