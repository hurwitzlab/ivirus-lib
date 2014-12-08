#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 3;

use_ok('IVirus::DB');

my $db = new_ok('IVirus::DB');
my $dbh = $db->dbh;

isa_ok($dbh, 'DBI::db', "dbh");
