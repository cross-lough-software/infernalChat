#!/usr/bin/perl

# CROSS LOUGH SOFTWARE
# infChat main script
# Authors: lordfeck
# Authored: 21/05/2020

# Perl Imports
use warnings;
use strict;
use feature ':5.10';

use Crypt::Digest::SHA256 ':all';
use CGI qw (param);

# SHA 256 Hashed Password
$hashWord="494a715f7e9b4071aca61bac42ca858a309524e5864f0920030862a4ae7589be";

# DEFINE FUNCTIONS

# The supplied password parameter
$passWord=param("passwd");

# For testing, passWord will not be set to this if we have the value from param().
unless ($passWord) {
    $passWord="WRONG";
}
chomp ($passWord);

$hashIn=sha256_hex($passWord);

# Begin HTML section
say "Content-type: text/html\n";

say "<html><head><title>infChat</title></head>";
say "<body>";
say "<h1>Infernal Chat</h1>";

if ( $hashWord eq $hashIn ) {
    say "<h2>Correct Password</h2>";
    print "As of today, I have nothing to say.\n";
} else {
    say "Invalid Password";
}

say "</body>";
say "</html>";
