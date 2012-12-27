
# Class: Pony::Model::ActiveRecord::MySQL
#   An abstract class for ActiveRecord pattern support.
#
# See Also:
#   - Pony::Model::Crud::MySQL
#   - Pony::Model::ActiveRecord::Interface

package Pony::Model::ActiveRecord::MySQL;
use Pony::Object -abstract, 'Pony::Model::ActiveRecord::Abstract';

  use Pony::Model::Crud::MySQL;
  
  
  # Function: init
  #   Constructor of user object.
  #   Generate properties form _storable.
  #
  # Returns:
  #   Object $this
  
  sub init : Public
    {
      my $this = shift;
      public $_ for @{ $this->_storable }; # Generate properties.
      $this->_model = Pony::Model::Crud::MySQL->new( $this->_table );
      return $this;
    }

1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
