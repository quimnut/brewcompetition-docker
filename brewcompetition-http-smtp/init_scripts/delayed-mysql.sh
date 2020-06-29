#! /bin/bash
sleep 3s
mysql_down=true
while [ "$mysql_down" = true ]
do
  echo "FLUSH PRIVILEGES;"  | mysql -u root
  if [ $? -eq 0 ]
  then
    mysql_down=false
    echo "CREATE DATABASE IF NOT EXISTS beercomp" | mysql -u root

    RESULT_VARIABLE="$(mysql -u root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'beercomp')")"
    if [ "$RESULT_VARIABLE" -eq 0 ]
    then
      echo "CREATE USER 'beercomp'@'localhost';" | mysql -u root
      echo "ALTER USER 'beercomp'@'localhost' IDENTIFIED BY '$(cat /data/database/rando)';" | mysql -u root
      echo "GRANT ALL PRIVILEGES ON beercomp.* TO 'beercomp'@'localhost';" | mysql -u root
      echo "FLUSH PRIVILEGES;"  | mysql -u root
    fi

# database magic.
# if the defined database exists exit now

    DB_PREFIX=$(grep "^\$prefix = " config.php | cut -d'"' -f2)
    if [ $(mysql -u root beercomp -sse "select count(*) from ${DB_PREFIX}contest_info;") -gt 0 ]
    then
      echo "Found existing database"
      exit 0
    fi

# if there is no database as per the prefix, but there is dump to be loaded, we'll determine the prefix used and load the file
    if [ -f /data/loadme.sql ]
    then
      DB_PREFIX=$(grep contest_info /data/loadme.sql | grep 'CREATE TABLE' | cut -d'`' -f2 | sed -e 's/contest_info//')
      cat /data/loadme.sql | mysql -u root beercomp
      sed -i "s/^\$prefix =.*/\$prefix = \"${DB_PREFIX}\";/" /var/www/html/site/config.php
      sed -i 's/^\$username =.*/\$username = "beercomp";/' /var/www/html/site/config.php
      sed -i "s/^\$password =.*/\$password = \"$(cat /data/database/rando)\";/" /var/www/html/site/config.php
      sed -i 's/^\$database =.*/\$database = "beercomp";/' /var/www/html/site/config.php
      mv /data/loadme.sql /data/loaded.sql
      echo "Found loadme.sql and loaded it. good luck."
      exit 0
    fi
       
# finally no existing database and nothing to load, we'll load the baseline database and update the config for that prefix.
    
    if [ $(mysql -u root beercomp -sse "select count(*) from baseline_contest_info;") -gt 0 ]
    then
      echo "Baseline DB is already good to go boss."
    else 
      echo "Creating baseline database."
      cat $(ls -t1 /var/www/html/sql/*sql | head -n1) | mysql -u root beercomp
      echo "UPDATE baseline_brewer SET brewerEmail = '${ADMIN_EMAIL}' where id = '1';" | mysql -u root beercomp
      echo "UPDATE baseline_contacts SET contactEmail = '${ADMIN_EMAIL}' where id = '1';" | mysql -u root beercomp
      ADMIN_HASH=$(/usr/local/bin/get_hash.php)
      echo "UPDATE baseline_users SET user_name = '${ADMIN_EMAIL}', password = '${ADMIN_HASH}', userQuestionAnswer = '${ADMIN_EMAIL}' WHERE id = '1';" | mysql -u root beercomp
      sed -i 's/^\$prefix =.*/\$prefix = "baseline_";/' /var/www/html/site/config.php
      sed -i 's/^\$username =.*/\$username = "beercomp";/' /var/www/html/site/config.php
      sed -i "s/^\$password =.*/\$password = \"$(cat /data/database/rando)\";/" /var/www/html/site/config.php
      sed -i 's/^\$database =.*/\$database = "beercomp";/' /var/www/html/site/config.php

      # TODO update some baseline defaults here so it works a bit better unconfigured. 
      echo "UPDATE baseline_preferences SET prefsSEF = 'Y';" | mysql -u root beercomp
      # don't rush home brewers so much
      sed -i 's/^\$session_expire_after =.*/\$session_expire_after = "90";/' /var/www/html/site/config.php
    fi

  fi 
  sleep 1s
done

