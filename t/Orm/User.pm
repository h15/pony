package Orm::User;
use Pony::Object qw/Pony::Orm/;

    /**
     *  Orm system for users.
     *
     *  @package Orm::User
     *  @uses Pony::Orm
     *  @uses Pony::Object
     */
    
    has keys    => [ qw/name mail/ ];
    has set     => 'user';
    has name    => undef;
    has mail    => undef;
    has web     => undef;
    has regdate => undef;
    
1;
