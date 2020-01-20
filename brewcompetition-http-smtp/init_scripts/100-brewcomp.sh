#!/bin/bash
# various initialisations of config files
if [ ! -e /data/database ]; then cp -pr /data.skel/database /data/ ; fi
if [ ! -e /data/database/rando ]
then 
  head -n45 /dev/urandom | tr -cd '[:alnum:]' | fold -w30 | head -n1 > /data/database/rando
fi
if [ ! -e /data/logs ]; then cp -pr /data.skel/logs /data/ ; fi
if [ ! -e /data/bcoem ]; then cp -pr /data.skel/bcoem /data/ ; fi

sed -i 's/^\$prefix =.*/\$prefix = "baseline_";/' /var/www/html/site/config.php
sed -i 's/^\$username =.*/\$username = "beercomp";/' /var/www/html/site/config.php
sed -i "s/^\$password =.*/\$password = \"$(cat /data/database/rando)\";/" /var/www/html/site/config.php
sed -i 's/^\$database =.*/\$database = "beercomp";/' /var/www/html/site/config.php

sed -i "s/^\$mail_default_from =.*/\$mail_default_from = '${MAIL_FROM}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_host =.*/\$smtp_host = '${SMTP_HOST}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_auth =.*/\$smtp_auth = '${SMTP_AUTH}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_username =.*/\$smtp_username = '${SMTP_USER}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_password =.*/\$smtp_password = '${SMTP_PASS}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_secure =.*/\$smtp_secure = '${SMTP_SEC}';/" /var/www/html/site/config.mail.php
sed -i "s/^\$smtp_port =.*/\$smtp_port = '${SMTP_PORT}';/" /var/www/html/site/config.mail.php

sed -i "s/webmaster@localhost/${ADMIN_EMAIL}/" /etc/apache2/sites

/usr/local/bin/delayed-mysql.sh >/dev/null 2>&1 &
