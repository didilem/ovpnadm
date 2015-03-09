# OpenVPN Administration Console

© 2015 / Lembke Computer Consulting GmbH /  http://www.lcc.ch

This file is part of OpenVPN Admin.

OpenVPN Admin is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation GPL version 3.

OpenVPN Admin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with OpenVPN Admin if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

## Web based openVPN Administration overview

The goal of this perl project is to provide an easy web based administration of connected
networks, clients and to where those clients have access to. 
After initial setup of the environment, openvpn server, mysql server, web server and
openssl ca authority you will have the possibility to create networks which then are 
assigned to network groups which again can be assigned to the clients you create.
Clients will be added over the interface and their openssl cert provided as ovpn config
files to the administrator for distribution to the client. 
Second part of the suite is the verify script for openvpn server which will check against 
the database if clients are in an active state and if so creates the network settings on 
the fly for the specific client. 
In case that you have multiple instances of VPN servers they can all connect to the central 
ovpnadm server to authorize client access. 

## Installation 

For the convenience we have included a ready to use openssl ca in the distribution however we
strongly recommend to setup your own ca which has it's proper ca key for productive use. 
A short cut for the procedure is excellently covered in this article 
**https://jamielinux.com/articles/2013/08/act-as-your-own-certificate-authority/.** 
Make sure that files in lib/openssl are writable by your apache user. The ca key should not carry a passphrase or if you prefer you can add the passphrase to the commands under lib/OVPNADM/clients.pm where required. 

### Required perl libraries
Please install DBI, Capture::Tiny and Data::Validate::IP which are probably not part of your standard perl library. 

### Folder structure
* www
* openvpn

#### www
Contains the main script index.pl and sub folders for style and javascripts

#### openvpn 
Contains openvpn configuration and verify script for your openvpn server. Below you find the main application for ovpnadm under ovpnadm/lib. Additionally you find the example CA under ovpnadm/lib/openssl 

### Setup your web server
We tested the application under Apache 2.2 but you should be able to use it under lighttpd or nginx without problems. 
**A word of warning. The web server should not be accessible over the Internet. **

Depending on you preferences you can either link your Document root to the folder www or you may copy the contents of the folder www to your document root. 

#### Example directory directive for apache with mod_cgi loaded
```
<Directory /var/www>
   AddHandler cgi-script .pl
   Options -Indexes +FollowSymLinks +MultiViews +ExecCGI
   AllowOverride All
   Order allow,deny
   allow from all
   AuthUserFile /etc/apache2/users
   AuthName authorization
   AuthType Basic
   Require valid-user
</Directory>
```

Open index.pl in the www folder in you favorite editor and make sure that the library path points to the main library 
of this application. 

```
push @INC, '/etc/openvpn/ovpnadm/lib';
```

and the database connection

```
my $dbh = DBI->connect(
    "dbi:mysql:dbname=ovpn-admin",
    "dbuser", "password",
     {RaiseError => 0, PrintError => 1, mysql_enable_utf8 => 1}
 ) or die "Connect to database failed.";
```

change dbuser and password to match your setup. 

### setup openvpn 
Link or copy the contents of the folder openvpn to /etc/openvpn. Edit ovpnadm-udp.conf to match your environment. 

### alter configuration of ovpnadm 
Edit client.pm under OVPNADM and change the settings do match your organization.
```
sub addClient {
        my $self = shift;
        if (!$self->{POST}) {
                $self->{FIELDS}->{country} = 'CH';
                $self->{FIELDS}->{state} = 'Zug';
                $self->{FIELDS}->{loc} = 'Huenenberg';
                $self->{FIELDS}->{orga} = 'My Company';
                $self->{FIELDS}->{orgaunit} = '';
        }
```
Alter the values for country, state, loc, orga, orgaunit which correspond to C, ST, L, O, OU of openssl.
In a later release we will implement a global configuration file to edit this in one place.

### mysql setup
create the required database with the supplied file create_ovpnadm.sql

### Start adding vpn configuration
point your browser to your web server, add networks, groups and clients. 










