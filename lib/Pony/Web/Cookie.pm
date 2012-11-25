package Pony::Web::Cookie;
use Pony::Object;

  use MIME::Base64;
  
  protected data => {};
  
  sub init : Public
    {
      my $this = shift;
      
      if ( @_ )
      {
        my $string = shift;
        
        for my $pair ( split ';', $string )
        {
          my ( $k, $v ) = split '=', $pair;
          $this->set( decode_base64($k) => decode_base64($v) );
        }
      }
      
      return $this;
    }

  sub set : Public
    {
      my $this = shift;
      my ( $k, $v ) = @_;
      
      $this->data->{$k} = $v;
      
      return $this;
    }

  sub get : Public
    {
      my $this = shift;
      my $k = shift;
      
      return $this->data->{$k};
    }

  sub getAll : Public
    {
      my $this = shift;
      return $this->data;
    }
  
  sub toString : Public
    {
      my $this = shift;
      my @o_data;
      
      while ( my($k, $v) = each %{$this->data} )
      {
        push @o_data, encode_base64($k) .'='. encode_base64($v);
      }
      
      return join(';', @o_data);
    }

1;
