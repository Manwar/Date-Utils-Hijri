#!/usr/bin/perl

package T::Date::Utils::Hijri;

use Moo;
use namespace::clean;

with 'Date::Utils::Hijri';

package main;

use 5.006;
use Test::More tests => 14;
use strict; use warnings;

my $t = T::Date::Utils::Hijri->new;

ok($t->validate_year(1432));
eval { $t->validate_year(-1432); };
like($@, qr/ERROR: Invalid year \[\-1432\]./);

ok($t->validate_month(11));
eval { $t->validate_month(13); };
like($@, qr/ERROR: Invalid month \[13\]./);

ok($t->validate_day(30));
eval { $t->validate_day(31); };
like($@, qr/ERROR: Invalid day \[31\]./);

is($t->hijri_to_julian(1432, 1, 1), 2455538.5);
is(join(', ', $t->julian_to_hijri(2455538.5)), '1432, 1, 1');

is(sprintf("%04d-%02d-%02d", $t->hijri_to_gregorian(1432, 1, 1)), '2010-12-08');
is(join(', ', $t->gregorian_to_hijri(2010, 12, 8)), '1432, 1, 1');

is($t->days_in_hijri_year(1432), 354);
is($t->days_in_hijri_month_year(1, 1432), 30);
is($t->is_hijri_leap_year(1432), 0);
is($t->is_hijri_leap_year(1210), 1);

done_testing;
