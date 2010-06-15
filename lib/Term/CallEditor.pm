# -*- Perl -*-
#
# Solicits data from an external editor as determined by the EDITOR
# environment variable. Run perldoc(1) on this module for additional
# documentation.
#
# Copyright 2004-2005,2009-2010 Jeremy Mates
#
# This module is free software; you can redistribute it and/or modify it
# under the Artistic license.

package Term::CallEditor;

use strict;
use warnings;

require 5.006;

use vars qw(@EXPORT @ISA $VERSION $errstr);
@EXPORT = qw(solicit);
@ISA    = qw(Exporter);
use Exporter;

use Fcntl qw(:DEFAULT :flock);
use File::Temp qw(tempfile);
use IO::Handle;

use POSIX qw(getpgrp tcgetpgrp);

$VERSION = '0.50';

sub solicit {
  my $message          = shift;
  my $skip_interactive = shift;

  unless ($skip_interactive) {
    return unless _is_interactive();
  }

  File::Temp->safe_level(2);
  my ( $tfh, $filename ) = tempfile( UNLINK => 1 );

  unless ( $tfh and $filename ) {
    $errstr = 'no temporary file';
    return;
  }

  select( ( select($tfh), $|++ )[0] );

  if ( defined $message ) {
    my $ref = ref $message;
    if ( not $ref ) {
      print $tfh $message;
    } elsif ( $ref eq 'SCALAR' ) {
      print $tfh $$message;
    } elsif ( $ref eq 'ARRAY' ) {
      print $tfh "@$message";
    } elsif ( UNIVERSAL::can( $message, 'getlines' ) ) {
      print $tfh $message->getlines;
    }
  }

  my $editor = $ENV{EDITOR} || 'vi';

  # need to unlock for external editor
  flock $tfh, LOCK_UN;

  my $status = system $editor, $filename;
  if ( $status != 0 ) {
    $errstr =
      ( $status != -1 )
      ? "external editor failed: editor=$editor, errstr=$?"
      : "could not launch program: editor=$editor, errstr=$!";
    return;
  }

  # Must reopen filename, as editor could have done a rename() on us, in
  # which case the $tfh is then invalid.
  my $outfh;
  unless ( open( $outfh, '<', $filename ) ) {
    $errstr = "could not reopen tmp file: errstr=$!";
    return;
  }

  return wantarray ? ( $outfh, $filename ) : $outfh;
}

# Perl CookBook code to check whether terminal is interactive
sub _is_interactive {
  my $tty;
  unless ( open $tty, '<', '/dev/tty' ) {
    $errstr = "cannot open /dev/tty: errno=$!";
    return;
  }
  my $tpgrp = tcgetpgrp fileno $tty;
  my $pgrp  = getpgrp();
  close $tty;
  unless ( $tpgrp == $pgrp ) {
    $errstr = "no exclusive control of tty: pgrp=$pgrp, tpgrp=$tpgrp";
    return;
  }
  return 1;
}

1;

__END__

=head1 NAME

Term::CallEditor - solicit data from an external editor

=head1 SYNOPSIS

  use Term::CallEditor qw/solicit/;

  my $fh = solicit('FOO: please replace this text');
  die "$Term::CallEditor::errstr\n" unless $fh;

  print while <$fh>;

=head1 DESCRIPTION

This module calls an external editor with an optional text message via
the C<solicit()> function, then returns any data from this editor as a
file handle. By default, the EDITOR environment variable will be used,
otherwise C<vi>.

The optional arguments to C<solicit()> are:

=over 4

=item 1

The first argument to the C<solicit()> function contains an optional
message to print in the external editor. The module supports different
input formats, including a scalar, scalar reference, array, or objects
with the C<getlines> method (L<IO::Handle|IO::Handle> or
L<IO::All|IO::All>, for example).

=item 2

If the optional second parameter to C<solicit()> is set to true, the
module will skip the check whether the terminal is interactive. This may
be necessary if the EDITOR can run in some non-terminal environment, and
the code is not running under a terminal.

=back

On error, C<solicit()> returns C<undef>. Consult
C<$Term::CallEditor::errstr> for details.

=head1 EXAMPLES

=over 4

=item Pass in a block of text to the editor.

Use a here doc:

  my $fh = solicit(<< "END_BLARB");

  FOO: This is an example designed to span multiple lines for the sake
  FOO: of an example that span multiple lines.
  END_BLARB

=item Support bbedit(1) on Mac OS X.

To use BBEdit as the external editor, create a shell script
wrapper to call bbedit(1), then set this wrapper as the EDITOR
environment variable.

  #!/bin/sh
  exec bbedit -w "$@"

=back

=head1 BUGS

No known bugs.

=head2 Reporting Bugs

Newer versions of this module may be available from CPAN.

If the bug is in the latest version, send a report to the author.
Patches that fix problems or add new features are welcome.

http://github.com/thrig/Term-CallEditor

=head2 Known Issues

This module relies heavily on the Unix terminal, permissions on the
temporary directory (for C<File::Temp->safe_level), whether C<system()>
can actually run the C<EDITOR> environment variable, and so forth.

=head1 AUTHOR

Jeremy Mates, E<lt>jmates@sial.orgE<gt>

=head1 COPYRIGHT

Copyright 2004-2005,2009-2010 Jeremy Mates

This program is free software; you can redistribute it and/or modify it
under the Artistic license.

=head1 HISTORY

Inspired from the CVS prompt-user-for-commit-message functionality.

=cut
