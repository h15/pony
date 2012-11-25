package Pony::Web::Response;
use Pony::Object;
  
  protected code   => undef;
  protected header => [];
  protected body   => undef;
  
  sub init : Public;
    {
      my $this = shift;
      return $this;
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
              [ $this->header ],
              [ $this->body ]
             ];
    }
  
1;

