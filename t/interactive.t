# $Id: interactive.t,v 1.1 2009/03/06 06:27:51 jmates Exp $
#
# TODO figure out support for non-terminal things like emacsclient, or
# wacky Windows things?
#
# 'make test' has terminal issues, to test, use something like:
# perl -Iblib/lib -MTerm::CallEditor -e 'my $fh = solicit(); print while <$fh>'

use warnings;
use strict;

use Test::More 'no_plan';
BEGIN { use_ok('Term::CallEditor') }

if (-t) {
  diag "Terminal found, running interactive tests...\n";
} else {
  exit 0;
}

# muck with EDITOR environment variable to test expected breakage
my $oldeditor = $ENV{'EDITOR'};

$ENV{'EDITOR'} = 'false';
is( solicit(), undef, 'editor should fail as calling false' );
diag $Editor::errstr if exists $ENV{'TEST_VERBOSE'};

$ENV{'EDITOR'} = "nosuchapplication\n";
is( solicit(), undef, 'editor should fail as calling nonexistant app' );
diag $Editor::errstr if exists $ENV{'TEST_VERBOSE'};

$ENV{'EDITOR'} = $oldeditor if defined $oldeditor;

# Disabled as Test::More takes over standard out, which thwarts vi.
#my $to_editor   = 'Quit without changing anything.';
#my $from_editor = solicit($to_editor)->getline;
#chomp $from_editor;
#cmp_ok( $from_editor, 'eq', $to_editor, 'Solicitation text not changed' );
