package Ciw::Backend;
our $VERSION = '0.01';
use Moose::Role;
use namespace::autoclean;

with qw( Ciw::Directory );

requires qw(insert find_job lock unlock completed);

1;
__END__
