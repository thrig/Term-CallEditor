# $Id: pod.t,v 1.1 2004/06/04 04:18:31 jmates Exp $
#
# Attempt to test any POD files if possible.

use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok();
