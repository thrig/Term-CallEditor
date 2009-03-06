# $Id: 1.t,v 1.8 2009/03/06 06:27:51 jmates Exp $
#
# Initial "does it load and perform basic operations" tests.

use warnings;
use strict;

use Test::More tests => 3;

BEGIN { use_ok('Term::CallEditor') }

ok( defined $Term::CallEditor::VERSION, '$VERSION defined' );
diag "Version is $Term::CallEditor::VERSION" if exists $ENV{'TEST_VERBOSE'};

ok( defined &solicit, 'have solicit function' );
