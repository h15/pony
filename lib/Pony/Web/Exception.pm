
# Class: Pony::Web::Exception
#   Exception for 404 an other non-200 HTTP responses.

package Pony::Web::Exception;
use Pony::Object 'Pony::Object::Throwable';

  protected code => 500;
  protected message => 'Internal Server Error';
  protected location => '';
  
  
  # Function: throw
  # | Throws exception.
  # | Useage:
  # |   throw Pony::Web::Exception(code => 301, location => 'http://google.com')
  #
  # Parameters:
  #   field_1
  #   value_1
  #     ...
  #   field_N
  #   value_N
  
  sub throw : Public
    {
      my $this = shift; # pkg || obj
      $this = $this->new unless ref $this;
      
      my %params = (ref $_[0]? %{$_[0]} : @_ ); # hashref || array
      $this->$_ = $params{$_} for keys %params;
      ($this->package, $this->file, $this->line) = caller;
      
      die $this;
    }
  
  sub getCode : Public
    {
      my $this = shift;
      return $this->code;
    }
  
  sub getMessage : Public
    {
      my $this = shift;
      return $this->message;
    }

1;