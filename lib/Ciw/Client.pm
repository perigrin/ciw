package Ciw::Client;
our $VERSION = '0.01';
use Moose;
use namespace::autoclean;

use Try::Tiny;

with qw(Ciw::Directory);

has queue => (
    does     => 'EndGame::Backend',
    is       => 'ro',
    required => 1,
    handles  => [qw(find_job lock unlock completed)]
);

has delay => ( isa => 'Int', is => 'ro', default => 5 );

has job_types => (
    isa     => 'ArrayRef[RoleName]',
    traits  => ['Array'],
    is      => 'ro',
    lazy    => 1,
    builder => 'default_job_types'
);

sub default_job_types { ['Ciw::Job'] }

sub work {
    for my $role ( $self->list_job_types ) {
        while ( my $job_id = $self->find_jobs($role) ) {
            my $job = $self->directory->lookup($job_id);
            $self->lock($job_id);
            try {
                $job->execute;
                $self->completed($job_id);
            }
            catch {
                $self->log_error($_);
                $self->unlock($job_id);
            };
        }
    }
    sleep $self->delay;
}

sub log_error { warn shift }

1;
__END__
