#! /bin/bash
# put persistant changes in here if you need them.

# you can increase logging by changing this.
sed -i "s/define('TESTING'.*/define('TESTING', FALSE);/" /var/www/html/paths.php 
sed -i "s/define('DEBUG'.*/define('DEBUG', FALSE);/" /var/www/html/paths.php 
sed -i "s/define('DEBUG_SESSION_VARS'.*/define('DEBUG_SESSION_VARS', FALSE);/" /var/www/html/paths.php 

# disable mysql strict mode as it fails hard on quick adding participants at least with an imported database.
cat << EOF > /etc/mysql/conf.d/disable_strict_mode.cnf
[mysqld]
sql_mode=IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
EOF

# supress php warning
mkdir -p /var/www/html/classes/htmlpurifier/standalone/HTMLPurifier/DefinitionCache/Serializer
chown www-data.www-data /var/www/html/classes/htmlpurifier/standalone/HTMLPurifier/DefinitionCache/Serializer

# breaks barcode check in, ssl logic in app code boohoo
# we're a http server with a ssl proxy
sed -i 's|^$base_url = "http://";|$base_url = "https://";|' /var/www/html/site/config.php

# not a config file and should be updated when available
if [[ /data.skel/bcoem/site/bootstrap.php -nt /data/bcoem/site/bootstrap.php ]]; then
  cp /data/bcoem/site/bootstrap.php /data/bcoem/site/bootstrap.php.bak.$(date "+%Y.%m.%d-%H.%M.%S")
  cat /data.skel/bcoem/site/bootstrap.php >/data/bcoem/site/bootstrap.php
fi
