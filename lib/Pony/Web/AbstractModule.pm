# Class: Pony::Web::AbstractModule
#   Provides useful methods for Pony::Web classes.

package Pony::Web::AbstractModule;
use Pony::Object -abstract;
  
  protected app => undef;
  
  use Pony::Stash;
  
  # Method: getApp
  #   Get application class.
  # Return: Pony::Web implementation
  
  sub getApp : Protected
    {
      my $this = shift;
      my $appName = Pony::Stash->get('application');
      $appName = Pony::Stash->new('./conf/application.yaml')
                            ->get('application') unless $appName;
      unless ($this->app)
      {
        no strict 'refs';
        $this->app = ${$appName.'::instance'};
        use strict 'refs';
      }
      return $this->app;
    }

1;
