package Date::Utils::Hijri;

$Date::Utils::Hijri::VERSION = '0.01';

=head1 NAME

Date::Utils::Hijri - Hijri date specific routines as Moo Role.

=head1 VERSION

Version 0.01

=cut

use 5.006;
use Data::Dumper;
use List::Util qw/min/;
use POSIX qw/floor ceil/;

use Moo::Role;
use namespace::clean;

our $HIJRI_MONTHS = [
    undef,
    q/Muharram/, q/Safar/ , q/Rabi' al-awwal/, q/Rabi' al-thani/,
    q/Jumada al-awwal/, q/Jumada al-thani/, q/Rajab/ , q/Sha'aban/,
    q/Ramadan/ , q/Shawwal/ , q/Dhu al-Qi'dah/ , q/Dhu al-Hijjah/
];

our $HIJRI_DAYS = [
    '<yellow><bold>      al-Ahad </bold></yellow>',
    '<yellow><bold>   al-Ithnayn </bold></yellow>',
    '<yellow><bold> ath-Thulatha </bold></yellow>',
    '<yellow><bold>     al-Arbia </bold></yellow>',
    '<yellow><bold>    al-Khamis </bold></yellow>',
    '<yellow><bold>    al-Jumuah </bold></yellow>',
    '<yellow><bold>      as-Sabt </bold></yellow>',
];

our $HIJRI_LEAP_YEAR_MOD = [
    2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29
];

has hijri_epoch         => (is => 'ro', default => sub { 1948439.5            });
has hijri_days          => (is => 'ro', default => sub { $HIJRI_DAYS          });
has hijri_months        => (is => 'ro', default => sub { $HIJRI_MONTHS        });
has hijri_leap_year_mod => (is => 'ro', default => sub { $HIJRI_LEAP_YEAR_MOD });

with 'Date::Utils';

=head1 DESCRIPTION

Hijri date specific routines as Moo Role.

=head1 METHODS

=head2 hijri_to_julian($year, $month, $day)

Returns Julian date of the given Hijri date.

=cut

sub hijri_to_julian {
    my ($self, $year, $month, $day) = @_;

    return ($day + ceil(29.5 * ($month - 1)) + ($year - 1) * 354 + floor((3 + (11 * $year)) / 30) + $self->hijri_epoch) - 1;
}

=head2 julian_to_hijri($julian_date)

Returns Hijri date as list (year, month, day) equivalent of the given Julian date.

=cut

sub julian_to_hijri {
    my ($self, $julian) = @_;

    $julian   = floor($julian) + 0.5;
    my $year  = floor(((30 * ($julian - $self->hijri_epoch)) + 10646) / 10631);
    my $month = min(12, ceil(($julian - (29 + $self->hijri_to_julian($year, 1, 1))) / 29.5) + 1);
    my $day   = ($julian - $self->hijri_to_julian($year, $month, 1)) + 1;

    return ($year, $month, $day);
}

=head2 hijri_to_gregorian($year, $month, $day)

Returns  Gregorian  date as list (year, month, day) equivalent of the given Hijri
date.

=cut

sub hijri_to_gregorian {
    my ($self, $year, $month, $day) = @_;

    $self->validate_date($year, $month, $day);
    return $self->julian_to_gregorian($self->hijri_to_julian($year, $month, $day));
}

=head2 gregorian_to_hijri($year, $month, $day)

Returns  Hijri  date as list (year, month, day) equivalent of the given Gregorian
date.

=cut

sub gregorian_to_hijri {
    my ($self, $year, $month, $day) = @_;

    ($year, $month, $day) = $self->julian_to_hijri($self->gregorian_to_julian($year, $month, $day));
    return ($year, $month, $day);
}

=head2 is_hijri_leap_year($year)

Returns 0 or 1 if the given Hijri year C<$year> is a leap year or not.

=cut

sub is_hijri_leap_year {
    my ($self, $year) = @_;

    my $mod = $year % 30;
    return 1 if grep/$mod/, @{$self->hijri_leap_year_mod};
    return 0;
}

=head2 days_in_hijri_year($year)

Returns the number of days in the given year of Hijri Calendar.

=cut

sub days_in_hijri_year {
    my ($self, $year) = @_;

    ($self->is_hijri_leap_year($year))
    ?
    (return 355)
    :
    (return 354);
}

=head2 days_in_hijri_month_year($month, $year)

Returns total number of days in the given Hijri month year.

=cut

sub days_in_hijri_month_year {
    my ($self, $month, $year) = @_;

    return 30 if (($month % 2 == 1) || (($month == 12) && (is_hijri_leap_year($year))));
    return 29;

}

=head2 validate_day($day)

=cut

sub validate_day {
    my ($self, $day) = @_;

    die("ERROR: Invalid day [$day].\n")
        unless (defined($day) && ($day =~ /^\d{1,2}$/) && ($day >= 1) && ($day <= 30));
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 REPOSITORY

L<https://github.com/Manwar/Date-Utils-Hijri>

=head1 ACKNOWLEDGEMENTS

Entire logic is based on the L<code|http://www.fourmilab.ch/documents/calendar> written by John Walker.

=head1 BUGS

Please report any bugs / feature requests to C<bug-date-utils-hijri at rt.cpan.org>
, or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Date-Utils-Hijri>.
I will be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Date::Utils::Hijri

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Utils-Hijri>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Date-Utils-Hijri>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Date-Utils-Hijri>

=item * Search CPAN

L<http://search.cpan.org/dist/Date-Utils-Hijri/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2015 Mohammad S Anwar.

This program  is  free software; you can redistribute it and / or modify it under
the  terms  of the the Artistic License (2.0). You may obtain a  copy of the full
license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any  use,  modification, and distribution of the Standard or Modified Versions is
governed by this Artistic License.By using, modifying or distributing the Package,
you accept this license. Do not use, modify, or distribute the Package, if you do
not accept this license.

If your Modified Version has been derived from a Modified Version made by someone
other than you,you are nevertheless required to ensure that your Modified Version
 complies with the requirements of this license.

This  license  does  not grant you the right to use any trademark,  service mark,
tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license
to make,  have made, use,  offer to sell, sell, import and otherwise transfer the
Package with respect to any patent claims licensable by the Copyright Holder that
are  necessarily  infringed  by  the  Package. If you institute patent litigation
(including  a  cross-claim  or  counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement,then this Artistic
License to you shall terminate on the date that such litigation is filed.

Disclaimer  of  Warranty:  THE  PACKAGE  IS  PROVIDED BY THE COPYRIGHT HOLDER AND
CONTRIBUTORS  "AS IS'  AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED
WARRANTIES    OF   MERCHANTABILITY,   FITNESS   FOR   A   PARTICULAR  PURPOSE, OR
NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS
REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE
OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of Date::Utils::Hijri
