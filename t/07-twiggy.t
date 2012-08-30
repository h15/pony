#!/usr/bin/env perl

use Test::More tests => 10;
use Twiggy::Server;

use lib './lib';
use lib '../lib';
use_ok 'Pony::Object';
use_ok 'Pony::Application';

    my $host = '127.0.0.1';
    my $port = '3001';
    
    my $app = new Pony::Application;
    my $server = new Twiggy::Server(host => $host, port => $port);
       $server->register_service( sub{ $app->clop(@_) } );

    AE::cv->recv;
