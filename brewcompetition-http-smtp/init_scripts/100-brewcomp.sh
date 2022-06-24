#!/bin/bash
# various initialisations of config files
if [ ! -e /data/database ]; then cp -pr /data.skel/database /data/ ; fi
if [ ! -e /data/database/rando ]
then
  head -n45 /dev/urandom | tr -cd '[:alnum:]' | fold -w30 | head -n1 > /data/database/rando
fi
if [ ! -e /data/logs ]; then cp -pr /data.skel/logs /data/ ; fi
if [ ! -e /data/bcoem ]; then cp -pr /data.skel/bcoem /data/ ; fi

if [ ! -e /data/custom.sh ]; then cp -pr /usr/local/bin/custom.sh /data/ ; fi
/data/custom.sh

# copy new site files if they arrived in an update
if [ ! -e /data/bcoem/site/MysqliDb.php ]; then cp /data.skel/bcoem/site/MysqliDb.php /data/bcoem/site/ ; fi
if [ ! -e /data/bcoem/site/dbObject.php ]; then cp /data.skel/bcoem/site/dbObject.php /data/bcoem/site/ ; fi

# not a config file and should be updated when available
if [[ /data.skel/bcoem/site/bootstrap.php -nt /data/bcoem/site/bootstrap.php ]]; then
  cp /data/bcoem/site/bootstrap.php /data/bcoem/site/bootstrap.php.bak.$(date "+%Y.%m.%d-%H.%M.%S")
  cat /data.skel/bcoem/site/bootstrap.php >/data/bcoem/site/bootstrap.php
fi
if [[ /data.skel/bcoem/site/MysqliDb.php -nt /data/bcoem/site/MysqliDb.php ]]; then
  cp /data/bcoem/site/MysqliDb.php /data/bcoem/site/MysqliDb.php.bak.$(date "+%Y.%m.%d-%H.%M.%S")
  cat /data.skel/bcoem/site/MysqliDb.php >/data/bcoem/site/MysqliDb.php
fi

# we're a http server with a ssl proxy, strip this if it exists as it breaks barcodes
sed -i 's|^$base_url = "http://";|$base_url = "https://";|' /var/www/html/site/config.php

sed -i "s/^\$mail_default_from =.*/\$mail_default_from = '${MAIL_FROM}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_host =.*/\$smtp_host = '${SMTP_HOST}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_auth =.*/\$smtp_auth = '${SMTP_AUTH}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_username =.*/\$smtp_username = '${SMTP_USER}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_password =.*/\$smtp_password = '${SMTP_PASS}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_secure =.*/\$smtp_secure = '${SMTP_SEC}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_port =.*/\$smtp_port = '${SMTP_PORT}';/" /var/www/html/site/config.mail.php

sed -i "s/webmaster@localhost/${ADMIN_EMAIL}/" /etc/apache2/sites

/usr/local/bin/delayed-mysql.sh >/dev/null 2>&1 &
