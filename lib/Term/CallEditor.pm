# $Id: CallEditor.pm,v 1.2 2004/06/04 07:08:34 jmates Exp $
#
# Copyright 2004 by Jeremy Mates
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# Solicits for data from an external Editor such as 'vi' or whatever the
# EDITOR environment variable is set to.
#
# Run perldoc(1) on this module for additional documentation.

# TODO get a better name??
package Editor;

use 5.005;
use strict;
use warnings;

use vars qw(@EXPORT_OK @ISA $errstr);
@EXPORT_OK = qw(solicit);
@ISA       = qw(Exporter);
use Exporter;

use Fcntl qw(:DEFAULT :flock);
use File::Temp qw(tempfile);
#use File::Spec ();

our $VERSION = '0.01';

sub solicit {
  my $message = shift;

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

    # TODO need to rewind fh for editor??
    seek $tfh, 0, 0;
  }

  my $editor = $ENV{EDITOR} || 'vi';

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

# TODO OO as well as proceedural?
#sub new {
#  my $class = shift;
#  my $prefs = shift;
#
#  my $self = {};
#  bless $self, $class;
#}

#sub errorstring {
#  my $self = shift;
#  return $self->{'errorstring'};
#}

1;
__END__

=head1 NAME

Editor - solicit for data from an external Editor

=head1 SYNOPSIS

  use Editor;
  # TODO

=head1 DESCRIPTION

TODO

=head1 SEE ALSO

TODO

=head1 AUTHOR

Jeremy Mates, E<lt>jmates@sial.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Jeremy Mates

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
