package Fennec::Manual::Quickstart;
use strict;
use warnings;

1;

=pod

=head1 NAME

Fennec::Manual::Quickstart - Quick guide to immediate fennec usage.

=head1 DESCRIPTION

=head1 SYNOPSIS

This is a very simple test written in fennec, in fact the first test written in
fennec for fennec.

t/fennec-standalone.t:

    #!/usr/bin/perl;
    package TEST::MyStandaloneTest;
    use strict;
    use warnings;
    use Fennec standalone => {};

    start(); #This can go anywhere, but must be called.

    sub Fennec {
        my $class = shift;

        tests hello_world_group => sub {
            my $self = shift;
            ok( 1, "Hello world" );
        };
    }

    1;

Breakdown:

=over 4

=item package TEST::MyStandaloneTest;

Fennec tests must all be contained inside test packages, they will be used as
objects.

=item use Fennec standalone => {};

This tells fennec that this will be a standalone test. The hash can be used to
configure the fennec runner. Most of the time you can leave this hash empty.

=item start()

Fennec cannot start until your package has been completely loaded. As such your
standalone must call start(). I appologise for the boilderplate, it is safer
than an END block.

=item sub Fennec { ... }

Usually fennec tests are declared in the main package and not in a sub, however
standalone tests must implement the Fennec() class method and declare the tests
within.

=item tests hello_world_group => sub { ... }

This declares a test group named hello_world_group. All results should be
generated within test groups. Tests groups will be run in random order (unless
randomization disabled), and can even be run in parallel, so it makes sense to
seperate your tests into small groups.

=back

=head1 SKIP AND TODO

Fennec has the concept of todo tests, tests which are expected to fail. You can
also mark groups as skip if they are really bad.

If an exception is thrown within a TODO block or group then a failing TODO
result will be generated alerting you, however it is todo and will not count as
a failure in the grand scheme.

    #!/usr/bin/perl;
    package TEST::MyStandaloneTest;
    use strict;
    use warnings;
    use Fennec standalone => {};

    # Don't forget this
    start();

    sub Fennec {
        my $class = shift;

        # This will run, but failures will not count.
        tests not_yet_implemented => (
            todo => "This will fail",
            method => sub {
                my $self = shift;
                ok( 0, "Hello world" );
            },
        );

        # This will be skipped completely
        tests 'would die' => (
            skip => "This will die",
            method => sub {
                my $self = shift;
                die( "I eat you" );
            },
        );

        # You can also TODO specific asserts.
        tests 'some pass' => sub {
            ok( 1, 'pass' );
            TODO {
                ok( 0, 'fail' );
            } "This will fail, I will fix it later";
        }
    }

    1;

=head1 EARLY VERSION WARNING

L<Fennec> is still under active development, many features are untested or even
unimplemented. Please give it a try and report any bugs or suggestions.

=head1 DOCUMENTATION

=over 4

=item QUICK START

L<Fennec::Manual::Quickstart> - Drop Fennec standalone tests into an existing
suite.

=item FENNEC BASED TEST SUITE

L<Fennec::Manual::TestSuite> - How to create a Fennec based test suite.

=item MISSION

L<Fennec::Manual::Mission> - Why does Fennec exist?

=item MANUAL

L<Fennec::Manual> - Advanced usage and extending Fennec.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
