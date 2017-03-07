#! /usr/bin/perl
use strict;
use warnings;
use autodie;
use Data::Dumper;
use File::Copy;

my %datesforfiles; #({filename=>{old_date, new_date}})
my $syncatdir = "$ENV{HOME}/Dropbox/Apps/pib_stein/cac";
my $ansibledir="$ENV{HOME}/ansible/group_vars/cloudatcost";

opendir(my $sdir, $syncatdir) || die("Can not open dir\n");
while( my $filename = readdir($sdir) ) {
      next if $filename =~/^\./;
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
         $atime,$mtime,$ctime,$blksize,$blocks) = stat("$syncatdir/$filename");
	$datesforfiles{$filename}{synccat}=$atime;
}
closedir $sdir;
opendir(my $adir, $ansibledir) || die("Can not open dir\n");
while( my $filename = readdir($adir) ) {

      next if $filename =~/^\./;
        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
         $atime,$mtime,$ctime,$blksize,$blocks) = stat("$ansibledir/$filename");
        $datesforfiles{$filename}{ansible}=$atime;
}
closedir $adir;
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

