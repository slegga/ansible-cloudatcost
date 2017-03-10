#!/usr/bin/perl
use 5.016;
use warnings;
use strict;
use autodie;
use File::Basename;
use File::Copy;

sub mklink {
  my ($oldfile, $link) = @_;
  if (! -e $link) {
    print "symlink $oldfile, $link\n";
    symlink $oldfile, $link;    
  }
}

my $ansibledir = "$ENV{HOME}".'/ansible';
if (! -d $ansibledir) {
  mkdir($ansibledir);
}
my $grpvdir = $ansibledir.'/group_vars';
if (! -d $grpvdir) {
  mkdir($grpvdir);
}


my @ans_repos = glob "$ENV{HOME}/git/ansible*";
for my $ans_repo(@ans_repos) {
  my @items = glob "$ans_repo/*";
  for my $item (@items) {
    my $link = basename($item);
    next if $link eq 'group_vars';
    next if $link eq 'hosts';

    if ($link eq 'README.md') {
      if (! -e "$ansibledir/README") {
        mkdir "$ansibledir/README";
      }
      my $base_repo = basename($ans_repo);
      mklink($item, $ansibledir.'/README/'.$base_repo.'.md');
      next;
    }
    elsif ($link eq 'roles') {
      if (! -e "$ansibledir/roles") {
      	mkdir "$ansibledir/roles";
      }
      my @roles = glob "$item/*";
      for my $role (@roles) {
      	if (-d $role) {
    	    my $base = basename($role);
    	    mklink($role, "$ansibledir/roles/$base");
      	}
      }
      next;
    } elsif ($link eq 'ansible.cfg') {
      if (! -e "$ansibledir/$link") {
        copy($item,"$ansibledir/$link");
      }
    }
 #   print "$item\n";
    mklink $item, "$ansibledir/$link";
#    symlink $item, $ansibledir/$link;
  }
}
print "\n";
system ('bin/sync.pl');
