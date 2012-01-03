#!/usr/bin/env perl

use lib './lib';
use Test::More tests => 8;

use_ok 'Pony::Object';
use_ok 'Pony::Crud::Dbh::MySQL';
use_ok 'Pony::Crud::MySQL';

use Pony::Object;
use Pony::Crud::Dbh::MySQL;
use Pony::Crud::MySQL;

my $auth =  {
                host     => 'localhost',
                dbname   => 'pony',
                user     => 'pony',
                password => 'pony secret'
            };

Pony::Crud::Dbh::MySQL->new( $auth );
my $dbh = new Pony::Crud::Dbh::MySQL;
   $dbh->dbh->do("drop table `pony_test_table_user`");
   $dbh->dbh->do( q{
                    create table `pony_test_table_user`
                    (
                        `id` int(11) auto_increment primary key,
                        `name` varchar(32),
                        `mail` varchar(256) not null
                    )
                   });

my $userModel = new Pony::Crud::MySQL('pony_test_table_user');
my $id   = $userModel->create({mail => q[gosha.bugov@lorcode.org']});

ok ( $id eq '1', 'last insert id' );

my @special = qw{' \ / -- " ` ф ё ы};

for my $i ( 0 .. 10_000 )
{
    my $rnd = $special[ int rand @special ];
    $id = $userModel->create({ name => "user$rnd$i$rnd",
                               mail => qq[user$i\@${rnd}lorcode.org] });
}

ok ( $id eq '10002', 'last insert id 2' );

for my $i ( 5_000 .. 7_000 )
{
    my $rnd = $special[ int rand @special ];
    $userModel->update({ mail => qq[user$i$rnd\@codewars.ru] },
                       { id   => $i });
}

my @a = $userModel->raw( q{SELECT COUNT(*) FROM `pony_test_table_user`
                           WHERE `mail` LIKE '%codewars.ru'} );

ok ( $a[0]->{'COUNT(*)'} eq '2001', 'check update and raw' );

for my $i ( 6_000 .. 7_000 )
{
    $userModel->delete({ id => $i });
}

my $count = $userModel->count();

ok ( $count eq '9001', 'delete and count' );

my @users = $userModel->list( undef, ['id'], undef, undef, 5_000, 10 );

ok ( @users eq 10, 'list' );
