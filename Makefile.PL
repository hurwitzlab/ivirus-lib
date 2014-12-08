use inc::Module::Install;

name           'IVirus-Lib';
abstract       'General purpose code for iVirus';
author         'Ken Youens-Clark <kyclark@email.arizona.edu>';
version        '0.01';
license        'GPL';

requires 'DBI'                      => '1.630';
requires 'DBD::mysql'               => '';
requires 'Moose'                    => '2.1005';
requires 'Template'                 => '2.25';
requires 'Template::Plugin::Comma'  => '0.04';
requires 'namespace::autoclean'     => '';
requires 'YAML'                     => '';
requires 'Readonly'                 => '';
requires 'Text::Markdown'           => '';

test_requires 'Test::More'          => '0.98';
test_requires 'Test::Exception'     => '';

WriteAll;
