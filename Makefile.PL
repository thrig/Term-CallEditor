use inc::Module::Install;
name 'Term-CallEditor';
all_from 'lib/Term/CallEditor.pm';
license 'artistic';

perl_version '5.006';
requires 'File::Temp'      => 0.18;
requires 'IO::Handle'      => 0;
test_requires 'Test::More' => 0.72;

resources
  license    => 'http://dev.perl.org/licenses/artistic.html',
  repository => 'http://github.com/thrig/Term-CallEditor',
  bugtracker =>
  'https://rt.cpan.org/Public/Dist/Display.html?Name=Term-CallEditor';

WriteAll;
