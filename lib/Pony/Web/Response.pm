# Class: Pony::Web::Response
#   Standard response.
# Extends:
#   Pony::Web::AbstractModule

package Pony::Web::Response;
use Pony::Object qw/Pony::Web::AbstractModule/;
  
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
  
  
  # Method: renderTemplate
  #   Render template with data.
  # Parameters:
  #   template - Str
  #   params - HashRef || Hash
  # Return: Pony::Web::Response
  
  sub renderTemplate : Public
    {
      my $this = shift;
      my $template = shift;
      my $params = (ref $_[0] ? $_[0] : {@_});
      $template = sprintf '%s.tx', $template;
      $this->body = $this->getApp()->getRenderer()
                         ->render($template, $params);
      return $this;
    }
  
  
  # Method: setCode
  #   setter for code
  # Parameter: code - Int
  # Return: Pony::Web::Response
  
  sub setCode : Public
    {
      my $this = shift;
      $this->code = shift;
      return $this;
    }
  
  
  # Method: setBody
  #   setter for body
  # Parameter: body - Str
  # Return: Pony::Web::Response
  
  sub setBody : Public
    {
      my $this = shift;
      $this->body = shift;
      
      return $this;
    }
  
  
  # Method: addHeader
  #   add headers to response
  # Parameter: Array
  # Return: Pony::Web::Response
  
  sub addHeader : Public
    {
      my $this = shift;
      push @{ $this->header }, @_;
      return $this;
    }
  
  
  # Method: render
  #   render response
  # Return: ArrayRef - Twiggy::Server response
  
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

