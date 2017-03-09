#! /usr/bin/perl
use strict;
use warnings;
use autodie;
use Data::Dumper;
use File::Copy;
my @copyfiles =('group_vars/cloudatcost/vars.yml','group_vars/cloudatcost/vault.yml','hosts');
my %datesforfiles; #({filename=>{old_date, new_date}})
my $syncatdir = "$ENV{HOME}/Dropbox/Apps/pib_stein/cac";
my $ansibledir="$ENV{HOME}/ansible";
system( "mkdir -p $ansibledir" ) if ! -e $ansibledir;
for my $filename (@copyfiles) {
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
         $atime,$mtime,$ctime,$blksize,$blocks) = stat("$syncatdir/$filename");
	$datesforfiles{$filename}{synccat}=$atime;
}
for my $filename (@copyfiles) {
        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
         $atime,$mtime,$ctime,$blksize,$blocks) = stat("$ansibledir/$filename");
        $datesforfiles{$filename}{ansible}=$atime;
}
while (my ($key,$value) = each %datesforfiles ) {
  if(! exists $value->{ansible} && ! exists $value->{ansible}){
    next;
  } elsif (! exists $value->{ansible}) { 
    copy($syncatdir.'/'.$key, $ansibledir);
    print "copy($syncatdir/$key, $ansibledir)\n";
  } elsif (! exists $value->{ansible}) {
    copy($ansibledir/$key, $syncatdir);
    print "copy($ansibledir/$key, $syncatdir)\n";
  } elsif ($value->{ansible} == $value->{synccat}) {
    next;
  } elsif ($value->{ansible} > $value->{synccat}) {
    copy($ansibledir.'/'.$key, $syncatdir);
    print "copy($ansibledir/$key, $syncatdir)\n";
  } elsif ($value->{ansible} < $value->{synccat}) {
    copy($syncatdir.'/'.$key, $ansibledir);
    print "copy($syncatdir/$key, $ansibledir)\n";
  }
}
print Dumper %datesforfiles;
# Script to sync group_vars with dropbox
#
# Read config file, 
# compare date on files.
# copy newest over oldest

# make symlinks
