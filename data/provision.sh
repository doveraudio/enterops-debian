#!/bin/bash
### Provision Vagrant ###
printf "Checking for updates....\n";
sudo chown -R vagrant:vagrant /usr/local;
cd /var/data;
sudo mkdir /usr/local/share/keyrings;
sudo apt-get update;
sudo apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common;
NODEVERSION=node_16.x;
DISTRO="$(lsb_release -s -c)";
sudo apt-get install -y ufw;
sudo ufw allow OpenSSH;
sudo ufw allow SSH;
echo "y" | sudo ufw enable;

## curl https://mariadb.org/mariadb_release_signing_key.asc | gpg --dearmor | sudo dd of=/usr/local/share/keyrings/mariadb.gpg
sudo wget -O /usr/local/share/keyrings/php8.gpg https://packages.sury.org/php/apt.gpg;
echo "deb [signed-by=/usr/local/share/keyrings/php8.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php8.list;
sudo wget -O /usr/local/share/keyrings/nodesource.gpg.key https://deb.nodesource.com/gpgkey/nodesource.gpg.key;
echo "deb [signed-by=/usr/local/share/keyrings/nodesource.gpg.key] https://deb.nodesource.com/$NODEVERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list;
echo "deb-src [signed-by=/usr/local/share/keyrings/nodesource.gpg.key] https://deb.nodesource.com/$NODEVERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list;
echo "deb [signed-by=/usr/local/share/keyrings/mariadb.gpg] https://mirrors.syringanetworks.net/mariadb/repo/10.6/debian buster main" | sudo tee /etc/apt/sources.list.d/mariadb.list;
sudo cp /var/data/conf/mariadb-enterprise.pref /etc/apt/preferences.d/mariadb-enterprise.pref;
sudo cp /var/data/conf/pgdg.pref /etc/apt/preferences.d/pgdg.pref;
sudo cp /var/data/conf/php8.pref /etc/apt/preferences.d/php8.pref;
sudo cp /var/data/conf/nodesource.pref /etc/apt/preferences.d/nodesource.pref;

curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo dd of=/usr/local/share/keyrings/pgdg.gpg;
echo "deb [signed-by=/usr/local/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list;

## echo "deb [signed-by=/usr/local/share/keyrings/php7.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.list
## echo "deb [signed-by=/usr/local/share/keyrings/riot-archive-keyring.gpg] https://riot.im/packages/debian/ stretch main" | sudo tee -a /etc/apt/sources.list.d/riot.list


## sudo apt -y install mysql-community-server postgresql11 postgresql11-server mongodb-org redis httpd httpd-tools php php-common php-mysqlnd php-intl php-json php-xml php-mcrypt php-mbstring php-pdo mod_php php-gd php-ctype php-session php-pdo_mysql php-pgsql php-curl php-ldap php-xsl php-zip php-soap php-mbstring php-mysqli java-1.8.0-openjdk-devel curl git nodejs neo4j dotnet-sdk-2.1 nuget imagemagick-dev composer; 
## sudo apt -y install php8.0 php8.0-common php8.0-mysql php8.0-intl php8.0-json php8.0-xml php8.0-mcrypt php8.0-mbstring mod_php8.0 php8.0-gd php8.0-session php8.0-pgsql php8.0-curl php8.0-ldap php8.0-xsl php8.0-zip php8.0-soap php8.0-mbstring; 

## php8.0-bcmath            php8.0-curl-dbgsym       php8.0-gmp-dbgsym        php8.0-mysql             php8.0-pspell-dbgsym     php8.0-tidy
## php8.0-bcmath-dbgsym     php8.0-dba               php8.0-imap              php8.0-mysql-dbgsym      php8.0-readline          php8.0-tidy-dbgsym
## php8.0-bz2               php8.0-dba-dbgsym        php8.0-imap-dbgsym       php8.0-odbc              php8.0-readline-dbgsym   php8.0-xdebug
## php8.0-bz2-dbgsym        php8.0-dev               php8.0-interbase         php8.0-odbc-dbgsym       php8.0-snmp              php8.0-xml
## php8.0-cgi               php8.0-enchant           php8.0-interbase-dbgsym  php8.0-opcache           php8.0-snmp-dbgsym       php8.0-xml-dbgsym
## php8.0-cgi-dbgsym        php8.0-enchant-dbgsym    php8.0-intl              php8.0-opcache-dbgsym    php8.0-soap              php8.0-xsl
## php8.0-cli               php8.0-fpm               php8.0-intl-dbgsym       php8.0-pgsql             php8.0-soap-dbgsym       php8.0-zip
## php8.0-cli-dbgsym        php8.0-fpm-dbgsym        php8.0-ldap              php8.0-pgsql-dbgsym      php8.0-sqlite3           php8.0-zip-dbgsym
## php8.0-common            php8.0-gd                php8.0-ldap-dbgsym       php8.0-phpdbg            php8.0-sqlite3-dbgsym
## php8.0-common-dbgsym     php8.0-gd-dbgsym         php8.0-mbstring          php8.0-phpdbg-dbgsym     php8.0-sybase
## php8.0-curl              php8.0-gmp               php8.0-mbstring-dbgsym   php8.0-pspell            php8.0-sybase-dbgsym



## sudo apt install -y php8.0-{mysql,pgsql,sqlite3,bcmath,cli,common,imap,ldap,fpm,curl,mbstring,xml,zip};
## sudo apt install -y apache2 libapache2-mod-php8.0;
## sudo apt install -y nodejs build-essential
## sudo ufw allow 'WWW Full';
## sudo a2enmod proxy_fcgi setenvif;
## sudo a2enconf php8.0-fpm;
sudo apt-get install -y mariadb-server mariadb-client mariadb-backup;
## sudo systemctl reload apache2
sudo systemctl status mysqld;

### MariaDB Config Section ###
##sudo systemctl enable mysqld;
##sudo systemctl start mysqld;

sudo mysql -uroot < /var/data/sql/initmysql.sql;
### End MariaDB Config Section ###

