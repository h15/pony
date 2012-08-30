
# " – What a piece of junk!
#   – She'll make point five past lightspeed.
#     She may not look like much, but she's got it where it counts, kid.
#     I've made a lot of special modifications myself. "

package Pony::Application;
use Pony::Object -singleton;
use Plack::Request;

    public stash => undef;
    
    sub init : Public
        {
            my $this = shift;
        }
    
    sub clop : Public
        {
            my $env = shift;
            say dump @_;
            my $req = new Plack::Request($env);
            say dump $req;
            return [ '200' , [ 'Content-Type' => 'text/plain' ], [ "hello world\n" ] ];
        }

1;
