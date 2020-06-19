#!/usr/bin/perl

# CROSS LOUGH SOFTWARE
# infChat Database Driver
# Authors: lordfeck
# Authored: 19/06/2020

use strict;
use warnings;
use 5.010;          # To use "say"
use Config::Tiny;   # To read in ini file

use DBI;

# First, read in the config.
my $infConfig = Config::Tiny->new;
$infConfig = Config::Tiny->read('infchat.ini');

my $infDb = substr $infConfig->{database}->{dbfile}, 1, -1;
say "Startup: infDB is $infDb";

my $dbUser = $infConfig->{database}->{dbuser};
my $dbPass = $infConfig->{database}->{dbpass};

# Data Source Name.
my $dsn = "dbi:SQLite:dbname=$infDb";

my $dbh = DBI->connect($dsn, $dbUser, $dbPass, {
    PrintError      => 1,
    RaiseError      => 1,
    AutoCommit      => 1,
    FetchHashKeyName => 'NAME_lc'
});

if (undef $dbh) {
    die("intentional death: sqlite connection failed");
}

$dbh->disconnect;
