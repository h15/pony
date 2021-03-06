# Class: Pony::Stash
#   Uses to store config.

package Pony::Stash;
use Pony::Object 'singleton';

  # "R2D2 where are you?"
  
  use Pony::Object::Throwable;
  use Storable qw(freeze thaw);
  use YAML::Tiny;
  
  our $VERSION = 0.03;
  
  protected conf => {};
  protected file => '';
  protected type => '';
  
  
  # Function: init
  # | Read file and init config by data from file.
  # | It can be stored by Storable::freeze or in yaml.
  #
  # Parameters:
  #   file - path to config file.
  #
  # Raises:
  #   Pony::Object::Throwable - if file does not readable || writable || some other error.
  
  sub init : Public
    {
      my $this = shift;
         $this->file = shift;
      
      throw Pony::Object::Throwable('Can\'t read ' .$this->file) unless -r $this->file;
      throw Pony::Object::Throwable('Can\'t write '.$this->file) unless -w $this->file;
      
      ( $this->type ) = ( $this->file =~ /\.([\w]+)$/ );
      $this->type = lc $this->type;
      
      given( $this->type )
      {
        # Runs if stash format is 'yaml' or 'yml'.
        # See http://en.wikipedia.org/wiki/YAML for more information.
        when( /^ya?ml$/ )
        {
          my $yaml = YAML::Tiny->read( $this->file )
            or throw Pony::Object::Throwable('Can\'t read '.$this->file);
          $this->conf = $yaml->[0] || {};
        }
        # Runs if stash format is 'dat'.
        # 'dat' is a simple data dump.
        when( 'dat' )
        {
          open F, $this->file or
            throw Pony::Object::Throwable('Can\'t read '.$this->file);
          {
            local $/;
            
            my $conf = <F>;
            
            $this->conf = ( length $conf ? thaw $conf : {} );
          }
          close F;
        }
        # Runs on unknown format.
        #
        default
        {
          throw Pony::Object::Throwable
            ('Unknown config type "'. $this->type .'"')
        }
      }
    }
  
  
  # Method: save
  # | Store config into config file.
  # |
  # | " - What's going on... Buddy? 
  # |   - You're being put into carbon-freeze. "
  
  sub save : Public
    {
      my $this = shift->new;
      
      given( $this->type )
      {
        when( /ya?ml/ )
        {
          my $yaml = new YAML::Tiny;
          $yaml->[0] = $this->conf;
          $yaml->write( $this->file );
        }
        when( 'dat' )
        {
          open  F, '>', $this->file
            or throw Pony::Object::Throwable('Can\'t write into '.$this->file);
          print F freeze($this->conf);
          close F;
        }
      }
    }
  
  
  # Method: findOrCreate
  # | Find config and return.
  # | Create config if not found ... and return result.
  # Return: HashRef || Str
  
  sub findOrCreate : Public
    {
      my $this = shift->new;
      my ($name, $conf ) = @_;
      
      $this->set($name => $conf) unless exists $this->conf->{$name};
      
      return $this->get($name);
    }
  
  
  # Method: get
  # | Find config by name and return.
  # | Return undef, if can't find.
  # Parameters:
  #   name - param's name
  # Return: HashRef || Str || undef
  
  sub get : Public
    {
      my $this = shift->new;
      my ( $name ) = @_;
      
      return $this->conf->{$name} if exists $this->conf->{$name};
      return undef;
    }
  
  
  # Method: set
  # | Create or update stash hash
  # | into $this->conf.
  # Parameters:
  #   name - key
  #   conf - value
  
  sub set : Public
    {
      my $this = shift->new;
      my ( $name, $conf ) = @_;
      
      $this->conf->{$name} = $conf;
    }
  
  
  # Method: delete
  #   Delete element from stash hash.
  # Parameters:
  #   name
  
  sub delete : Public
    {
      my $this = shift->new;
      my ( $name ) = @_;
      
      delete $this->conf->{$name};
    }
  
  
  # Method: getFileName
  #   Getter for *file*
  # Return: Str
  
  sub getFileName : Public
    {
      my $this = shift->new;
      return $this->file;
    }
  
1;

__END__

=head1 NAME

Pony::Stash the storage.

=head1 OVERVIEW

Pony::Stash is an application storage. It can be saved into file.

=head1 SYNOPSIS

  use Pony::Stash;
  
  my $conf = new Pony::Stash('./config.dat');
     $conf->set( user => { dbTable => 'user',
               default => 'anonymous' } );
  
  # Get existing config or create new
  my $userConfig = $conf->findOrCreate( user => { dbTable => 'Users',
                          default => 'guest' } );
  say $userConfig->{default}; # returns 'anonymous'

=head1 DESCRIPTION

You can use Pony::Stash if you wanna to have registry in your application.
It's a singleton, so you will have the same 'stash' in all application packages.

=head2 Initialization

First of all you should initiate stash.

  Pony::Stash->new('./config.dat');
  
  # or
  my $conf = Pony::Stash->new('./config.dat');
  # if you want to use $conf instead of Pony::Stash

If file './config.dat' does not exist - Pony::Stash writes warninig.

=head2 Methods

=over

=item set

First param is a name config or stash's cell (or what you store in the stash).
Second param is a data, which will saved there.

  Pony::Stash->new('./config.dat');
  Pony::Stash->set( secret => 'There is no spoon!' );
  
  # or
  my $conf = Pony::Stash->new('./config.dat');
  $conf->set( secret => 'There is no spoon!' );

=item get

Get data by key.

  say Pony::Stash->get('secret');

Returns undef if key does not exist.

=item findOrCreate

Get data by key. If key does not exist - create it and initiate with data from 
second param and return data.

  Pony::Stash->findOrCreate( secret => 'There is no spoon!' );
  my $secret = Pony::Stash->findOrCreate( secret => 'There is no spoon?' );
  
  say $secret;
  # There is no spoon!

=item delete

Delete pair from stash by key.

  Pony::Stash->set( secret => 'There is no spoon!' );
  Pony::Stash->delete('secret');
  
  say 'Does not exist!' unless Pony::Stash->get('secret');
  # Does not exist!

=item save

Save all changes into file. Raise warning if file is not writable.

  Pony::Stash->save();

=back

=head2 Tips & Tricks

If you need to use two or more stashes, you can initiate it many times.

  use Pony::Stash;
  
  # First stash.
  my $conf = new Pony::Stash('./config.dat');
     $conf->set( user => { dbTable => 'user',
               default => 'anonymous' } );
  
  $conf->save;
  
  # Second stash.
  Pony::Stash->new->init('./config2.dat');
  # $conf changed!
  my $userConf = $conf->get('user');

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 - 2012, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut

