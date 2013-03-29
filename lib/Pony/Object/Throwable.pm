# Class: Pony::Object::Throwable
#   Simplest Exception class.

package Pony::Object::Throwable;
use Pony::Object;
  
  protected message => '';
  protected package => '';
  protected file    => '';
  protected line    => '';
  
  
  # Function: throw
  #   Say "hello" and raise Exception.
  #
  # Parameters:
  #   message -- some funny message for poor users.
  
  sub throw : Public
    {
      my $this = shift; # pkg || obj
      $this = $this->new unless ref $this;
      $this->message = shift;
      ($this->package, $this->file, $this->line) = @_ || caller;
      
      printf STDERR "\n\"%s\" at %s (%s:%s)\n",
        $this->message, $this->package, $this->file, $this->line;
      
      die $this;
    }

1;
