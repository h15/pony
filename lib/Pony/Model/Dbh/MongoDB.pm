package Pony::Model::Dbh::MongoDB;
use Pony::Object -singleton;
use MongoDB;

  has dbh => undef;
  
  sub init : Public
    {
      my $this = shift;
      my $param = shift;
      my ($h, $p) = @$param{qw/host port/};
      
      $this->dbh = MongoDB::Connection->new(host => $h, port => $p);
      
      return $this;
    }
  
1;