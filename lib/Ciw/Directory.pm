package Ciw::Directory;
our $VERISON = '0.01';
use Moose::Role;
use namespace::autoclean;

use aliased 'Ciw::Directory';
use KiokuDB::TypeMap::Entry::Naive;
use KiokuDB::TypeMap;

has directory => (
    isa      => 'KiokuX::Model',
    is       => 'ro',
    required => 1,
    handles  => [qw(lookup new_scope store root_set)]
);

1;
__END__
