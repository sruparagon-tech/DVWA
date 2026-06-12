#!/bin/bash
service mariadb start
sleep 2

mysql -e "CREATE DATABASE IF NOT EXISTS dvwa;"
mysql -e "CREATE USER IF NOT EXISTS 'dvwa'@'localhost' IDENTIFIED BY 'p@ssw0rd';"
mysql -e "GRANT ALL ON dvwa.* TO 'dvwa'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '';" 2>/dev/null || true

# Copy config file jika belum ada
cd /var/www/html/DVWA
if [ ! -f config/config.inc.php ]; then
    cp config/config.inc.php.dist config/config.inc.php
    sed -i "s/'db_password' => ''/'db_password' => 'p@ssw0rd'/" config/config.inc.php
fi

# Ganti port Apache dengan $PORT dari Railway
sed -i "s/Listen 80/Listen ${PORT:-80}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT:-80}/g" /etc/apache2/sites-available/000-default.conf

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
