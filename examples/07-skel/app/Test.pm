# Class: Test
#   Example application.
# Singleton
# Extends:
#   Pony::Web

package Test;
use Pony::Object singleton => 'Pony::Web';

  # Method: startup
  #   Runs once on application startup.
  sub startup : Public
    {
      my $this = shift;
      $this->router->add('', q{
        example_text /test/text Example->testText
      });
    }

1;


