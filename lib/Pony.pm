package Pony;

our $VERSION = 0.03;

__END__

=head1 OVERVIEW

Pony is a module set, which make Perl more comfirtable for modern development.

=head2 How to install 

At a first, you should to install required modules:

=over

=item for Pony::Crud::Dbh::MySQL

    sudo cpan DBI

=back

=head2 More info about some modules

=head3 Pony::Object

What it can? Now it's replaced in personal repo. You can find C<Pony::Object>
here: https://github.com/h15/pony-object.

=over

=item strict and modern

It's turning on strict mode and enable to use perl features from v5.10

=item has

New key word C<has> for define class property or method if values is subroutine
ref.

    has name => 'Joe';

=item debug

You can see data struct via 'dump' function.

    say dump { [ qw/perl rocks !/ ] }

=item ALL

C<ALL> hash consists class default properties. You can get that via C<ALL> method.

=item inheritance

As many other systems Pony::Object support inheritance too.

    package A;
    use Pony::Object;
        
        sub dontDoIt
            {
                say 'O`key!';
            }
    
        sub doIt
            {
                say 'Not today; Sorry...';
            }
    1;
    
    package B;
    use Pony::Object qw(A);
    
        sub doIt
            {
                say 'Sure!';
            }
    1;
    
    package C;
    use Pony::Object qw(B A);
    
    1;

=item singleton

If your class will be inheritance C<singleton> you will get singleton class.

    package Alone;
    use Pony::Object 'singleton'
    
        has someResource => undef;
    
    1;

=item new C<new>

New method is already written. If you wanna do smth. on object initialization
 - use method C<init>. It will be called in the end of C<new>.

=back

=head3 Pony::Stash

It's a little stash with some data ^_^ It's a singleton.

=over

=item How to start

    use Pony::Stash;
    
    # Initialize with value.
    Pony::Stash->new('../resources/config.dat');
    
    # or
    my $conf = new Pony::Stash('../resources/config.dat');
    
    # ReInitialize
    Pony::Stash->new->init('../resources/config.dat');
    
    # or
    $conf->init('../resources/config.dat');

=item Method C<save>

Save stash value into file.

    Pony::Stash->save;

=item Method C<findOrCreate>

Find value into stash or create it. And return it.

    my $u = Pony::Stash->findOrCreate
            ( user => { table => 'users', default => 'anonymous' } );

=item Methods C<get> and C<set>

    Pony::Stash->set ( user => { table => 'users', default => 'anonymous' } );
    
    my $u = Pony::Stash->get('user');

=item Method C<delete>

Remove value from stash.

    Pony::Stash->delete('user');

=back

=head3 Pony::Crud::MySQL

=over

=item Method C<create>

Create record into database.

    my $userModel = new Pony::Crud::MySQL('pony_test_table_user');
    
    # Params : {data} - data for new record.
    # Returns: id of new record.
    my $id = $userModel->create({mail => q[gosha.bugov@lorcode.org]});

'pony_test_table_user' is a name of table, which will used for new model.

=item Method C<read>

    # Params : {where}(?), [fields](?).
    # Returns: hash ref.
    my $user = $userModel->read( {id => $id}, ['mail'] );

=item Method C<update>

    # Params : {data}, {where}.
    # Returns: true || false.
    $userModel->update({mail => 'user@example.com'} , {id => $id});

=item Method C<delete>

    # Params : {where}.
    # Returns: true || false.
    $userModel->update({id => $id});

=item Method C<list>

    # Params : {where}(?), [fields](?), order(?), rule(?), offset(?), limit(?).
    # Returns: array of hash refs.
    my @users = $userModel->list({status => 0}, undef, 'id', 'ASC', 5_000, 10 );

=item Method C<count>

    # Params : {where}(?).
    # Returns: integer.
    my $count = $userModel->count();

=item Method C<raw>

    # Params : query.
    # Returns: array of hashes.
    my @hashes = $userModel->raw( "SELECT * FROM `pony_test_table_user`
                                            WHERE `name` LIKE 'A%'" );

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 - 2013, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut

