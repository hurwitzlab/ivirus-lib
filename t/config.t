#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 4;

use_ok('IVirus::Config');

my $conf = new_ok('IVirus::Config');

my $db = $conf->get('db');
isa_ok($db, 'HASH', '"db"');

is($db->{'name'}, 'ivirus');
