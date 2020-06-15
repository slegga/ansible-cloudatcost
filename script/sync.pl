#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;
# use File::Copy;
use File::Basename;


my @symlinkfiles =( 'group_vars'
                    ,'ansible.cfg'
                ,'hosts');
my %datesforfiles; #({filename=>{old_date, new_date}})
my $syncatdir = "$ENV{HOME}/googledrive/data/cac";
my $ansibledir="$ENV{HOME}/ansible";
system( "mkdir -p $ansibledir" ) if ! -e $ansibledir;
for my $filename (@symlinkfiles) {
  my $f = "$ansibledir/$filename";
  next if -l $f; # next if file is symlink
  my $d = dirname($f);
  next if -l $d; # next if file is symlink
  system( "mkdir -p $d" ) if ( ! -d $d );
  if ( -f $f) {
      warn "$f is a file please remove or look inside if something is going to be kept.";
      next;
  }
  symlink($syncatdir.'/'.$filename, $f);
  warn $f;
}
