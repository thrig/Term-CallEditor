# $Id: 1.t,v 1.1 2004/06/04 04:18:31 jmates Exp $
#
# Initial "does it load and perform basic operations" tests

use Test::More 'no_plan';
BEGIN { use_ok('Editor') };

ok(defined $Editor::VERSION, '$VERSION defined');
