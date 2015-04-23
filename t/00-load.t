#!perl

use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 1;

BEGIN { use_ok('Date::Utils::Hijri') || print "Bail out!"; }

diag( "Testing Date::Utils::Hijri $Date::Utils::Hijri::VERSION, Perl $], $^X" );
