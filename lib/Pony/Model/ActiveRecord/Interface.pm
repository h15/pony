
# Class: Pony::Model::ActiveRecord::Interface
#   Interface for all AR classes.

package Pony::Model::ActiveRecord::Interface;
use Pony::Object -abstract;


  # Function: init
  #   Constructor of AR object. Generate properties form _storable.
  #
  # Returns:
  #   Object $this
  
  sub init : Abstract {};
  
  
  # Function: load
  #   Load from DB one object or set (if want array).
  #
  # Parameters:
  #   where - hash or int - search db record condition.
  #   offset - int.
  #   limit - int.
  #
  # Returns:
  #   Object $this || Array.
  
  sub load : Abstract {};
  
  
  # Function: save
  #   Save current state into db.
  #
  # Returns:
  #   Object $this
  
  sub save : Abstract {};
  
  
  # Function: setId
  #   Id setter.
  #
  # Parameters:
  #   id - scalar.
  #
  # Returns:
  #   Object $this
  
  sub setId : Abstract {};
  
  
  # Function: getId
  #   Id getter.
  #
  # Returns:
  #   scalar || undef.
  
  sub getId : Abstract {};
  
  
  # Function: getStorable
  #   Get data from object (only storable fields).
  #
  # Returns:
  #   HashRef.
  
  sub getStorable : Abstract {};
  
  
  # Function: setStorable
  #   Set data to storable fields.
  #
  # Parameters:
  #   i_data - HashRef
  #
  # Returns:
  #   Object $this
  
  sub setStorable : Abstract {};
  
  
  # Function: set
  #   Set some key pairs of object.
  #
  # Parameters:
  #   i_data - HashRef
  #
  # Returns:
  #   Object $this
  
  sub set : Abstract {};

1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
