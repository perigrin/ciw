#!/usr/bin/env perl
use strict;
use Test::More;
use Test::Exception;

use Ciw::Backend::Memory;
use KiokuX::Model;

my $dir = KiokuX::Model->new(
    dsn        => 'dbi:SQLite::memory:',
    extra_args => { create => 1, }
);

my $q;

lives_ok { $q = Ciw::Backend::Memory->new( directory => $dir ) }
'built a new queue';

{

    package Ciw::Test::Job;
    use Moose;
    with qw(Ciw::Job);

    sub execute { ::pass('executed') }
}

ok( my $id  = $q->insert( Ciw::Test::Job->new() ), 'inserted a job' );
ok( my $job = $q->find_job_by_id($id),             'the job exists' );
$job->execute;
ok( $q->completed($id),       'job completed' );
ok( !$q->find_job_by_id($id), 'the job is gone' );
done_testing;
