#! /bin/bash
# put persistant changes in here if you need them.

# you can increase logging by changing this.
sed -i "s/define('TESTING'.*/define('TESTING', FALSE);/" /var/www/html/paths.php
sed -i "s/define('DEBUG'.*/define('DEBUG', FALSE);/" /var/www/html/paths.php
sed -i "s/define('DEBUG_SESSION_VARS'.*/define('DEBUG_SESSION_VARS', FALSE);/" /var/www/html/paths.php

# disable mysql strict mode as it fails hard on quick adding participants at least with an imported database.
cat << EOF > /etc/mysql/conf.d/disable_strict_mode.cnf
[mysqld]
sql_mode=IGNORE_SPACE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
EOF

# supress php warning
mkdir -p /var/www/html/classes/htmlpurifier/standalone/HTMLPurifier/DefinitionCache/Serializer
chown www-data.www-data /var/www/html/classes/htmlpurifier/standalone/HTMLPurifier/DefinitionCache/Serializer

