package OVPNADM::config;

use strict; use warnings;
use parent 'Exporter';

our @EXPORT = qw($SSL $DBH); 
 
our $SSL = {
   'country' => 'CH',
   'state' => 'Zug',
   'loc' => 'Huenenberg',
   'orga' => 'My Company',
   'orgaunit' => '',
   };

our $DBH = {
   'db' => 'ovpn-admin',
   'user' => 'dbuser',
   'pass' => 'password',
   'host' => '127.0.0.1'
   };

1;