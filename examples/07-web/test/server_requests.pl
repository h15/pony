#!/usr/bin/perl

use LWP::UserAgent;
use HTTP::Request;
use Benchmark;

my $ua = new LWP::UserAgent;
   $ua->agent("Test");

{
  my $req = HTTP::Request->new(GET => 'http://127.0.0.1:1337/user');
     $req->content_type('text/html');
  
  my $res;
  my $t1  = new Benchmark;
  $res = $ua->request( $req ) for 0 .. 1_000;
  my $t2  = new Benchmark;
  
  my $time = timediff($t2, $t1);
  
  printf "Error request:\t\t%s\n", timestr($time);
}

{
  my $req = HTTP::Request->new(GET => 'http://127.0.0.1:1337/User');
     $req->content_type('text/html');
  
  my $res;
  my $t1  = new Benchmark;
  $res = $ua->request( $req ) for 0 .. 1_000;
  my $t2  = new Benchmark;
  
  my $time = timediff($t2, $t1);
  
  printf "Regular request:\t%s\n", timestr($time);
}

{
  my $req = HTTP::Request->new(POST => 'http://127.0.0.1:1337/User');
     $req->content_type('text/html');
  
  my $res;
  my $t1  = new Benchmark;
  $res = $ua->request( $req ) for 0 .. 1_000;
  my $t2  = new Benchmark;
  
  my $time = timediff($t2, $t1);
  
  printf "POST request:\t\t%s\n", timestr($time);
}