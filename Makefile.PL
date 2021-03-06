#!/usr/bin/perl

use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Date::Utils::Hijri',
    AUTHOR             => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM       => 'lib/Date/Utils/Hijri.pm',
    ABSTRACT_FROM      => 'lib/Date/Utils/Hijri.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES   => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Moo::Role'        => 0,
        'namespace::clean' => 0,
        'List::Util'       => 0,
        'Date::Utils'      => '0.07',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Date-Utils-Hijri-*' },
    (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/Manwar/Date-Utils-Hijri.git',
                web  => 'https://github.com/Manwar/Date-Utils-Hijri',
            },
        }})
     : ()
    ),
);
