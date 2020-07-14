#!/usr/bin/perl

# CROSS LOUGH SOFTWARE
# infChat Command Line Interface
# Authors: lordfeck
# Authored: 14/07/2020

use strict;
use warnings;
use 5.010;          # To use "say"

# Use local dir to find modules (if we can't do something like #include)
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/infCore';

use infDb;

# Global Variables

# main exec
infDb::connectToDb;
infDb::initDb;

infDb::writeMsg("Hello infChat");
say infDb::getMsgId(0);

infDb::disconnectDb;
