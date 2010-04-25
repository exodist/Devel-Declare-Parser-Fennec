package Fennec::Collector;
use strict;
use warnings;

use Fennec::Util::Accessors;
use Fennec::Util::Abstract;

Accessors qw/handlers/;
Abstract  qw/cull write/;

sub new {
    my $class = shift;
    my @handlers;
    for my $hclass ( @_ ) {
        $hclass = 'Fennec::Handler::' . $hclass;
        eval "require $hclass; 1" || die ( @_ );
        push @handlers => $hclass->new();
    }
    my $self = bless( { handlers => \@handlers }, $class );
    $self->init if $self->can( 'init' );
    return $self;
}

sub start {
    my $self = shift;
    $_->start for @{ $self->handlers };
}

sub finish {
    my $self = shift;
    $self->handle_output;
    $_->finish for @{ $self->handlers };
}

sub handle_output {
    my $self = shift;
    my @objs = $self->cull;
    my @bailouts;
    for my $obj ( sort { $a->timestamp <=> $b->timestamp } @objs ) {
        push @bailouts => $obj
            if $obj->isa( 'Fennec::Output::BailOut' );
        for my $handler ( @{ $self->handlers }) {
            $handler->handle( $obj );
        }
    }
    Runner->bail_out( \@bailouts ) if @bailouts;
}


1;

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
