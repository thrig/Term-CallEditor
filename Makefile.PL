# $Id: Makefile.PL,v 1.2 2004/06/04 07:12:27 jmates Exp $

use 5.005;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Editor',
    VERSION_FROM      => 'lib/Editor.pm',
    PREREQ_PM         => { 'File::Temp' => 0.05 },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Editor.pm',
       AUTHOR         => 'Jeremy Mates <jmates@sial.org>') : ()),
);
