#!/usr/bin/env perl

use lib './lib';
use Test::More tests => 3;

use_ok 'Pony::Object';
use_ok 'Pony::Model::Dbh::SQLite';
use_ok 'Pony::Model::Crud::SQLite';

#use Pony::Object;
use Pony::Model::Dbh::SQLite;
use Pony::Model::Crud::SQLite;

__END__

Pony::Model::Dbh::SQLite->new( './t/sqlite.db' );

my $dbh = new Pony::Model::Dbh::SQLite;
#   $dbh->dbh->do("drop table `pony_test_table_user`");
   $dbh->dbh->do( q{
                    create table `pony_test_table_user`
                    (
                        `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                        `name` varchar(32),
                        `mail` varchar(256) not null
                    )
                   });

my $userModel = new Pony::Model::Crud::SQLite('pony_test_table_user');
my $id   = $userModel->create({mail => q[gosha.bugov@lorcode.org']});

ok ( $id eq '1', 'last insert id' );

my @special = qw{' \ / -- " ` ф ё ы};

for my $i ( 0 .. 1000 )
{
    my $rnd = $special[ int rand @special ];
    $id = $userModel->create({ name => "user$rnd$i$rnd",
                               mail => qq[user$i\@${rnd}lorcode.org] });
    
    printf "%04d\n", $i unless $i % 100;
}

ok ( $id eq '1002', 'last insert id 2' );

for my $i ( 500 .. 700 )
{
    my $rnd = $special[ int rand @special ];
    $userModel->update({ mail => qq[user$i$rnd\@codewars.ru] },
                       { id   => $i });
}

my @a = $userModel->raw( q{SELECT COUNT(*) FROM `pony_test_table_user`
                           WHERE `mail` LIKE '%codewars.ru'} );

ok ( $a[0]->{'COUNT(*)'} eq '201', 'check update and raw' );

for my $i ( 600 .. 700 )
{
    $userModel->delete({ id => $i });
}

my $count = $userModel->count();

ok ( $count eq '901', 'delete and count' );

my @users = $userModel->list( undef, ['id'], undef, undef, 500, 10 );

ok ( @users eq 10, 'list' );
