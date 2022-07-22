FROM phusion/baseimage:focal-1.2.0

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

RUN apt-key list 2>&1 | grep -E '\/(trusted.gpg.d)' -A 3 | grep -v '^\-\-' | grep -v '^pub ' | /bin/sed 's@.*/trusted.gpg.d/\(.*\)@\1@g' | /bin/awk 'NR%2{printf "%s ",$0;next;}1' | /bin/awk '{print "apt-key export "$10$11" | gpg --dearmour -o /usr/share/keyrings/"$1}' | xargs -I'{}' bash -c "eval '{}'"

RUN apt-get update && ln -s -f /bin/true /usr/bin/chfn && apt-get install --no-install-recommends -y mysql-server apache2 php7.4 php7.4-cli libapache2-mod-php7.4 php7.4-mysql php7.4-gd php7.4-curl php7.4-mbstring git wget unzip

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
  && sed -i 's/;extension=mbstring/extension=mbstring/g' /etc/php/7.4/apache2/php.ini

WORKDIR "/var/www/html/"
RUN rm -rf * \
#master
#  && git clone https://github.com/geoffhumphrey/brewcompetitiononlineentry.git . \
#tag
  && curl -s https://codeload.github.com/geoffhumphrey/brewcompetitiononlineentry/tar.gz/v2.5.0-beta | tar --strip-components=1 -xvzf - -C . \
  && rm -rf .github .git \
  && mv site /data/bcoem/ \
  && ln -s /data/bcoem/site /var/www/html/ \
  && mv user_* /data/bcoem/ \
  && find /data/bcoem/ -mindepth 1 -maxdepth 1 -type d -exec ln -s {} /var/www/html/ \;

# this has bugs, needs work
#RUN cd /var/www/html/ \
#  && /usr/local/bin/local-libs.sh \
#  && sed -i "s/define('CDN'.*/define('CDN', FALSE);/" paths.php

RUN chown -R www-data.www-data /var/www /data/bcoem

# workaround for login and mod rewrite issues when not using ssl - we need this to be predictible behind traefik
RUN sed -i 's/RewriteRule (\.\*) https.*/#/' /var/www/html/.htaccess

# this enabled the easy use of containers, ultimatly
RUN sed -i "s/define('ENABLE_MAILER.*/define('ENABLE_MAILER', TRUE);/" /var/www/html/paths.php

WORKDIR "/data"

# create a skeleton as live data will be on an external volume we may need to rebuild (we can rebuild!)
RUN mkdir /data.skel ; mv /data/* /data.skel/

VOLUME /data

EXPOSE 80/tcp

