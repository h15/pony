
# Class: Pony::Model::ActiveRecord::Interface
#   Interface for all AR classes.

package Pony::Model::ActiveRecord::Interface;
use Pony::Object -abstract;


  # Function: init
  #   Constructor of AR object. Generate properties form _storable.
  # Returns:
  #   Object $this
  
  sub init : Abstract;
  
  
  # Function: load
  #   Load from DB one object or set (if want array).
  # Parameters:
  #   where - hash or int - search db record condition.
  #   offset - int.
  #   limit - int.
  # Returns:
  #   Nothing or Array.
  
  sub load : Abstract;
  
  
  # Function: save
  #   Save current state into db.
  
  sub save : Abstract;
  
  
  # Function: setId
  #   Id setter.
  # Parameters:
  #   id - scalar.
  
  sub setId : Abstract;
  
  
  # Function: getId
  #   Id getter.
  # Returns:
  #   scalar or undef.
  
  sub getId : Abstract;
  
  
  # Function: getStorable
  #   Get data from object (only storable fields).
  # Returns:
  #   HashRef.
  
  sub getStorable : Abstract;
  
  
  # Function: setStorable
  #   Set data to storable fields.
  # Parameters:
  #   i_data - HashRef
  
  sub setStorable : Abstract;
  
  
  # Function: set
  #   Set some key pairs of object.
  # Parameters:
  #   i_data - HashRef
  # Returns:
  #   Object $this
  
  sub set : Abstract;

1;
