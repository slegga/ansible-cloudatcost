#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;
use File::Copy;
use File::Basename;


my @copyfiles =( 'group_vars/cloudatcost/vars.yml'
#                ,'cac_ssh/vars.yml'
#                ,'cac_ssh/vault.yml'
                ,'ansible.cfg'
                ,'hosts');
my %datesforfiles; #({filename=>{old_date, new_date}})
my $syncatdir = "$ENV{HOME}/Dropbox/Apps/pib_stein/cac";
my $ansibledir="$ENV{HOME}/ansible";
system( "mkdir -p $ansibledir" ) if ! -e $ansibledir;
for my $filename (@copyfiles) {
  my $f = "$syncatdir/$filename";
  my $d = dirname($f);
  system( "mkdir -p $ansibledir" ) if ( ! -d dirname($f) );
  if (! -f $f) {
      warn "$f does not exists! Ignore";
      next;
  }
  warn $f;
  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
      $atime,$mtime,$ctime,$blksize,$blocks) = stat($f);
  $datesforfiles{$filename}{synccat}=$atime;
}
for my $filename (@copyfiles) {
  my $f = "$ansibledir/$filename";
  my $d = dirname($f);
  system( "mkdir -p $d" ) if ( ! -d $d );
  next if ! -f $f;
  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
      $atime,$mtime,$ctime,$blksize,$blocks) = stat($f);
  $datesforfiles{$filename}{ansible}=$atime;
}
while (my ($key,$value) = each %datesforfiles ) {
  my ($af,$sf) = ($ansibledir.'/'.$key,$syncatdir.'/'.$key);
  if((! exists $value->{ansible} || ! defined $value->{ansible})
      && (! exists $value->{synccat} || ! defined $value->{synccat})){
    next;
  } elsif (! exists $value->{ansible}) {
    copy($sf, $af) or die "$sf,$af Copy failed: $!";
    print "copy($sf, $af)\n";
    next;
  } elsif (! exists $value->{synccat}) {
    print "copy($af, $sf)\n";
    my $d = dirname($sf);
    if ( ! -d $d ) {
        print "mkdir -p $d";
        system( "mkdir -p $d" )
    }
    copy($af, $sf) or die "Copy failed: $! $d";
  } elsif ($value->{ansible} == $value->{synccat}) {
    next;
  } elsif ($value->{ansible} > $value->{synccat}) {
    copy($af, $sf) or die "Copy failed: $!";
    print "copy($af, $sf)\n";
  } elsif ($value->{ansible} < $value->{synccat}) {
    copy($sf, $af) or die "Copy failed: $!";
    print "copy($sf, $af)\n";
  }
}
print Dumper %datesforfiles;
# Script to sync group_vars with external storage catalog
#
# Read config file,
# compare date on files.
# copy newest over oldest

# make symlinks
