package Orm::User;
use Pony::Object qw/Pony::Orm/;

    has keys => [ qw/name mail/ ];
    has set  => 'user';

1;
