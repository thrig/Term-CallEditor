# $Id: Makefile.PL,v 1.4 2004/06/04 08:31:53 jmates Exp $

use 5.005;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Term::CallEditor',
    VERSION_FROM      => 'lib/Term/CallEditor.pm',
    PREREQ_PM         => { 'File::Temp' => 0.05 },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Term/CallEditor.pm',
       AUTHOR         => 'Jeremy Mates <jmates@sial.org>') : ()),
);
