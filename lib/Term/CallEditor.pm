# $Id: CallEditor.pm,v 1.1 2004/06/04 04:18:29 jmates Exp $
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

# TODO figure out exports; probably not going to be OO module?
use base qw(Exporter);

our $VERSION = '0.01';

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
