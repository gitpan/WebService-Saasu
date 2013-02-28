use inc::Module::Install;

name     'WebService-Saasu';
all_from 'lib/WebService/Saasu.pm';
author   q{Tobias Kirschstein <lev@cpan.org>};
license  'perl';

build_requires 'Test::More';

requires 'Mouse';
requires 'Web::API';
requires 'XML::Simple';

auto_install;

WriteAll;
