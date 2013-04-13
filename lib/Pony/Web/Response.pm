# Class: Pony::Web::Response
#   Standard response.

package Pony::Web::Response;
use Pony::Object qw/Pony::Web::AbstractModule/;
  
  protected app    => undef;
  protected code   => 200;
  protected header => [];
  protected body   => '';
  
  
  # Method: init
  #   Constructor.
  # Parameter: undef || Str || HashRef || Array
  sub init : Public
    {
      my $this = shift;
      
      if (@_) {
        if (@_ == 1 && !ref $_[0]) { # Str
          $this->body = shift;
        }
        else { 
          my %params = (ref $_[0] ? %{ $_[0] } : @_ ); # HashRef || Array
          $this->body   = $params{'body'}   if exists $params{'body'};
          $this->code   = $params{'code'}   if exists $params{'code'};
          $this->header = $params{'header'} if exists $params{'header'};
        }
      }
      
      return $this;
    }
  
  sub renderTemplate : Public
    {
      my $this = shift;
      my $template = shift;
      my $params = (ref $_[0] ? $_[0] : {@_});
      $template = sprintf '%s/%s.tx', $this->getApp()->templatePath, $template;
      $this->body = $this->getApp()->renderer->render($template, $params);
      return $this->render();
    }
  
  sub setCode : Public
    {
      my $this = shift;
      $this->code = shift;
      
      return $this;
    }
  
  sub setBody : Public
    {
      my $this = shift;
      $this->body = shift;
      
      return $this;
    }
  
  sub addHeader : Public
    {
      my $this = shift;
      push @{ $this->header }, @_;
      
      return $this;
    }
  
  sub render : Public
    {
      my $this = shift;
      
      return [
              $this->code,
              $this->header,
              [ $this->body ]
             ];
    }
  
1;
