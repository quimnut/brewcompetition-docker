FROM phusion/baseimage:0.11

MAINTAINER roach@dopegoat.com

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN mkdir -p /data/bcoem /data/logs /data/database ; chmod -R a+rx /data
COPY init_scripts/100-brewcomp.sh /etc/my_init.d
COPY init_scripts/apache2 /etc/service/apache2/run
COPY init_scripts/mysql /etc/service/mysql/run
COPY init_scripts/delayed-mysql.sh /usr/local/bin/
COPY init_scripts/get_hash.php /usr/local/bin/
COPY init_scripts/local-libs.sh /usr/local/bin/
COPY init_scripts/custom.sh /usr/local/bin/

RUN apt-get update && ln -s -f /bin/true /usr/bin/chfn && apt-get install --no-install-recommends -y mysql-server apache2 php7.2 php7.2-cli libapache2-mod-php7.2 php7.2-mysql php7.2-gd php7.2-curl git wget unzip

COPY init_scripts/beercomp-http.conf /etc/apache2/sites-available/

RUN mv /var/log/apache2 /data/logs/ \
  && ln -s /data/logs/apache2 /var/log/ \
  && a2dissite 000-default.conf \
  && a2ensite beercomp-http \
  && a2enmod rewrite headers \
  && mv /var/log/mysql /data/logs/ \
  && ln -s /data/logs/mysql /var/log/ \
  && mv /var/lib/mysql* /data/database/ \
  && find /data/database/ -mindepth 1 -maxdepth 1 -type d -exec ln -s {} /var/lib/ \; \
  && sed -i 's/;extension=mbstring/extension=mbstring/g' /etc/php/7.2/apache2/php.ini

WORKDIR "/var/www/html/"
RUN rm -rf * \
# aim for 2.1.19 tag next
  && git clone https://github.com/geoffhumphrey/brewcompetitiononlineentry.git . \
#  && curl -s https://codeload.github.com/geoffhumphrey/brewcompetitiononlineentry/tar.gz/v2.1.19 | tar --strip-components=1 -xvzf - -C . \
  && rm -rf .github .git \
  && mv site /data/bcoem/ \
  && ln -s /data/bcoem/site /var/www/html/ \
  && mv user_* /data/bcoem/ \
  && find /data/bcoem/ -mindepth 1 -maxdepth 1 -type d -exec ln -s {} /var/www/html/ \;

# this has bugs currently
#RUN cd /var/www/html/ \
#  && /usr/local/bin/local-libs.sh \
#  && sed -i "s/define('CDN'.*/define('CDN', FALSE);/" paths.php

RUN chown -R www-data.www-data /var/www /data/bcoem

# workaround for login and mod rewrite issues when not using ssl & enable smtp - as of 2.1.19pre
RUN sed -i 's/RewriteRule (\.\*) https.*/#/' /var/www/html/.htaccess \
  && sed -i "s/define('ENABLE_MAILER.*/define('ENABLE_MAILER', TRUE);/" /var/www/html/paths.php

# workaround for using the master branch 2.1.19pre as of 17/Jan/2020
RUN sed -i "s/define('TESTING'.*/define('TESTING', FALSE);/" /var/www/html/paths.php \
  && sed -i "s/define('DEBUG'.*/define('DEBUG', FALSE);/" /var/www/html/paths.php \
  && sed -i "s/define('DEBUG_SESSION_VARS'.*/define('DEBUG_SESSION_VARS', FALSE);/" /var/www/html/paths.php \
  && sed -i "s/))))/)))/" /var/www/html/includes/process/process_users_register.inc.php

WORKDIR "/data"

# create a skeleton as live data will be on an external volume we may need to rebuild (we can rebuild!)
RUN mkdir /data.skel ; mv /data/* /data.skel/

VOLUME /data

EXPOSE 80/tcp
