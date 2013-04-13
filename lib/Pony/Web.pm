
# " – What a piece of junk!
#   – She'll make point five past lightspeed.
#     She may not look like much, but she's got it where it counts, kid.
#     I've made a lot of special modifications myself. "

# Class: Pony::Web
#   An abstract class for Web applications.

package Pony::Web;
use Pony::Object -abstract;
  
  use Plack::Request;
  use Module::Load;
  use Text::Xslate;
  
  use Pony::Web::Request;
  use Pony::Web::Response;
  use Pony::Web::Dispatcher;
  use Pony::Web::Router;
  use Pony::Stash;
  
  public stash => undef;
  protected router => undef;
  protected renderer => undef;
  protected path => {};
  
  
  # Method: init
  #   Init application (read config).
  # Access: public
  # Return: Pony::Web
  
  sub init : Public
    {
      my $this = shift;
         $this->stash = new Pony::Stash('./conf/application.yaml');
         $this->router = new Pony::Web::Router;
         $this->path = $this->stash->get('path');
         $this->renderer = Text::Xslate->new(
            path => $this->getTemplatePath(),
            cache_dir => $this->getCachePath(),
         );
         
      # User's init
      $this->startup();
      
      return $this;
    }
  
  
  # Method: clop
  #   clop-clop-clop
  # Access: public
  # Return: Array
  
  sub clop : Public
    {
      my $this = shift;
      my $env = shift;
         $env = new Plack::Request($env);
      
      my $request    = new Pony::Web::Request($env->{env});
      my $dispatcher = new Pony::Web::Dispatcher($this, $request);
      
      my $response;
      
      try {
        $response = $dispatcher->dispatch();
      }
      catch {
        # TODO: log errors instead print to STDOUT
        # TODO: create default error handler
        my $e = shift;
        if ($e->isa('Pony::Web::Exception')) {
          say $e->dump();
        
          $response = Pony::Web::Response->new(
            code => $e->getCode(), body => '<pre>'.$e->dump().'</pre>'
          );
        }
        else {
          say $e;
        }
      };
      
      return $response->render();
    }
  
  
  # Method: getRouter
  # Access: public
  # Return: Pony::Web::Router
  
  sub getRouter : Public
    {
      my $this = shift;
      return $this->router;
    }
  
  
  # Method: getTemplatePath
  #   path->{template} getter
  # Return: Str
  
  sub getTemplatePath : Public
    {
      my $this = shift;
      return $this->path->{template};
    }
  
  
  # Method: getCachePath
  #   path->{cache} getter
  # Return: Str
  
  sub getCachePath : Public
    {
      my $this = shift;
      return $this->path->{cache};
    }
  
  
  # Method: getRenderer
  #   getter for renderer
  # Return: Text::Xslate
  
  sub getRenderer : Public
    {
      my $this = shift;
      return $this->renderer;
    }

1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 - 2013, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
