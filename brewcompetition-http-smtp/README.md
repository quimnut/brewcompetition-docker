# brewcompetition-http-smtp

http image for use behind an edge router like traefik.

https://hub.docker.com/repository/docker/quimnut/brewcompetition-http-smtp

To import a previos comps db;
After running once to initialise, remove database directory and leave a file called loadme.sql in appdata/app/

To customise bcoe&m source (like clubs list) so it's persistant across restarts
edit custom.sh in appdata/app/

```
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
  <image>:<tag>
```
