#! /bin/bash
sleep 5s
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
    
    echo "SELECT 1 FROM baseline_contest_info LIMIT 1;" | mysql -u root beercomp
    if [ $(mysql -u root beercomp -sse "select count(*) from baseline_contest_info;") -gt 0 ];
    then
      echo "DB is good to go boss."
    else 
      mysql -u root beercomp < /var/www/html/sql/bcoem_baseline_2.*.sql
      echo "UPDATE baseline_brewer SET brewerEmail = '${ADMIN_EMAIL}' where id = '1';" | mysql -u root beercomp
      echo "UPDATE baseline_contacts SET contactEmail = '${ADMIN_EMAIL}' where id = '1';" | mysql -u root beercomp
      ADMIN_HASH=$(/usr/local/bin/get_hash.php)
      echo "UPDATE baseline_users SET user_name = '${ADMIN_EMAIL}', password = '${ADMIN_HASH}', userQuestionAnswer = 'Windjammers' WHERE id = '1';" | mysql -u root beercomp
      # TODO update some baseline defaults here so it works a bit better unconfigured. 
      echo "UPDATE baseline_preferences SET prefsSEF = 'Y';" | mysql -u root beercomp
      # don't rush home brewers
      sed -i 's/^\$session_expire_after =.*/\$session_expire_after = "90";/' /var/www/html/site/config.php
    fi
  fi 
  sleep 5s
done

