#!/usr/bin/perl

# CROSS LOUGH SOFTWARE
# infChat Database Driver
# Authors: lordfeck
# Authored: 19/06/2020

package infDb;

use strict;
use warnings;
use 5.010;          # To use "say"
use Config::Tiny;   # To read in ini file
use DBI;

require Exporter;
my @ISA = qw(Emporter);
my @EXPORT = qw (connectToDb initDb disconnectDb runQuery getMsgId writeMsg);

# Global Variables
my $dbh;
my $dsn;
my $infConfig;
my $rv;

# checkerr currently doesn't work - rv not set
sub checkErr {
    if ($rv <0) {
        say "$_[0] failed with status: $DBI::errstr";
    } else {
        say "$_[0] succeeded.";
    }
}

sub loadCfg {
    $infConfig = Config::Tiny->new;
    $infConfig = Config::Tiny->read('infchat.ini');

    my $infDb = substr $infConfig->{database}->{dbfile}, 1, -1;
    say "Startup: infDB is $infDb";

    # User and pass not used with sqlite
    my $dbUser = $infConfig->{database}->{dbuser};
    my $dbPass = $infConfig->{database}->{dbpass};

    # Data Source Name.
    $dsn = "dbi:SQLite:dbname=$infDb";
}

sub connectToDb {
    loadCfg;
    # Connect to SQLite
    $dbh = DBI->connect($dsn, '', '', {
        PrintError      => 1,
        RaiseError      => 0,
        AutoCommit      => 1,
        FetchHashKeyName => 'NAME_lc'
    }) or die("intentional death: sqlite connection failed");
}

sub initDb {
    die "No DBH here!" unless $dbh;

    my $mkMsgTab = "CREATE TABLE IF NOT EXISTS MESSAGES01 (
            msgId int,
            loginId int,
            textStyle int,
            msgTxt varchar(512));"; 
    my $mkLoginTab = "CREATE TABLE IF NOT EXISTS LOGINS (
            loginId int,
            loginHashword varchar(255),
            loginMail varchar(512));"; 
    my $mkCircleTab = "CREATE TABLE IF NOT EXISTS CIRCLES (
            circleId int,
            circleName varchar(512),
            topic varchar(512));"; 

    $rv = $dbh->do($mkMsgTab);
    $rv = $dbh->do($mkLoginTab);
    $rv = $dbh->do($mkCircleTab);
}

sub runQuery {
    $rv = $dbh->do("@_");
}

sub disconnectDb {
    $dbh->disconnect;
}

# TODO:Move these to another module?
sub writeMsg {
    $rv = $dbh->do("INSERT INTO MESSAGES01 VALUES (0, 0, 0, ?)", undef, $_[0]);
}

sub getMsgId {
    my $sql = "SELECT msgTxt FROM MESSAGES01 where msgId=?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($_[0]);
    return ($sth->fetchrow_array); 
}

# Return TRUE when Perl loads this module successfully
1;
