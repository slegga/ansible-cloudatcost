#!/usr/bin/env perl
use 5.016;
use warnings;
use strict;
use autodie;
use File::Basename;
use File::Copy;
use Carp;
use Mojo::File 'path';

sub mklink {
  my ($oldfile, $link) = @_;
  if (! -e $link) {
    print "symlink $oldfile, $link\n";
    symlink $oldfile, $link || confess "symlink error";
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

$grpvdir = $ansibledir.'/ssh_vars';
if (! -d $grpvdir) {
      mkdir($grpvdir);
}


my @ans_repos = glob "$ENV{HOME}/git/*";
for my $ans_repo(@ans_repos) {
    if ($ans_repo =~/ansible\-/) {
	    my $rolelink = basename($ans_repo);
    	$rolelink =~s/^ansible\-//;
		if ($rolelink eq 'cloudatcost') {
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
		         mklink($item,"$ansibledir/$link");
		       }
		   }
		#   print "$item\n";
		       mklink $item, "$ansibledir/$link";
		 }

		} else {
		   # role symlink to repo
		 mklink $ans_repo, "$ansibledir/roles/$rolelink";

		}
	} elsif(-d "$ans_repo/ansible-role") {
		my $rolelink = path($ans_repo)->basename;
		mklink "$ans_repo/ansible-role", "$ansibledir/roles/$rolelink";
	}
}
print "\n";
system ('script/sync.pl');
