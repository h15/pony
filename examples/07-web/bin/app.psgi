#!/usr/bin/perl

use lib "./lib";
use lib "./app";
# Special C<use> for example.
use lib "../../lib";
# end

use File::Basename 'dirname';
use File::Spec;
use Module::Load;
use Twiggy::Server;
use Pony::Stash;

  Pony::Stash->new("./conf/application.yaml");
  
  my $host = Pony::Stash->get('host');
  my $port = Pony::Stash->get('port');
  my $path = join('/', File::Spec->splitdir(dirname(__FILE__)), '..');
  my $appName = Pony::Stash->get('application');
  
  load $appName;
  
  my $app = $appName->new( host => $host, port => $port, path => $path );
  my $server = Twiggy::Server->new( host => $host, port => $port );
     $server->register_service( sub{ $app->clop(@_) } );
  
  AE::cv->recv;
