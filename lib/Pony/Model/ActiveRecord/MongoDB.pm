
# Class: Pony::Model::ActiveRecord::MongoDB
#   An abstract class for ActiveRecord pattern support.
#
# See Also:
#   - Pony::Model::Dbh::MongoDB
#   - Pony::Model::ActiveRecord::Interface

package Pony::Model::ActiveRecord::MongoDB;
use Pony::Object -abstract, 'Pony::Model::ActiveRecord::Abstract';

  use Pony::Model::Crud::MongoDB;
  use Pony::Model::Dbh::MongoDB;
  
  
  # Function: init
  #   Constructor of AR object.
  #   Generate properties form _storable.
  #
  # Returns:
  #   Object $this
  
  sub init : Public
    {
      my $this = shift;
      public $_ for @{ $this->_storable }; # Generate properties.
      my $tbl = $this->_table;
      $this->_model = Pony::Model::Dbh::MongoDB->new->dbh->$tbl;
      return $this;
    }

1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
