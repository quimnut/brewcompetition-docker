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
sed -i 's/^if (is_https/#if (is_https/' /var/www/html/site/config.php

# 2.2.0 tag needed this change
grep -q styles.inc.php /var/www/html/includes/db/common.db.php || sed -i "5 a require_once (INCLUDES.'styles.inc.php');" /var/www/html/includes/db/common.db.php
