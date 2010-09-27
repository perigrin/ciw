package Ciw::Backend::Memory;
use 5.12.1;
our $VERISON = '0.01';
use Moose;
use namespace::autoclean;

with qw(Ciw::Backend);

has queue => (
    isa     => 'ArrayRef',
    traits  => ['Array'],
    is      => 'ro',
    lazy    => 1,
    default => sub { [] },
    handles => {
        '_find_job'   => 'first',
        '_delete_job' => 'delete',
    }
);

sub _get_idx_for_id {
    my ( $self, $id ) = @_;
    my $q = $self->queue;
    ( $q->[$_] eq $id && return $_ ) for ( 0 ... @$q - 1 );
    return;
}

sub find_job_by_id {
    my ( $self, $id ) = @_;
    return unless $self->_find_job( sub { $_ eq $id } );
    my $scope = $self->new_scope;
    return $self->lookup($id);
}

sub lock   { ... }
sub unlock { ... }

sub completed {
    my ( $self, $id ) = @_;
    my $scope = $self->new_scope;
    my $job   = $self->find_job_by_id($id);
    $self->delete($job);
    $self->_delete_job( $self->_get_idx_for_id($id) );
}

sub insert {
    my ( $self, $object ) = @_;
    my $scope = $self->new_scope;
    $self->store($object);
    my $id = $self->object_to_id($object);
    push @{ $self->queue }, $id;
    return $id;
}

__PACKAGE__->meta->make_immutable;
1;
__END__
