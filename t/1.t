# $Id: 1.t,v 1.6 2004/06/04 08:34:11 jmates Exp $
#
# Initial "does it load and perform basic operations" tests
#
# TODO figure out support for non-terminal things like emacsclient,
# bbedit on Mac OS X or wacky Windows things?
#
# 'make test' has terminal issues, to test, use something like:
# perl -Iblib/lib -MEditor=solicit -e 'my $fh = solicit(); print while <$fh>'

use warnings;
use strict;

#use Test::More 'no_plan';
use Test::More tests => 6;

BEGIN { use_ok('Term::CallEditor') }

ok( defined $Term::CallEditor::VERSION, '$VERSION defined' );
diag "Version is $Term::CallEditor::VERSION" if exists $ENV{'TEST_VERBOSE'};

ok( defined &solicit, 'have solicit function' );

SKIP: {
  skip 'vim issues "Output is not to a terminal" error', 1;

  my $to_editor   = 'Quit without changing anything.';
  my $from_editor = solicit($to_editor)->getline;
  chomp $from_editor;
  cmp_ok( $from_editor, 'eq', $to_editor, 'Solicitation text not changed' );
}

fail_editor();

# muck with EDITOR environment variable to test expected breakage
sub fail_editor {
  my $oldeditor = $ENV{'EDITOR'};

  $ENV{'EDITOR'} = 'false';
  is( solicit(), undef, 'editor should fail as calling false' );
  diag $Editor::errstr if exists $ENV{'TEST_VERBOSE'};

 SKIP: {
    skip 'need to figure out how to hide warning from exec', 1;

    $ENV{'EDITOR'} = "nosuchapplication\n";
    is( solicit(), undef, 'editor should fail as calling nonexistant app' );
    diag $Editor::errstr if exists $ENV{'TEST_VERBOSE'};
  }

  $ENV{'EDITOR'} = $oldeditor if defined $oldeditor;
}
