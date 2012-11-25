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
  
  sub getCookies : Public
    {
      my $this = shift;
      return $this->cookies;
    }
  
  sub getParams : Public
    {
      my $this = shift;
      return $this->params;
    }

  sub getMethod : Public
    {
      my $this = shift;
      return $this->method;
    }
  
  sub getPath : Public
    {
      my $this = shift;
      return $this->path;
    }

  sub getScheme : Public
    {
      my $this = shift;
      return $this->scheme;
    }
  
  sub getUa : Public
    {
      my $this = shift;
      return $this->ua;
    }

1;

