#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WebService::Saasu' ) || print "Bail out!\n";
}

diag( "Testing WebService::Saasu $WebService::Saasu::VERSION, Perl $], $^X" );
