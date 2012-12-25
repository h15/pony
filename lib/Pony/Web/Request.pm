
# Class: Pony::Web::Request
#   Wrapper for different request formats.
#
# See Also:
#   <Pony::Web::Cookie>
#   <Pony::Web::Param>

package Pony::Web::Request;
use Pony::Object;
use Pony::Web::Cookie;
use Pony::Web::Param;

  protected cookies => undef;
  protected params  => undef;
  protected method  => undef;
  protected path    => undef;
  protected scheme  => undef;
  protected ua      => undef;
  
  
  # Function:init
  #   Constructor.
  #
  # Access: Public
  #
  # Parameters:
  #   req - some request format
  #
  # Return: this
  
  sub init : Public
    {
      my $this = shift;
      my $req = shift;
      
      $this->cookies= Pony::Web::Cookie->new($req->{HTTP_COOKIE}) if exists $req->{HTTP_COOKIE};
      $this->params = Pony::Web::Param->new($req->{QUERY_STRING}) if exists $req->{QUERY_STRING};
      $this->method = $req->{REQUEST_METHOD};
      $this->path   = $req->{PATH_INFO};
      $this->scheme = $req->{'psgi.url_scheme'};
      $this->ua     = $req->{HTTP_USER_AGENT};
      
      return $this;
    }
  
  
  # Function: getCookies
  #   cookies' getter
  #
  # Return: Pony::Web::Cookie
  
  sub getCookies : Public
    {
      my $this = shift;
      return $this->cookies;
    }
  
  
  # Function: getParams
  #   params' getter
  #
  # Return: Pony::Web::Param
  
  sub getParams : Public
    {
      my $this = shift;
      return $this->params;
    }
  
  
  # Function: getMethod
  #   method getter
  #
  # Return: String
  
  sub getMethod : Public
    {
      my $this = shift;
      return $this->method;
    }
  
  
  # Function: getPath
  #   path getter
  #
  # Return: String
  
  sub getPath : Public
    {
      my $this = shift;
      return $this->path;
    }
  
  
  # Function: getScheme
  #   scheme getter
  #
  # Return: String
  
  sub getScheme : Public
    {
      my $this = shift;
      return $this->scheme;
    }
  
  
  # Function: getUa
  #   user-agent getter
  #
  # Return: String
  
  sub getUa : Public
    {
      my $this = shift;
      return $this->ua;
    }

1;