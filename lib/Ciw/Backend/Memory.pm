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
    handles => { '_find_job' => 'first', }
);

sub find_job {
    my ( $self, $role ) = @_;
    my $scope = $self->new_scope;
    $self->_find_job( sub { $self->lookup($_)->does($role) } );
}

sub lock      { ... }
sub unlock    { ... }
sub completed { ... }

sub insert {
    my $self  = shift;
    my $scope = $self->new_scope;
    return map {
        my $id = $self->store($_);
        push @{ $self->queue }, $id;
    } @_;
}

__PACKAGE__->meta->make_immutable;
1;
__END__
