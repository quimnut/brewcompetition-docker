# brewcompetition-http-smtp

http image for use behind an edge router like traefik.

To import a previous comps db;
After running once to initialise, remove database directory and leave a file called loadme.sql in appdata/app/

To customise bcoe&m source (like clubs list) so it's persistant across restarts
edit custom.sh in appdata/app/

To upgrade from a release older than 22 July 2022, export your database as appdata/app/loadme.sql, delete the database directory. Due to mysql 8.0 upgrade.

```
docker build .
docker run -d \
  -p 80:80 \
  -v /your/brewcompdata:/data \
  -e ADMIN_EMAIL=your@email.yay \
  -e ADMIN_PASS=paStrYSt00ts \
  -e MAIL_FROM=noreply@yourclub.com.au \
  -e SMTP_HOST=smtp.mailgun.org \
  -e SMTP_AUTH=TRUE \
  -e SMTP_USER=postmater@mg.yourclub.com.au \
  -e SMTP_PASS=paStrYSt00ts \
  -e SMTP_SEC=tls \
  -e SMTP_PORT=587 \
  -e TZ=Australia/Brisbane \
  brewcompetition-http-smtp
```
