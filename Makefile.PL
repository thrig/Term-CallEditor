# $Id: Makefile.PL,v 1.1 2004/06/04 04:18:26 jmates Exp $

use 5.005;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Editor',
    VERSION_FROM      => 'lib/Editor.pm',
# TODO fix!!
#    PREREQ_PM         => { 'XML::LibXML' => 1.53, 'XML::LibXSLT' => 1.52 },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Editor.pm',
       AUTHOR         => 'Jeremy Mates <jmates@sial.org>') : ()),
);
