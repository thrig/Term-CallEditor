# $Id: CallEditor.pm,v 1.12 2009/03/06 06:27:51 jmates Exp $
#
# Copyright (c) 2004-2005, Jeremy Mates. All Rights Reserved. This
# module is free software. It may be used, redistributed and/or modified
# under the terms of the Perl Artistic License:
#
# http://www.perl.com/perl/misc/Artistic.html
#
# Solicits data from an external editor determined by the EDITOR
# environment variable.
#
# Run perldoc(1) on this module for additional documentation.

package Term::CallEditor;

use 5.005;
use strict;
use warnings;

use vars qw(@EXPORT @ISA $VERSION $errstr);
@EXPORT = qw(solicit);
@ISA    = qw(Exporter);
use Exporter;

use Fcntl qw(:DEFAULT :flock);
use File::Temp qw(tempfile);

use POSIX qw(getpgrp tcgetpgrp);

$VERSION = '0.13';

sub solicit {
  my $message = shift;

  return unless is_interactive();

  File::Temp->safe_level(2);
  my ( $tfh, $filename ) = tempfile( UNLINK => 1 );

  unless ( $tfh and $filename ) {
    $errstr = 'no temporary file';
    return;
  }

  select( ( select($tfh), $|++ )[0] );

  if ($message) {
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
    # TODO warn here if no idea how to deal with $message?
  }

  my $editor = $ENV{EDITOR} || 'vi';

  # need to unlock for external editor
  flock $tfh, LOCK_UN;

  # TODO how suppress "Can't exec" error system returns?
  my $status = system $editor, $filename;

  if ( $status != 0 ) {
    $errstr =
      ( $status != -1 )
      ? "external editor failed: editor=$editor, errno=$?"
      : "could not launch program: editor=$editor, errno=$!";
    return undef;
  }

  unless ( seek $tfh, 0, 0 ) {
    $errstr = "could not seek on temp file: errno=$!";
    return;
  }

  return wantarray ? ( $tfh, $filename ) : $tfh;
}

# Perl CookBook code to check whether terminal is interactive
sub is_interactive {
  my $tty;
  unless ( open $tty, '< /dev/tty' ) {
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

  use Term::CallEditor qw(solicit);

  my $fh = solicit('FOO: please replace this text');
  die "$Term::CallEditor::errstr\n" unless $fh;

  print while <$fh>;

=head1 DESCRIPTION

This module calls an external editor with an optional text message, then
returns any data from this editor as a file handle. By default, the
EDITOR environment variable will be used, otherwise C<vi>.

The C<solicit()> function supports different input formats, including a
scalar, scalar reference, array, or objects with the C<getlines> method
(L<IO::Handle|IO::Handle> or L<IO::All|IO::All>, for example).

On error, C<solicit()> returns C<undef>. Consult
C<$Term::CallEditor::errstr> for details.

=head1 EXAMPLES

=over 4

=item Pass in a block of text to the editor.

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

=head1 AUTHOR

Jeremy Mates, E<lt>jmates@sial.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2004-2005, Jeremy Mates. All Rights Reserved. This module
is free software. It may be used, redistributed and/or modified under
the terms of the Perl Artistic License:

http://www.perl.com/perl/misc/Artistic.html

=head1 HISTORY

Inspired from the CVS prompt-user-for-commit-message functionality.

=cut
