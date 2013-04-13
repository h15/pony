# Class: Test::Controller::Example
#   Example controller.
# Extends:
#   Pony::Web::Controller

package Test::Controller::Example;
use Pony::Object qw/Pony::Web::Controller/;

  use Pony::Web::Response;


  # Method: testTextAction
  #   Example action #1
  # Return: Pony::Web::Response
  
  sub testTextAction : Public
    {
      my $this = shift;
      return Pony::Web::Response->new(
        'Hello from Test::Controller::Example');
    }
  
  sub testTemplateAction : Public
    {
      my $this = shift;
      my @items;
      push @items, {number => "Item number $_"} for 0..10;
      return $this->render('test/test', from => 'Test',
                           items => \@items);
    }
1;


