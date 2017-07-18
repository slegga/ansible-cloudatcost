#!/usr/bin/env perl
use YAML qw /LoadFile/;
use warnings;
use strict;
use autodie;
use 5.016;

=head1 NAME

print-perl-modules

=head1 DESCRIPTION

Print perl modules to screen.
Used for updateing perlbrew version manually.

Like this:
 perlbrew switch perl-5.26.0
 ./print-perl-modules.pl | perlbrew exec --with perl-5.26.0 cpanm

=cut

my $yaml = YAML::LoadFile("$ENV{HOME}/git/ansible-cloudatcost/roles/yum/vars/main.yml");
for my $val (@{$yaml->{perlmodules}}) {
	say $val;
}
